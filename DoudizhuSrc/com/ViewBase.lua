local ViewBase = class("ViewBase", cocosMake.Layer)


function ViewBase:ctor(param)
    self:enableNodeEvents()
    self.name___ = param.name or ""
    self.moudle___ = param.moudle or ""

    --创建csb布局
    self:createResoueceUINode()
    --创建控件绑定
    self:createResoueceBinding()
    
end

function ViewBase:getName()
    return self.name_
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
            for k,v in pairs(nodepath) do
                local widgetChild = nil
                if not widget[v] then
                    widgetChild = widget:getChildByName(v)
                    if not widgetChild then break end
                    widget[v] = widgetChild
                end
                widget = widget[v]
            end
            if widget then
                self[nodeName] = widget
                if nodeBinding.event and nodeBinding.method and nodeBinding.event == "touch" then
                    widget:onTouch(handler(self, self[nodeBinding.method]))
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
    local layer = LayerManager.showFloat(layername, self, param)
    return layer
end

function ViewBase:closeFloat(layername, param)
    local layer = LayerManager.closeFloat(layername, self)
    return layer
end

--页面销毁的时候会调用
function ViewBase:onClose()
end



return ViewBase
