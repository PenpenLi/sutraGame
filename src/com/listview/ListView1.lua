ListView1 = class("ListView1",cocosMake.Layer)
require("com.listview.Adapter")
require("com.listview.DrawRunner")
--[[
--示例
local dataList = {}
for i=1,10 do 
    table.insert(dataList, {i=i,tip="位置："..i})
end
local function createItem (index)
    local ui = self:createNodeByCsb("HomeLayer_ScrollItem") 
    print("创建：" .. index .. "," .. dataList[index].tip)
    return ui
end
local function udateItem (item, index)
    print("更新：" .. index .. "," .. dataList[index].tip)
end
local function clickItem (item, index)
    print("点击了：" .. index .. "," .. dataList[index].tip)
end
local myListview = ListView1:create({size = self.HomeLayerUI.scrollPanel:getContentSize(),
                    pos = cc.p(0,0),spacing = 200 ,direction = ListView1.V, createItem=createItem, udateItem=udateItem, clickItem=clickItem})
self.HomeLayerUI.scrollPanel:addChild(myListview)
myListview:setData(dataList)
--]]
function ListView1:create(parameters)
    self = self.new()

    --注册事件
    local function onNodeEvent(event)
        if "enter" == event then
            self:onEnter()
        elseif "exit" == event then
            self:onExit()
        end
    end
    self:registerScriptHandler(onNodeEvent)

    self:init(parameters)  
    return self
end



ListView1.H = cc.SCROLLVIEW_DIRECTION_HORIZONTAL
ListView1.V = cc.SCROLLVIEW_DIRECTION_VERTICAL

