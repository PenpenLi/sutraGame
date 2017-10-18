local battleScene = class("battleScene", cocosMake.viewBase)
battleScene.ui_resource_file = {}
battleScene.ui_binding_file = {}
battleScene.notify = {"notify_shakeBattleScene", 
"notify_initEmbattleSiteSign", "notify_clearEmbattleSiteSign", "notify_setEmbattleSiteSignData", 
"notify_showSelectToFightHero"}

local z_battleMapLayer = 8
local z_battleDistantMapLayer = 4
local z_battleLayer = 16
local z_touchMoveLayer = 32



function battleScene:onCreate()
    

    --战斗场景大小
    self.battleVisibleSize = {}
    self.battleVisibleSize.width = 1700
    self.battleVisibleSize.height = 640


     --前景地图
   self.battleMapLayer = self:showFloat(luaFile.fightBattleMapLayer, {director = self})   
   self.battleMapLayer:setPosition(display.visibleRect.leftBottom.x, display.visibleRect.leftBottom.y)
   self.battleMapLayer:setLocalZOrder(z_battleMapLayer)

   --远景地图
   self.battleDistantMapLayer = self:showFloat(luaFile.fightBattleDistantMapLayer, {director = self})
   self.battleDistantMapLayer:setPosition(display.visibleRect.leftTop.x, display.visibleRect.leftTop.y)
   self.battleDistantMapLayer:setLocalZOrder(z_battleDistantMapLayer)

    --战场层
   self.battleLayer = self:showFloat(luaFile.battleLayer, {director = self})
   self.battleLayer:setPosition(display.visibleRect.leftBottom.x, display.visibleRect.leftBottom.y)
   self.battleLayer:setLocalZOrder(z_battleLayer)

   --移动控制
   self.battleMoveControl = self:showFloat("layer.fight.battle.battleMoveControl")
   self.battleMoveControl:setViewVisibleSize(display.frameSize)
   self.battleMoveControl:registerMoveLayer(self.battleMapLayer)
   self.battleMoveControl:registerMoveLayer(self.battleDistantMapLayer)
   self.battleMoveControl:registerMoveLayer(self.battleLayer)
   self.battleMoveControl:setLocalZOrder(z_touchMoveLayer)

   self.battleLayer:setBattleSize(self.battleMoveControl:getSizeVisibleSize())
   self.battleMoveControl:percentMove(50)

   self.shaking = false
end

function battleScene:createEmbattleSiteLayer(args)
    if self.embattleSiteLayer then
        self.embattleSiteLayer:removeFromParent(true)
    end

    self.embattleSiteLayer = cocosMake.newLayer()
    local layer = self.embattleSiteLayer
    self.battleLayer.battleGroundLayer:addChild(self.embattleSiteLayer)
    
    self.embattleSiteLayer.signList = {}
    local siteSignList = {}
    for k,v in pairs(args.data) do
        local imgPath = "buzhen/selectMoveEffect.png"
        local img = cocosMake.newSprite(FIGTHUI_UIPATH..imgPath)
        img:setPosition(v.pos.x, v.pos.y)
        v.img = img
        layer:addChild(img)
        siteSignList[tonumber(k)] = v
    end
    self.embattleSiteLayer.signList = siteSignList
end
function battleScene:clearEmbattleSiteLayer()
    if self.embattleSiteLayer then
        self.embattleSiteLayer:removeFromParent(true)
        self.embattleSiteLayer = nil
    end
end
function battleScene:changeEmbattleSiteData(body)
    for k,v in pairs(body.changeInfo) do
        local imgPath = "buzhen/selectMoveEffect.png"
        if v.kezhi then
            imgPath = "buzhen/selectMoveEffect_kezhi.png"
        elseif v.beikezhi then
            imgPath = "buzhen/selectMoveEffect_beikezhi.png"
        end
        self.embattleSiteLayer.signList[v.site].img:setTexture(FIGTHUI_UIPATH..imgPath)
    end
end
function battleScene:onClose()
end

function battleScene:handleNotification(notifyName, body)
    if notifyName == "notify_shakeBattleScene" then
        self:shake()

    elseif notifyName == "notify_initEmbattleSiteSign" then
        self:createEmbattleSiteLayer(body)
    
    elseif notifyName == "notify_clearEmbattleSiteSign" then
        self:clearEmbattleSiteLayer()

    elseif notifyName == "notify_setEmbattleSiteSignData" then
        self:changeEmbattleSiteData(body)

    elseif notifyName == "notify_showSelectToFightHero" then
        local x,y = body.object:getPosition()
        local pos = self.battleLayer.battleGroundLayer:convertToNodeSpace(cc.p(x,y))--坐标转换到fightlayer
        body.object:setPosition(pos)
        body.object:setGlobalZOrder(99999)
        self.battleLayer.battleFightLayer:addChild(body.object)
    end
end

function battleScene:shake()
    if not self.shaking then
        self.shaking = true
        local time = 0.03
        local moveOffset = 10
        local sequence = transition.sequence({
                    CCMoveBy:create(time, cc.p(0, moveOffset)),
                    CCMoveBy:create(time, cc.p(moveOffset/2, -moveOffset)),
                    CCMoveBy:create(time, cc.p(-moveOffset/2, -moveOffset)),
                    CCMoveBy:create(time, cc.p(-moveOffset/2, moveOffset)),
                    CCMoveBy:create(time, cc.p(moveOffset/2, 0)),
                    CCMoveBy:create(time, cc.p(0, moveOffset)),
                    CCMoveBy:create(time, cc.p(moveOffset/2, -moveOffset)),
                    CCMoveBy:create(time, cc.p(-moveOffset/2, -moveOffset)),
                    CCMoveBy:create(time, cc.p(-moveOffset/2, moveOffset)),
                    CCMoveBy:create(time, cc.p(moveOffset/2, 0)),
                    cc.CallFunc:create(function() self.shaking = false end )
                })
        self:runAction(sequence)
    end
end

return battleScene
