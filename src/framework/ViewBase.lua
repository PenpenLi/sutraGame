local ViewBase = class("ViewBase", cocosMake.Layer)


function ViewBase:ctor(param)
    param = param or {}
	log(param)
    self:enableNodeEvents()
    self.name___ = param.name or ""
    self.moudle___ = param.moudle or ""

    self:createResoueceUINode()

    -- 处理所有结点可以直接通过“self.”访问
    WidgetHelp:dealChildren(self)

    self:createResoueceBinding()
    
	cc.load("event"):setEventDispatcher(self, GameController)
end

function ViewBase:getName()
    return self.name_
end

function ViewBase:createNodeByCsb(file)
    return cc.CSLoader:createNode(file .. ".csb")
end

function ViewBase:createResoueceUINode()
    if not self.ui_resource_file then
        return 
    end
    for k, v in pairs(self.ui_resource_file) do
        local name = tostring(v)
        print("读取 csb :" .. name)
        self[name] = cc.CSLoader:createNode(name .. ".csb")
        assert(self[name], string.format("ViewBase:createResoueceNode() - load resouce node from file \"%s\" failed", name))
        self:addChild(self[name])
		
		----screen适配，以命名约束适配点
		local function adapt(nd, nodeName)
			local upperName = string.upper(nodeName)
			if string.find(upperName, "PANEL") then
				if upperName == "LEFTBOTTOMPANEL" or upperName == "BOTTOMLEFTPANEL" then nd:setPosition(display.left_bottom)
				elseif upperName == "LEFTCENTERPANEL" or upperName == "CENTERLEFTPANEL" then nd:setPosition(display.left_center)
				elseif upperName == "LEFTTOPPANEL" or upperName == "TOPLEFTPANEL" then nd:setPosition(display.left_top)
				elseif upperName == "BOTTOMCENTERPANEL" or upperName == "CENTERBOTTOMPANEL" then nd:setPosition(display.bottom_center)
				elseif upperName == "CENTERPANEL" then nd:setPosition(display.center)
				elseif upperName == "TOPCENTERPANEL" or upperName == "CENTERTOPPANEL" then nd:setPosition(display.top_center)
				elseif upperName == "RIGHTBOTTOMPANEL" or upperName == "BOTTOMRIGHTPANEL" then nd:setPosition(display.right_bottom)
				elseif upperName == "RIGHTCENTERPANEL" or upperName == "CENTERRIGHTPANEL" then nd:setPosition(display.right_center)
				elseif upperName == "RIGHTTOPPANEL" or upperName == "TOPRIGHTPANEL" then nd:setPosition(display.right_top) end
			elseif string.find(upperName, "BACKGROUND") then
				local ndResource = nd:getVirtualRenderer():getSprite():getResourceName()
				local beginIndex, endIndex, n1, n2, imgtp = string.find(ndResource, "(%d+)-(%d+)(.jpg+)")
				if display.perfect_resolution[1] ~= tonumber(n1) or display.perfect_resolution[2] ~= tonumber(n2) then
					ndResource = string.sub(ndResource, 1, beginIndex-1) .. display.perfect_resolution[1] .. "-" .. display.perfect_resolution[2] .. imgtp
					nd:loadTexture(ndResource)
					log("change screen slot ", ndResource, display.perfect_resolution[1], display.perfect_resolution[2], n1, n2)
				end
				nd:setPosition(display.center)
				nd:setContentSize(display.viewSize.width, display.viewSize.height)
				
			end
		end
		local function traverseChildren(parent)
			local children = parent:getChildren()
			for i,v in ipairs(children) do
				--adapt(v, v:getName())
				traverseChildren(v, root)
			end
		end
		traverseChildren(self[name])
        --[[
        if v and "table" == type(v) and 0 < #v then
            for kk, vv in pairs(v) do
                local childName = tostring(vv)
                local child = cc.CSLoader:createNode("csb/" .. childName .. ".csb")
                assert(child, string.format("ViewBase:createResoueceNode() - load resouce node from file \"%s\" failed", childName))
                self[name]:addChild(child)
                self[name][childName] = child
            end
        end
        --]]
    end
    --[[
    if self.resourceNode_ then
        self.resourceNode_:removeSelf()
        self.resourceNode_ = nil
    end
    self.resourceNode_ = cc.CSLoader:createNode(resourceFilename)
    assert(self.resourceNode_, string.format("ViewBase:createResoueceNode() - load resouce node from file \"%s\" failed", resourceFilename))
    self:addChild(self.resourceNode_)
    --]]
end

function ViewBase:createResoueceBinding()
    if not self.ui_binding_file then
        return 
    end
	
    for nodeName, nodeBinding in pairs(self.ui_binding_file) do
		if nodeBinding.name then
            local nodepath = string.split(nodeBinding.name, ".")
            local widget = self
            local flag = true -- 是否找到最终节点
            for k,v in ipairs(nodepath) do
                widget = widget[v]
                if not widget then
                    flag = false -- 未找到最终节点
                    break
                end
            end
            if widget and flag then
                self[nodeName] = widget
            end
        end
        if self[nodeName] then
            if nodeBinding.method and self[nodeBinding.method] then
                if nodeBinding.event == "touch" then
                    self[nodeName]:onTouch(handler(self, self[nodeBinding.method]))
					if self[nodeName].getRendererClicked then
						local clickSpr = self[nodeName]:getRendererClicked()
						clickSpr:setColor(cc.c3b(150, 150, 150))--設置按下狀態
					end
					
                elseif nodeBinding.event == "click" then--button clicked
					local func = handler(self, self[nodeBinding.method])
					self[nodeName]:setTouchEnabled(true)
					self[nodeName]:onClicked(function(...)  func(...) end)
					if self[nodeName].getRendererClicked then
						local clickSpr = self[nodeName]:getRendererClicked()
						clickSpr:setColor(cc.c3b(150, 150, 150))--設置按下狀態
					end
					
                end
            end
        end
    end
end

function ViewBase:createRoleData()
    local roleDataName = self.name___ .. "Data"
    local status, view = xpcall(function()
            return require(self.moudle___ .. "." .. roleDataName)
        end, function(msg) end)
    local t = type(view)
    if status and (t == "table" or t == "userdata") then
        view = view:create({name=roleDataName})
        view:onCreate()
        self.data_ = view
    end
end

function ViewBase:showFloat(layername, param)
    local layer = LayerManager.showFloat(layername, param)
    return layer
end

function ViewBase:closeFloat(layername)
    local layer = LayerManager.closeFloat(layername)
    return layer
end

--页面销毁的时候会调用
function ViewBase:onClose()
end



return ViewBase
