
----------------------------------------------------------
-- desc:游戏中对话框基类
----------------------------------------------------------

local DialogBase = class("DialogBase", cocosMake.Node)

-- @param isModal boolean 是否是模态对话框
-- @param offSiteClose boolean 点击界外关闭
function DialogBase:ctor(param)
	
	self.isModal = param.modal or false
    self.offClose = param.offClose or false
	-- 模态对话框屏蔽底层触摸事件
	if self.isModal then
		local touchLayer = cocosMake.newLayer({r=0.0/255.0, g=0.0/255.0, b=0.0/255.0, a=0.5}, {width=3000, height=6000})
		self:addChild(touchLayer)
		self.touchLayer=touchLayer
		touchLayer:onTouch(function (event)
			if event.name == "began" then
				return true
			elseif event.name == "ended" then
				if self.offClose then
					LayerManager.closeFloat(self)
				end
			end
		end, false, true)
	end
	
	
	self:enableNodeEvents()
	
	cc.load("event"):setEventDispatcher(self, GameController)
	
	--创建csb布局
    self:createResoueceUINode()

    -- 处理所有结点可以直接通过“self.”访问
    WidgetHelp:dealChildren(self)

    --创建控件绑定
    self:createResoueceBinding()
	
end

function DialogBase:createResoueceUINode()
    if not self.ui_resource_file then
        return 
    end
    for k, v in pairs(self.ui_resource_file) do
        local name = tostring(v)
        print("读取 csb :" .. name)
        self[name] = cc.CSLoader:createNode(name .. ".csb")
        assert(self[name], string.format("ViewBase:createResoueceNode() - load resouce node from file \"%s\" failed", name))
        self:addChild(self[name])
		self[name]:setPosition(display.center)
    end
end


function DialogBase:createResoueceBinding()
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


function DialogBase:getTouchLayer()
	return self.touchLayer
end

return DialogBase