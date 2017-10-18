local fightKezhiLayer = class("fightKezhiLayer", cocosMake.viewBase)
fightKezhiLayer.ui_resource_file = {}

fightKezhiLayer.ui_binding_file = {}
fightKezhiLayer.notify = {}

function fightKezhiLayer:onCreate(param)
    
end

function fightKezhiLayer:onClose()
end

--kezhiSite: site, pos
function fightKezhiLayer:setKezhi(followLeader, sitePoslist, kezhiSite, beikezhiSite, zhongkeSite, beizhongkeSite)
    if self.kezhiLayer then
        self.kezhiLayer:removeFromParent(true)
    end
    local kezhiLayer = cocosMake.newLayer()
    self:addChild(kezhiLayer, 1)
    kezhiLayer.followLeader = followLeader

    kezhiLayer.sitePoslist = DeepCopy(sitePoslist)

    local fx, fy = followLeader:getPosition()

    local kezhiArrow = {}
    for k,v in pairs(kezhiSite) do
        local jt = cocosMake.newSprite(FIGTHUI_UIPATH .. "buzhen/kezhi.png")
        jt:setOpacity(128)
        kezhiLayer:addChild(jt)
        local vtin = DeepCopy(v)
        vtin.pos.y = vtin.pos.y + 20

        local char = cocosMake.newSprite(FIGTHUI_UIPATH .. "buzhen/kezhi_char.png")
        local cpos = cc.p(followLeader:getParent():convertToWorldSpace(cc.p(vtin.pos.x, vtin.pos.y+20)))
        char:setPosition(cpos)
        kezhiLayer:addChild(char)

        table.insert(kezhiArrow, {arrow=jt, char=char, dright = vtin, orgSize = jt:getContentSize()})
    end
    kezhiLayer.kezhiArrow = kezhiArrow
    
    local beikeArrow = {}
    for k,v in pairs(beikezhiSite) do
        local jt = cocosMake.newSprite(FIGTHUI_UIPATH .. "buzhen/beikehzi.png")
        jt:setOpacity(128)
        kezhiLayer:addChild(jt)
        local vtin = DeepCopy(v)
        vtin.pos.y = vtin.pos.y + 20

        local char = cocosMake.newSprite(FIGTHUI_UIPATH .. "buzhen/beike_char.png")
        local cpos = cc.p(followLeader:getParent():convertToWorldSpace(cc.p(vtin.pos.x, vtin.pos.y+20)))
        char:setPosition(cpos)
        kezhiLayer:addChild(char)

        table.insert(beikeArrow, {arrow=jt, char=char, dright = vtin, orgSize = jt:getContentSize()})
    end
    kezhiLayer.beikeArrow = beikeArrow
    --[[
    local zhongkeArrow = {}
    for k,v in pairs(kezhiSite) do
        local jt = cocosMake.newSprite(FIGTHUI_UIPATH .. "buzhen/zhongke.png")
        jt:setAnchorPoint(cc.p(0, 0.5))
        jt:setPosition(fx, fy)
        jt.dright = DeepCopy(v)
        jt.orgSize = jt:getContentSize()
        table.insert(zhongkeArrow, jt)
    end
    kezhiLayer.zhongkeArrow = zhongkeArrow

    local beizhongkeArrow = {}
    for k,v in pairs(kezhiSite) do
        local jt = cocosMake.newSprite(FIGTHUI_UIPATH .. "buzhen/zhongbeike.png")
        jt:setAnchorPoint(cc.p(0, 0.5))
        jt:setPosition(fx, fy)
        jt.dright = DeepCopy(v)
        jt.orgSize = jt:getContentSize()
        table.insert(beizhongkeArrow, jt)
    end
    kezhiLayer.beizhongkeArrow = beizhongkeArrow
    --]]
    self.kezhiLayer = kezhiLayer
    self:movingUpdate()
end

