local battleAirLayer = class("battleAirLayer", cocosMake.viewBase)
battleAirLayer.ui_resource_file = {}
battleAirLayer.ui_binding_file = {}
battleAirLayer.notify = {""}

function battleAirLayer:onCreate()
    self.objectList = {}
end

function battleAirLayer:onClose()
end

function battleAirLayer:handleNotification(notifyName, body) 
end


function battleAirLayer:addObject(obj)
    self:addChild(obj)
    self.objectList[obj:getKey()] = obj
end

function battleAirLayer:delObject(key)
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

return battleAirLayer
