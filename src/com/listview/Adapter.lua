
Adapter = class("Adapter")

----------------------------------------------------------@type name
--适配器
----------------------------------------------------------
--用法举例
--
--    require("src/Com/ListView1")
--    require("src/Adapter")
--    local winSize = cc.Director:getInstance():getWinSize()
--
--    --创建
--    local tableView= ListView1:create({size = cc.size(400,60),spacing = 100,
--           pos = cc.p(20, winSize.height / 2),direction = ListView1.H,})
--
--    layer:addChild(tableView)  --添加
--
--    local adapter = Adapter:create({count = 125})   --创建适配器
--
--    adapter:setMode(function(cell,index)       --设置模板(接口1)
--
--        cclog("Adapter:insertMode == "..index)
--        local strValue = string.format("%d",index)
--        local sprite = cc.Sprite:create("res/Icon.png")
--        sprite:setAnchorPoint(cc.p(0,0))
--        sprite:setPosition(cc.p(0, 0))
--        cell:addChild(sprite)
--        local label = nil
--        label = cc.LabelTTF:create(strValue, "", 20.0)
--        label:setPosition(cc.p(0,0))
--        label:setAnchorPoint(cc.p(0,0))
--        label:setTag(123)
--        cell:addChild(label)
--    end)
--
--    adapter:setModeData(function(cell,index)   --修改数据(接口2)
--        cclog("Adapter:modify == "..index)
--        local lab = cell:getChildByTag(123)
--        lab:setString(index)
--    end)
--
--    tableView:setAdapter(adapter)    --设置适配器(设置适配器一定要在上面2个接口之后)
--
--    --以下代码测试刷新数据
--    cc.Director:getInstance():getScheduler():scheduleScriptFunc(function()
--           cclog("刷新")
--           adapter:updateModify()
--    end,3,false)
----------------------------------------------------------

function Adapter:create(parameters)
    self = self.new()
    self:init(parameters)
    return self
end

function Adapter:init(parameters)
    self.par = parameters or {}
    self.count = self.par.count     --创建item的个数
    self.array = self.par.array or {}
end

-------------------------------------------------------------
--listview调用，外界不用管

function Adapter:getCount()
    return table.maxn(self.array)
end

--插入模板
function Adapter:insertMode(cell,index)  --添加模板
    self.cells = self.cells or {}
    cell.index = index
    --table.insert(self.cells,cell)
    self.cells[cell.index] = cell
    self.mode_create_call = self.mode_create_call or function ()end
    self.mode_create_call(cell,index)
    
end

--修改数据
function Adapter:modify(cell,index)  --修改模板数据
    --local lab = cell:getChildByTag(123)
    --lab:setString(index)
    cell.index = index
    self.mode_modify_call = self.mode_modify_call or function ()end
    self.mode_modify_call(cell,index)
end

--点击事件
function Adapter:itemClick(cell,index)
    self.touch_call = self.touch_call or function ()end
    self.touch_call(cell,index)
end

function Adapter:itemHightLight(cell,index)
    self.hightlight_call = self.hightlight_call or function ()end
    self.hightlight_call(cell,index)
end

function Adapter:itemUnHightLight(cell,index)
    self.unhightlight_call = self.unhightlight_call or function ()end
    self.unhightlight_call(cell,index)
end

-------------------------------------------------------------

--设置模板
function Adapter:setMode(mode_create_call)
    self.mode_create_call = mode_create_call
end

--设置数据
function Adapter:setModeData(mode_modify_call)
    self.mode_modify_call = mode_modify_call
end

--当数据发生改变时，调用此方法更新数据
function Adapter:updateModify(temp)
	
    if nil ~= temp then
		self.parent:resetDrawRunner()
		self.parent.tableView:reloadData()
	else
		for k,cell in pairs(self.cells or {}) do
			self:modify(cell,cell.index)  --修改模板数据
		end
    end

end

--点击事件
function Adapter:touchListener(touch_call)
    self.touch_call = touch_call
end

function Adapter:hightlightListener(touch_call)
    self.hightlight_call = touch_call
end

function Adapter:unhightlightListener(touch_call)
    self.unhightlight_call = touch_call
end

return Adapter

