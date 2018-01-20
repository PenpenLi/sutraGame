local battleMapLayer = class("battleMapLayer", cocosMake.viewBase)
battleMapLayer.ui_resource_file = {}
battleMapLayer.ui_binding_file = {}
battleMapLayer.notify = {""}

function battleMapLayer:onCreate()
    --地图承载层
    local mapLayer = cocosMake.newLayer()
    mapLayer:setPosition(0,0)
    self:addChild(mapLayer)
    self.mapLayer = mapLayer

    --map image
    local ran = math.random(2,5)
    local mapImage = cocosMake.newSprite(FIGHTMAP_UIPATH .. "/penglai_front"..ran..".png", 0, 0)
    mapImage:setScale(2)
    mapImage:setAnchorPoint(cc.p(0,0))
    mapLayer:addChild(mapImage)

    BATTLE_MAP_Y_OFFSET = -60
    mapImage:setPosition(cc.p(0, BATTLE_MAP_Y_OFFSET))
    self.mapImage = mapImage
    
    --local imageTexture = mapImage:getTexture()
    --local imageSize = imageTexture:getContentSize()
end

function battleMapLayer:onClose()
end


function battleMapLayer:getMovePosition()
    return self.mapLayer:getPosition()
end
function battleMapLayer:setMovePosition(posValueX,posValueY)
    self.mapLayer:setPosition(posValueX,posValueY)
end

function battleMapLayer:moveLayer(moveValueX,moveValueY, type)
    if type == 1 then--固定值移动
        local curPosX,curPosY = self:getMovePosition()
        local moveX = curPosX + moveValueX or 0
        local moveY = curPosY + moveValueY or 0
        self:setMovePosition(moveX, moveY)
    end
    
end

function battleMapLayer:handleNotification(notifyName, body) 
end


return battleMapLayer
