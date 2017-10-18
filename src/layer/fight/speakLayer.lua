local speakLayer = class("speakLayer", cocosMake.viewBase)
speakLayer.ui_resource_file = {}
speakLayer.ui_binding_file = {}
speakLayer.notify = {""}

function speakLayer:onCreate()
end

function speakLayer:onClose()
end

function speakLayer:handleNotification(notifyName, body)
    
end


return speakLayer
