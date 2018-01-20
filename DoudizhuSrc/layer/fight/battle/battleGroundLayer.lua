local battleGroundLayer = class("battleGroundLayer", cocosMake.viewBase)
battleGroundLayer.ui_resource_file = {}
battleGroundLayer.ui_binding_file = {}
battleGroundLayer.notify = {""}

function battleGroundLayer:onCreate()
    self.objectList = {}
end

function battleGroundLayer:onClose()
end

function battleGroundLayer:handleNotification(notifyName, body) 
end


function battleGroundLayer:addObject(obj)
    self:addChild(obj)
    self.objectList[obj:getKey()] = obj
end

function battleGroundLayer:delObject(key)
    if self.objectList[key] then
        
        performWithDelay(self, function()
            local obj = self.objectList[key]
            if obj then
                obj:stopAllActions()
                obj:removeFromParent(true)

                self.objectList[key] = nil       
            end
        end, 0)
    end
end

return battleGroundLayer