function ListView1:init(parameters)
    self.par = parameters or {}
    self.size = self.par.size or cc.size(400,60)  --tableview的size
    self.direction = self.par.direction or ListView1.V --方向
    self.pos = self.par.pos or cc.p(0,0)   --位置
    self.spacing = self.par.spacing or 60   --间距
    self.orginSpacing = self.par.spacing    --原间距，不改变
    self.closeDrawRunner = self.par.closeDrawRunner   --是否需要滑条
    self.closeBorder = self.par.closeBorder			--是否需要顶部和底部的遮黑
	self.createItem = self.par.createItem       --創建和初始化Item的函數，return item
    self.udateItem = self.par.udateItem       --更新Item的函數
    self.clickItem = self.par.clickItem       --點擊Item的函數
    self.hightlightItem = self.par.hightlightItem       --touchbegin
    self.unhightlightItem = self.par.unhightlightItem   --touchOver (begin error | move | end | cancle)
    local tableView = cc.TableView:create(self.size)
    self.tableView = tableView
    tableView:setDirection(self.direction)
    tableView:setPosition(self.pos)
	tableView:setTag(555)
    tableView:setDelegate()
	
    self:addChild(tableView)

    if self.closeDrawRunner == nil then
	    local drawRunnerPra = self.par.drawRunnerPra or {}
	    if drawRunnerPra then
	    	drawRunnerPra.size = drawRunnerPra.size or self.size
	    	drawRunnerPra.pos = drawRunnerPra.pos or self.pos
	    	self.drawRunner = DrawRunner:create(drawRunnerPra)
	    	self:addChild(self.drawRunner,19)
	    end
	end

	if self.closeBorder == nil then
	    local borderPra = self.par.borderPra or {}
	    if borderPra then
	    	borderPra.size = borderPra.size or self.size
	    	borderPra.posTop = borderPra.posTop or cc.p(borderPra.size.width * 0.5 + self.pos.x,borderPra.size.height + self.pos.y)
	    	borderPra.posBottom = borderPra.posBottom or cc.p(borderPra.size.width * 0.5 + self.pos.x,self.pos.y)
	    	self.visibleSpriteTopLeft = cc.Scale9Sprite:create("res/heibian.png",cc.rect(1,1,20,17),cc.rect(0,0,0,0))
	    	self.visibleSpriteBottomRight = cc.Scale9Sprite:create("res/heibian.png",cc.rect(1,1,20,17),cc.rect(0,0,0,0))
			self.visibleSpriteBottomRight:setScaleY(-1)
	    	if self.direction == ListView1.V then
	    		self.visibleSpriteTopLeft:setContentSize(cc.size(borderPra.size.width,17))
	    		self.visibleSpriteTopLeft:setPosition(cc.pAdd(borderPra.posTop,cc.p(0,-8.5) ))
	    		self.visibleSpriteBottomRight:setContentSize(cc.size(borderPra.size.width,17))
	    		self.visibleSpriteBottomRight:setPosition(cc.pAdd(borderPra.posBottom , cc.p(0,8.5)))
	    	end
	    	self.visibleSpriteTopLeft:setVisible(false)
	    	self.visibleSpriteBottomRight:setVisible(false)
	    	self:addChild(self.visibleSpriteTopLeft,20)
	    	self:addChild(self.visibleSpriteBottomRight,20)
	    end
	end  

    local function numberOfCellsInTableView(table)
		return self.adapter:getCount()
	end

	local function cellSizeForTable(table,idx)
		local tab = self.adapter.array[self.adapter:getCount() - idx]
		--cclog("type =====%s",tab)
		if 	type(tab) == "table" then
			--cclog("11111111111")
			if tab.spacing then
				self.spacing = tab.spacing
			end
		end
		--cclog("cellSizeForTable ================= %s %s",idx,self.spacing)
		return self.spacing,self.spacing  --纵向，横向距离
	end

	local function scrollViewDidScroll(view)
		-- print("scrollViewDidScroll")
		--self.view = view
		
		-- local offset = view:getContentOffset()
		-- self.offset = offset

		--print( "offset.x , offset.y === ", offset.x , offset.y)
		if self.offetListener then
			self.offetListener(view:getContentOffset())
		end
		
		if self.offetIndexListener then
			local offset = view:getContentOffset()
			local offsetSize = 0
			local sizeY = self.adapter:getCount() * self.spacing
			if self.direction == ListView1.V then
				offsetSize = offset.y
			else
				offsetSize = offset.x
			end
			local index = math.floor( ( sizeY + offsetSize ) / self.spacing)
			
			self.offetIndexListener(index)
		end
		
		if self.drawRunner then
			if self.maxOffset == nil then
				self.maxOffset = view:getContentOffset()
			end

			if self.visibleSpriteTopLeft then
				self.visibleSpriteTopLeft:setVisible(true)
			end
			if self.visibleSpriteBottomRight then
	    		self.visibleSpriteBottomRight:setVisible(true)
	    	end

			local contentOffset = view:getContentOffset()
			local ratio = nil

			if self.direction == ListView1.V then
				if contentOffset.y <= self.maxOffset.y then
					contentOffset.y = self.maxOffset.y
					if self.visibleSpriteTopLeft then self.visibleSpriteTopLeft:setVisible(false) end
    				-- if self.visibleSpriteBottomRight then self.visibleSpriteBottomRight:setVisible(false) end
				end
				if contentOffset.y >= 0 then
					contentOffset.y = 0
					-- if self.visibleSpriteTopLeft then self.visibleSpriteTopLeft:setVisible(false) end
    				if self.visibleSpriteBottomRight then self.visibleSpriteBottomRight:setVisible(false) end
				end
				ratio = contentOffset.y / self.maxOffset.y
				self.drawRunner.frontSprite:setPosition(self.drawRunner.frontSprite:getPositionX(),
				(self.drawRunner.backSprite:getContentSize().height - self.drawRunner.frontSprite:getContentSize().height)* ratio)
			end
		end
	end

	local function scrollViewDidZoom(view)
		print("scrollViewDidZoom")
	end

	local function tableCellTouched(table,cell)
		local idx = cell:getIdx()
		if self.direction == ListView1.V then
			idx = self.adapter:getCount() - idx
		else
			idx = idx + 1
		end
		self.adapter:itemClick(cell,idx)
	end

    local function tableCellHighLight(table,cell)
        local idx = cell:getIdx()
		if self.direction == ListView1.V then
			idx = self.adapter:getCount() - idx
		else
			idx = idx + 1
		end
		self.adapter:itemHightLight(cell,idx)
	end

    local function tableCellUnHighLight(table,cell)
        local idx = cell:getIdx()
		if self.direction == ListView1.V then
			idx = self.adapter:getCount() - idx
		else
			idx = idx + 1
		end
		self.adapter:itemUnHightLight(cell,idx)
	end

	local function tableCellAtIndex(table, idx)
		if self.direction == ListView1.V then
			idx = self.adapter:getCount() - idx
		else
			idx = idx + 1
		end
		local cell = table:dequeueCell()
		if nil == cell then
			cell = cc.TableViewCell:new()

			local view = self.adapter:insertMode(cell,idx)  --插入
			if view then cell:addChild(view) end
		else
			self.adapter:modify(cell,idx)  --修改
		end

		return cell
	end
	local function eventHand(table,parameters) --@return typeOrObject
	
	end	
	
	
	
    --registerScriptHandler functions must be before the reloadData funtion
    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)  
    tableView:registerScriptHandler(scrollViewDidScroll,cc.SCROLLVIEW_SCRIPT_SCROLL)
    tableView:registerScriptHandler(scrollViewDidZoom,cc.SCROLLVIEW_SCRIPT_ZOOM)
    tableView:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
    tableView:registerScriptHandler(tableCellHighLight,cc.TABLECELL_HIGH_LIGHT)
    tableView:registerScriptHandler(tableCellUnHighLight,cc.TABLECELL_UNHIGH_LIGHT)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    --tableView:reloadData()

    local listviewAdapter = Adapter:create({array = {}})
    self.listviewAdapter = listviewAdapter
    if self.createItem then
        listviewAdapter:setMode(function(cell,index)
            local ui = self.createItem(index)
            cell:addChild(ui,0,100)
        end)
    end
    if self.udateItem then
        listviewAdapter:setModeData(function(cell,index)
		    local ui = cell:getChildByTag(100)
            if ui then
                self.udateItem(ui, index)
            end 
        end)
    end
    if self.clickItem then
        listviewAdapter:touchListener(function(cell,index)
		    self.clickItem(cell, index)
	    end)
    end
    if self.hightlightItem then
        listviewAdapter:hightlightListener(function(cell,index)
		    self.hightlightItem(cell, index)
	    end)
    end
    if self.unhightlightItem then
        listviewAdapter:unhightlightListener(function(cell,index)
		    self.unhightlightItem(cell, index)
	    end)
    end
    --gameListView:setClickListener(function(cell,index) print("1gameListView.点击了第" .. index .. "个") end)
    self:setAdapter(listviewAdapter)

    return true
