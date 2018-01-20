local battleFightLayer = class("battleFightLayer", cocosMake.viewBase)
battleFightLayer.ui_resource_file = {}
battleFightLayer.ui_binding_file = {}
battleFightLayer.notify = {""}

local bubbleHp_z = 2048
local bullet_z = 1280

local updateShowBubbleHp_time = 0.15
local updateShowbubble_time = 0.2
function battleFightLayer:onCreate()
    self.objectList = {}

    local bubbleHpLayer = cocosMake.newLayer()
    bubbleHpLayer:setLocalZOrder(bubbleHp_z)
    self:addChild(bubbleHpLayer)
    bubbleHpLayer:setPosition(cc.p(0,0))
    self.bubbleHpLayer = bubbleHpLayer
    
    local bulletLayer = cocosMake.newLayer()
    bulletLayer:setLocalZOrder(bullet_z)
    self:addChild(bulletLayer)
    bulletLayer:setPosition(cc.p(0,0))
    self.bulletLayer = bulletLayer
    

    --Ã°Ñª »º´æ
    self.bubbleHpCache = {}
    local function UpdateShowBubbleHp(args) self:UpdateShowBubbleHp() end
    schedule(self, UpdateShowBubbleHp, updateShowBubbleHp_time)

    --·ÉÐÐÎäÆ÷ »º´æ
    self.bulletCache = {}
    --local function UpdateShowBullet(args) self:UpdateShowBullet() end
    --schedule(self, UpdateShowBullet, updateShowbubble_time)

end

function battleFightLayer:onClose()
end



function battleFightLayer:handleNotification(notifyName, body) 
end

function battleFightLayer:addObject(obj)
    if obj:getType() == ObjectDefine.objectType.bullet then
        self:addBullet(obj)

    else
        self:addChild(obj)
        obj.parentLayer = self--objectµÄ¸¸Àà
        self.objectList[obj:getKey()] = obj
    end
end

function battleFightLayer:delObject(key)
    if self.objectList[key] then
        performWithDelay(self, function()
            local obj = self.objectList[key]
            if obj then
                obj:stopAllActions()
                obj:removeFromParent(true)

                self.objectList[key] = nil       
            end
        end, 0)

    elseif self.bulletCache[key] then
        self.bulletCache[key]:stopAllActions()
        self.bulletCache[key]:removeFromParent(true)
        self.bulletCache[key] = nil
    end
end

function battleFightLayer:addBullet(obj)
    self.bulletLayer:addChild(obj)
    self.bulletCache[obj:getKey()] = obj
    obj:play()

    --obj:setVisible(false)
    --table.insert(self.bulletCache, {obj=obj})
end

function battleFightLayer:UpdateShowBullet()
    for k,v in pairs(self.bulletCache) do
        v:setVisible(true)
    end
end

function battleFightLayer:UpdateShowBubbleHp()
    for i=1, #self.bubbleHpCache do
        local info = self.bubbleHpCache[i]

        local bubble = nil
        
        if tonumber(info.txt) > 0 then
            bubble = cocosMake.newLabelAtlas(info.txt,FNT_UIPATH.."atlas_green1.png",26,26,43)
        else
            bubble = cocosMake.newLabelAtlas(info.txt,FNT_UIPATH.."atlas_red1.png",26,26,43)
        end

        self.bubbleHpLayer:addChild(bubble)
        bubble:setAnchorPoint(cc.p(0.5,0.5))
        bubble:setPosition(cc.p(info.posx, info.posy))
    

        if info.color then
            bubble:setColor(info.color)
        end
    
        local sequence = transition.sequence({
                CCScaleTo:create(0.2, 1.3 * info.scale),
                CCScaleTo:create(0.2, 1 * info.scale),
                CCMoveBy:create(0.5, cc.p(0, 20)),
                CCFadeOut:create(0.2),
                cc.RemoveSelf:create()
            })
       bubble:runAction(sequence)
    end

    self.bubbleHpCache = {}
end

function battleFightLayer:addBubbleHp(txt, posx, posy, scale)
    table.insert(self.bubbleHpCache, {txt=txt, posx=posx, posy=posy, scale=scale})
end

return battleFightLayer