function fightKezhiLayer:movingUpdate()
    local arrowOnt = nil--实体线
    local gx=50
    local gy=40

    for k,v in pairs(self.kezhiLayer.kezhiArrow) do
        if arrowOnt then
            break
        else
            local leaderPos = cc.p( self.kezhiLayer.followLeader:getPosition() )
            local dirPos = v.dright.pos
            local dirSite = v.dright.site
            local dis = cc.pGetDistance(leaderPos, dirPos)
            local arrow = v.arrow
            local char = v.char
            local s = dis/v.orgSize.width
            arrow:setScaleX(s)
       
            local cpos = cc.p(self.kezhiLayer.followLeader:getParent():convertToWorldSpace(leaderPos))
            arrow:setPosition(cc.p(cpos.x, cpos.y+30))
        
            local sin = math.abs(dirPos.y - leaderPos.y) / dis
            local asin = math.asin(sin)
            local arg = math.deg(asin)
            if leaderPos.x > dirPos.x then
                arrow:setFlipX(true)
                arrow:setAnchorPoint(cc.p(1, 0.5))
                arrow:setRotation(leaderPos.y > dirPos.y and -arg or arg)
            else
                arrow:setFlipX(false)
                arrow:setAnchorPoint(cc.p(0, 0.5))
                arrow:setRotation(leaderPos.y > dirPos.y and arg or -arg)
            end
            arrow:setOpacity(128)
            char:setOpacity(255)

            for k,v in pairs(self.kezhiLayer.sitePoslist) do
                if leaderPos.x > (v.x - gx) and leaderPos.x < (v.x + gx) and leaderPos.y > (v.y - gy) and leaderPos.y < (v.y + gy) then
                    local site = k - math.floor((k-1)/3) * 3
                    if dirSite == site then
                        arrowOnt = arrow
                        arrow:setOpacity(255)
                        break
                    end
                end
            end
        end
    end
    --if true then return true end
    for k,v in pairs(self.kezhiLayer.beikeArrow) do
        if arrowOnt then
            break
        else
           local leaderPos = cc.p( self.kezhiLayer.followLeader:getPosition() )
            local dirPos = v.dright.pos
            local dirSite = v.dright.site
            local dis = cc.pGetDistance(leaderPos, dirPos)
            local arrow = v.arrow
            local char = v.char
            local s = dis/v.orgSize.width
            arrow:setScaleX(s)
            
            local parent = self.kezhiLayer.followLeader:getParent()
            local cpos = cc.p(parent:convertToWorldSpace(leaderPos))
            arrow:setPosition(cc.p(cpos.x, cpos.y+30))
        
            local sin = math.abs(dirPos.y - leaderPos.y) / dis
            local asin = math.asin(sin)
            local arg = math.deg(asin)
            if leaderPos.x > dirPos.x then
                arrow:setFlipX(true)
                arrow:setAnchorPoint(cc.p(1, 0.5))
                arrow:setRotation(leaderPos.y > dirPos.y and -arg or arg)
            else
                arrow:setFlipX(false)
                arrow:setAnchorPoint(cc.p(0, 0.5))
                arrow:setRotation(leaderPos.y > dirPos.y and arg or -arg)
            end
            arrow:setOpacity(128)
            char:setOpacity(255)

            for k,v in pairs(self.kezhiLayer.sitePoslist) do
                if leaderPos.x > (v.x - gx) and leaderPos.x < (v.x + gx) and leaderPos.y > (v.y - gy) and leaderPos.y < (v.y + gy) then
                    local site = k - math.floor((k-1)/3) * 3
                    if dirSite == site then
                        arrowOnt = arrow
                        arrow:setOpacity(255)
                        break
                    end
                end
            end 
        end
    end

    if arrowOnt then
        for k,v in pairs(self.kezhiLayer.kezhiArrow) do
            if v.arrow ~= arrowOnt then v.arrow:setOpacity(0) v.char:setOpacity(0) end
        end
        for k,v in pairs(self.kezhiLayer.beikeArrow) do
            if v.arrow ~= arrowOnt then v.arrow:setOpacity(0) v.char:setOpacity(0) end
        end
    end
end

function fightKezhiLayer:unshowKezhiLayer()
    self.kezhiLayer:removeFromParent(true)
    self.kezhiLayer = nil
end

return fightKezhiLayer
