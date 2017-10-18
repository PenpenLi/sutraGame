local UILayer = class("UILayer", cocosMake.viewBase)

--规范
UILayer.ui_resource_file = {}--cocos studio生成的csb

UILayer.ui_binding_file = {--控件绑定
}

UILayer.notify = {}--通知

function UILayer:onCreate()
    print("UILayer:onCreate")
    self:__initShow()
end

function UILayer:onClose()
    print("UILayer:onClose")
end

function UILayer:__initShow()
    self:showFloat(luaFile.MainUI)
    local layer = self:showFloat(luaFile.ResUI)
    self:reorderChild(layer,en_Zorder_ResUI)
    layer = self:showFloat(luaFile.MsgFloatUI)
    self:reorderChild(layer,en_Zorder_MsgFloatUI)
end

function UILayer:handleNotification(notifyName, body)
end
--------------------------------------------------------------------------------------------------------------------
return UILayer

