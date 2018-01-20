local battleDistantMapLayer = class("battleDistantMapLayer", cocosMake.viewBase)
battleDistantMapLayer.ui_resource_file = {}
battleDistantMapLayer.ui_binding_file = {}
battleDistantMapLayer.notify = {""}

function battleDistantMapLayer:onCreate()
    --��ͼ���ز�
    local mapLayer = cocosMake.newLayer()
    mapLayer:setPosition(0,0)
    self:addChild(mapLayer)
    self.mapLayer = mapLayer

    --map
    local mapImage = cocosMake.newSprite(FIGHTMAP_UIPATH .. "/penglai_background.png", 0, 0)
    mapImage:setScale(2)
    mapImage:setAnchorPoint(cc.p(0.0,1.0))
    mapLayer:addChild(mapImage)
    self.mapImage = mapImage
    

    local imageTexture = mapImage:getTexture()
    local imageSize = imageTexture:getContentSize()
    --local imageWide = imageTexture:getPixelsWide()
    self.mapVisibleSize = imageSize--��ͼ���ӷ�Χ

    self.mapScreenSize = display.frameSize--��Ļ���ӷ�Χ

    self.moveScale = 0.2--Զ���ƶ�����

end

function battleDistantMapLayer:onClose()
end

function battleDistantMapLayer:setMapVisibleSize(sz)
    self.mapVisibleSize = sz
end

function battleDistantMapLayer:setScreenSize(sz)
    self.mapScreenSize = sz
end

function battleDistantMapLayer:getMovePosition()
    return self.mapLayer:getPositionX()
end
function battleDistantMapLayer:setMovePosition(posValue)
    self.mapLayer:setPositionX(posValue)
end

function battleDistantMapLayer:moveLayer(moveValueX, moveValueY, type)
    if type == 1 then--�̶�ֵ�ƶ�
        local mvValue = moveValueX*self.moveScale
        local curPos = self:getMovePosition()
        local move = curPos + mvValue
        self:setMovePosition(move)
    end
end

function battleDistantMapLayer:handleNotification(notifyName, body) 
end


return battleDistantMapLayer