end

function ListView1:setAdapter(adapter)
    self.adapter = adapter
    adapter.parent = self
    self.tableView:reloadData()
end

function ListView1:setData(dataArray)
	local dataTemp = {}
    for k,v in pairs(dataArray) do
        table.insert(dataTemp, v)
    end

    self.listviewAdapter.array = dataTemp
	self.listviewAdapter:updateModify(#dataTemp == 0)
end

function ListView1:resetDrawRunner()
	self.maxOffset = nil
end

--设置Y便宜
function ListView1:setOffsetYIndex(offset)
	local pos = self.tableView:getContentOffset()	
	self.tableView:setContentOffset( cc.p( pos.x ,pos.y+offset), false)
end

--设置便宜
function ListView1:setOffsetXIndex(temp)
	local offset = self.tableView:getContentOffset()
	--print("offset ==== ",offset.x,offset.y)
	local offsetSize = 0
	local sizeY = self.adapter:getCount() * self.spacing
	if self.direction == ListView1.V then
		offsetSize = offset.y
	else
		offsetSize = offset.x
	end
	
	local addOffset =  - temp * self.spacing
	local limitIndex = self.adapter:getCount() - (self.size.width/self.spacing)
	local index 
	if addOffset > 0 then
		index = math.ceil(offsetSize / self.spacing)
		print("setOffsetXIndex ==111=== ",index)
		if index >= 0 then
		else
			index = math.ceil( ( addOffset + offsetSize ) / self.spacing)
		end
	else
		index = math.ceil(offsetSize / self.spacing)
		print("setOffsetXIndex ==222=== ",index)
		if index <= -limitIndex then
		else
			index = math.ceil( ( addOffset + offsetSize ) / self.spacing)
		end
	end
	print("偏移 ===== ",index * self.spacing)
	self.tableView:setContentOffset( cc.p( index * self.spacing ,0),true)
end

--移动偏移监听，移动的x，y距离
function ListView1:setOffsetListener(tap)
	self.offetListener = tap
end

--移动便宜的index（未完全展现，则不计数）
function ListView1:getOffsetIndex(tap)
	self.offetIndexListener =  tap
end

--设置点击,如果设置了点击了监听(setClickListener)，则会触发响应;  点击回调 第三个参数标识是否在点击此控件里面，需要判断（具体用法参考 Liveness 类 ）
function ListView1:setClick(bg)
	local function onTouchBegan(touch, event)
		local target = event:getCurrentTarget()
		local locationInNode = target:convertToNodeSpace(touch:getLocation())
		local s = target:getContentSize()
		local rect = cc.rect(0, 0, s.width, s.height)
		
		local locationInNode1 = self.tableView:convertToNodeSpace(touch:getLocation())
		local s1 = self.size
		local rect1 = cc.rect(0, 0, s1.width, s1.height)
		
		if cc.rectContainsPoint(rect, locationInNode) and cc.rectContainsPoint(rect1, locationInNode1) then
			target.isMove = false
			target.pos = touch:getLocation()
			if self.call_back then
				self.call_back(target,ccui.TouchEventType.began,true)
			end
			
			return true
		end
		return false
	end

	local function onTouchMoved(touch, event)
		local target = event:getCurrentTarget()
		-- target.isMove = true
		
		
		local locationInNode = target:convertToNodeSpace(touch:getLocation())
		local s = target:getContentSize()
		local rect = cc.rect(0, 0, s.width, s.height)

		if cc.rectContainsPoint(rect, locationInNode) then
			if self.call_back then
				self.call_back(target,ccui.TouchEventType.move,true)    --第三个参数标识是否在点击此控件里面
			end
		else
			if self.call_back then
				self.call_back(target,ccui.TouchEventType.move,false)
			end
		end
	end

	local function onTouchEnded(touch, event)
		local target = event:getCurrentTarget()
		-- target:setSelected(false)
		local locationInNode = target:convertToNodeSpace(touch:getLocation())
		local s = target:getContentSize()
		local rect = cc.rect(0, 0, s.width, s.height)

		local location = touch:getLocation()
		
		-----------------------------------------------------------------
		--判断移动距离
		local des = 0
		if self.direction == ListView1.V then   --横向移动
			des = math.abs(location.y - target.pos.y)
		else  --纵向移动
			des = math.abs(location.x - target.pos.x)
		end
		
		if des > 0.5 then
			target.isMove = true
		else
			target.isMove = false
		end
		
		------------------------------------------------------------------

		if cc.rectContainsPoint(rect, locationInNode) and not target.isMove then
			--print("onTouchEnded")
			if self.call_back then
				self.call_back(target,ccui.TouchEventType.ended,true)
			else
				print("未设置点击监听")
			end
		else
			if self.call_back then
				self.call_back(target,ccui.TouchEventType.ended,false)
			else
				print("未设置点击监听")
			end
		end
	end

	--注册触摸事件
	local listener = cc.EventListenerTouchOneByOne:create()
	listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
	listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
	listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
	
	local eventDispacher = bg:getEventDispatcher()
	eventDispacher:addEventListenerWithSceneGraphPriority(listener,bg)

end
function ListView1:setTouchEnableds( bool )
	self.tableView:setTouchEnabled(bool)
end

--设置点击回调监听
function ListView1:setClickListener(call_back)
	self.call_back = call_back
end

function ListView1:onEnter()
    local scheduler = cc.Director:getInstance():getScheduler()
    self.aHand = scheduler:scheduleScriptFunc(function ()
    	if self.direction == ListView1.V then
   			if self.adapter:getCount() * self.orginSpacing <= self.size.height * 1.1 then
   				if self.drawRunner ~= nil then
   					self.drawRunner:setVisible(false)
   				end
   			else
   				if self.drawRunner ~= nil then
   					self.drawRunner:setVisible(true)
   				end
   			end
   		else
   			if self.adapter:getCount() * self.orginSpacing <= self.size.width then
   				if self.drawRunner ~= nil then
   					self.drawRunner:setVisible(false)
   				end
   			else
   				if self.drawRunner ~= nil then
   					self.drawRunner:setVisible(true)
   				end
   			end
   		end
    end, 0.1, false)
end

function ListView1:onExit()
    local scheduler = cc.Director:getInstance():getScheduler()
    scheduler:unscheduleScriptEntry(self.aHand)
end












