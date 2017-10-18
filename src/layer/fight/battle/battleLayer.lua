local battleLayer = class("battleLayer", cocosMake.viewBase)
battleLayer.ui_resource_file = {}
battleLayer.ui_binding_file = {}
battleLayer.notify = {"addObjectToFightLayer_notify", "delObjectToFightLayer_notify",
"addObjectToAirLayer_notify", "delObjectToAirLayer_notify",
"addObjectToGroundLayer_notify","delObjectToGroundLayer_notify",
}


function battleLayer:onCreate(param)
    local containLayer = cocosMake.newLayer()--承载层
    containLayer:setPosition(0,0)
    self:addChild(containLayer)
    self.containLayer = containLayer

    self.battleSize = {width=display.frameSize.widget, height=display.frameSize.height}--战场大小

    --天空(0)
   self.battleAirLayer = self:showFloat(luaFile.fightBattleAirLayer)
   self.battleAirLayer:addAgainTo(containLayer)
   self.battleAirLayer:setLocalZOrder(16)
   
    --地面(2)
   self.battleGroundLayer = self:showFloat(luaFile.fightBattleGroundLayer)
   self.battleGroundLayer:addAgainTo(containLayer)
   self.battleGroundLayer:setLocalZOrder(4)

    --战斗层(1)
   self.battleFightLayer = self:showFloat(luaFile.fightBattleFightLayer)
   self.battleFightLayer:addAgainTo(containLayer)
   self.battleFightLayer:setLocalZOrder(8)

end

function battleLayer:onClose()
end

function battleLayer:setBattleSize(sz)
    self.battleSize.width = sz.width
    self.battleSize.height = sz.height
end

function battleLayer:addObjectToFightLayer(obj)
   self.battleFightLayer:addObject(obj) 
end

function battleLayer:addObjectToAirLayer(obj)
   self.battleAirLayer:addObject(obj) 
end

function battleLayer:addObjectToGroundLayer(obj)
   self.battleGroundLayer:addObject(obj) 
end

function battleLayer:delObjectToGroundLayer(obj)
   self.battleGroundLayer:delObject(obj) 
end

function battleLayer:delObjectFromFightLayer(key)
   self.battleFightLayer:delObject(key)
end

function battleLayer:delObjectFromAirLayer(key)
   self.battleAirLayer:delObject(key)
end


-------------------移动 begin
function battleLayer:moveLayer(moveValueX,moveValueY, type)
    if type == 1 then--固定值移动
        local curPosX,curPosY = self:getMovePosition()
        local moveX = curPosX + moveValueX or 0
        local moveY = curPosY + moveValueY or 0
        self:setMovePosition(moveX, moveY)
    end
end

function battleLayer:getMovePosition()
    return self.containLayer:getPosition()
end
function battleLayer:setMovePosition(posValueX,posValueY)
    self.containLayer:setPosition(posValueX,posValueY)
end
-------------------移动 end

function battleLayer:handleNotification(notifyName, body)
    if notifyName == "addObjectToFightLayer_notify" then--添加对象
        self:addObjectToFightLayer(body.object)
    
    elseif notifyName == "delObjectToFightLayer_notify" then--删除对象
        self:delObjectFromFightLayer(body.key)    
     
    elseif notifyName == "addObjectToAirLayer_notify" then
        self:addObjectToAirLayer(body.object)
    
    elseif notifyName == "delObjectToAirLayer_notify" then
        self:delObjectFromAirLayer(body.key)    

    elseif notifyName == "addObjectToGroundLayer_notify" then
        self:addObjectToGroundLayer(body.object)
      
    elseif notifyName == "delObjectToGroundLayer_notify" then
        self:delObjectToGroundLayer(body.key) 
        
    end
end

return battleLayer
