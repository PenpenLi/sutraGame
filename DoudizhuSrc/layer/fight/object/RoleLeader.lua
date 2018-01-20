--将领
local RoleLeader = class("RoleLeader", require(luaFile.RoleBase))
RoleLeader.notify = {"fightWin_role_notify"}
RoleLeader[".isclass"] = true

function RoleLeader:ctor(param)
    self:init(param)
end

function RoleLeader:handleNotification(notifyName, body)
    if notifyName == "fightWin_role_notify" then
        if not self:isDead() then
            self:fightWinFunc()
        end
    end
end

function RoleLeader:init(param)
    self.roleAi:setOwner(self)
    self.roleAi:registerAI(ObjectDefine.Ai.run, "AI_run")
    self.roleAi:registerAI(ObjectDefine.Ai.idle, "AI_Idle")
    self.roleAi:registerAI(ObjectDefine.Ai.seekFoe, "AI_seekFoe")
    self.roleAi:registerAI(ObjectDefine.Ai.runToFoe, "AI_runToFoe")
    self.roleAi:registerAI(ObjectDefine.Ai.attack, "AI_attack")
    self.roleAi:registerAI(ObjectDefine.Ai.charge, "AI_charge")
    self.roleAi:registerAI(ObjectDefine.Ai.dead, "AI_dead")
    self.roleAi:registerAI(ObjectDefine.Ai.fightWin, "AI_fightWin")
    self.roleAi:registerAI(ObjectDefine.Ai.freeze, "AI_freeze")
    self.roleAi:registerAI(ObjectDefine.Ai.skillAttack, "AI_skillAttack")
    
    --站的位置
    self.site = param.site or 1
    self.soldiersCount = param.soldiersCount or 1

    --士兵列表
    self.soldiersList = {}

    --攻击目标
    self.attackObjInfo = {}

    self:setMyPosition()
    self:createSoldiersList()

    self.roleAi:setAi(ObjectDefine.Ai.idle)
    
    self:initTopHeadUI()

    self:updateZOrder()
    
    g_fightLogic:updateVSHP({type=updateHP_Type.upLimit_addHp, hp=self.roleProperty:getHP(), camp=self:getCamp()})

    --人物动作名称
    self.attack_anim_name = ROLE_ATTACK_ANIMATION_NAME
    self.move_anim_name = ROLE_RUN_ANIMATION_NAME
    --self.skeleton:setScale(0.80)
end


function RoleLeader:getSite()
    return self.site
end

function RoleLeader:setGlobalZOrder_(z)
    self.skeleton:setGlobalZOrder(z)
    if z > 0 then
        self.heroTopInfo:setVisible(false)
    else
        self.heroTopInfo:setVisible(true)
    end
end

function RoleLeader:setSite(s)
    self.site = s
    self:setMyPosition()
    self:setSoldierPosition()
end

function RoleLeader:starGame()
    self.roleAi:setAi(ObjectDefine.Ai.charge)
    self:startRoleSchedule()

    
    if self.starGameWithJob then self:starGameWithJob() end
end

function RoleLeader:fightWinFunc()
    self:stopRoleSchedule()
    self.roleAi:setAi(ObjectDefine.Ai.fightWin)
end

function RoleLeader:initTopHeadUI()
    local heroTopInfo = cocosMake.newSprite(FIGTHUI_UIPATH.."rolename_bg.png")
    heroTopInfo:setAnchorPoint(cc.p(0.5, 0.0))
    heroTopInfo:setPosition(0, 135)
    self:addChild(heroTopInfo)
    self.heroTopInfo = heroTopInfo

    local hpUIBG = cocosMake.newUILoadingBar({sprite=FIGTHUI_UIPATH.."tiao_lilte_bg.png"})
    hpUIBG:setAnchorPoint(cc.p(0, 0))
    heroTopInfo:addChild(hpUIBG)
    hpUIBG:setPosition(5, -16)

    local hpUI = cocosMake.newUILoadingBar({sprite=FIGTHUI_UIPATH.. (self:campIsOwn() and "role_hp_own.png" or "role_hp.png") })
    hpUI:setAnchorPoint(cc.p(0, 0))
    hpUI:setPosition(6, -15)
    heroTopInfo:addChild(hpUI)
    self.hpUI = hpUI

    
    local vitalUIBG = cocosMake.newUILoadingBar({sprite=FIGTHUI_UIPATH.."tiao_lilte_bg.png"})
    vitalUIBG:setAnchorPoint(cc.p(0, 0))
    heroTopInfo:addChild(vitalUIBG)
    vitalUIBG:setPosition(5, -26)

    local vitalUI = cocosMake.newUILoadingBar({sprite=FIGTHUI_UIPATH.."role_nengliang.png", percent=0})
    vitalUI:setAnchorPoint(cc.p(0, 0))
    vitalUI:setPosition(6, -25)
    heroTopInfo:addChild(vitalUI)
    self.vitalUI = vitalUI
    if not self:campIsOwn() then
        vitalUIBG:setVisible(false)
        vitalUI:setVisible(false)
    end
    
    local sz = heroTopInfo:getContentSize()
   --local roleName = cocosMake.newLabelTTF(self.roleData.name, {size=20})    
    local roleName = ccui.Text:create(self.roleData.name,"font/fzy4jw.ttf",18)
    roleName:setAnchorPoint(cc.p(0.5, 0.5))
    roleName:setPosition(sz.width/2, sz.height/2)
    roleName:enableOutline(cc.c4b(42,23,11,255),1)

    if self:campIsOwn() then
        --白绿蓝紫橙
        local q = self.roleData.beginQuelity
        local c = cc.c3b(214, 201, 176)--白
        if q == 5 then
            c = cc.c3b(220, 126, 25)--橙
        elseif q == 4 then
            c = cc.c3b(192, 73, 236)--紫
        elseif q == 3 then
            c = cc.c3b(50, 122, 254)--蓝
        elseif q == 2 then
            c = cc.c3b(96, 162, 67)--绿
        end
        roleName:setColor(c)
    else
        roleName:setColor(cc.c3b(168, 57, 52))
    end
    heroTopInfo:addChild(roleName)
    self.roleName = roleName
    
    
end

function RoleLeader:addHp_callback()
    local hp = self.roleProperty:getHP()
    local hpmax = self.roleProperty:getHPMax()
    self.hpUI:setPercent( 100*(hp/hpmax) )
end


function RoleLeader:updateVital_callback()
    self.vitalUI:setPercent( 100*(self.roleProperty.vitalValue/self:getVitalMax()) )

    if not self:campIsOwn() then
        if self:getVitalMax() == self.roleProperty.vitalValue then
            self:playSkill()
        end    
    end
end

function RoleLeader:setMyPosition()
    local myPos = nil
    if self:getCamp() == ObjectDefine.Camp.enemy then
        myPos = g_fightLogic.emBattleProgram.enemy.getLeader(self.site)
        
    elseif self:getCamp() == ObjectDefine.Camp.own then
        myPos = g_fightLogic.emBattleProgram.own.getLeader(self.site)
    end
    
    self:setPosition(cc.p(myPos.x, myPos.y))
    self:setLocalZOrder(myPos.z)

    self.offsetScale = 1
    local s = g_fightLogic.emBattleProgram.getscale(self.site)
    self:setScale(s*self.offsetScale)
end

--初始化我的士兵
function RoleLeader:createSoldiersList()
    
    local sList = {}
    for i=1,self.soldiersCount do table.insert(sList, tonumber(self.roleData.armId)) end
    
    --士兵数据
    for i=1,#sList do
        local soldierInfo = DataManager.getSoldierStaticDataByID(self.roleData.armId)
        soldierInfo.level = 1
        soldierInfo.camp = self.camp
        soldierInfo.leader = self
        soldierInfo.roleID = sList[i]
        soldierInfo.site = self.site

        local soldier = Notifier.getNotifty("addSoliderObject_notify", soldierInfo)
        soldier.site = self.site
        table.insert(self.soldiersList, soldier)
    end
    self:setSoldierPosition()
end

--更换整形
function RoleLeader:changeTactics()
    self:setMyPosition()
    self:setSoldierPosition()
    self:updateZOrder()
end

function RoleLeader:setSoldierPosition()
    --景深缩放
    local s = g_fightLogic.emBattleProgram.getscale(self.site)
    
    local embattleInfo = {}
    if self:campIsOwn() then
        embattleInfo = g_fightLogic.emBattleProgram.own.getSoldier(self.site)
    else
        embattleInfo = g_fightLogic.emBattleProgram.enemy.getSoldier(self.site)
    end

    local cnt = #self.soldiersList
    if cnt > #embattleInfo then cnt = #embattleInfo end
    for i=1,cnt do
        self.soldiersList[i]:setPosition( embattleInfo[i].x, embattleInfo[i].y )
        self.soldiersList[i]:setLocalZOrder(embattleInfo[i].z)
        self.soldiersList[i]:setScale(s*self.offsetScale)
        self.soldiersList[i]:updateZOrder()
        self.soldiersList[i]:setSite(self:getSite())
    end
end

--交换位置
function RoleLeader:exchangeRoleSite(role)
    local mySite = self:getSite()
    local exSite = role:getSite()

    self:setSite(exSite)
    role:setSite(mySite)
end

function RoleLeader:AI_run(event, param)
    if event == ObjectDefine.Ai_Event.enter then
        self:Play(self.move_anim_name, nil, true)
    end

    if event == ObjectDefine.Ai_Event.execute then
    end

    if event == ObjectDefine.Ai_Event.exit then
    end
end

function RoleLeader:AI_Idle(event, param)
    if event == ObjectDefine.Ai_Event.enter then
        self:Play(ROLE_IDLE_ANIMATION_NAME, nil, true)
        
    end

    if event == ObjectDefine.Ai_Event.execute then
    end

    if event == ObjectDefine.Ai_Event.exit then
    end
end

function RoleLeader:AI_seekFoe(event, param)
    if event == ObjectDefine.Ai_Event.enter then
        
        
        local attackObj = nil
        if self:getCamp() == ObjectDefine.Camp.enemy then
            attackObj = self.objectManager_:seekObject(self, ObjectDefine.Camp.own)
        elseif self:getCamp() == ObjectDefine.Camp.own then
            attackObj = self.objectManager_:seekObject(self, ObjectDefine.Camp.enemy)
        end

        if attackObj and not attackObj:isDead() then
            --print("key:" .. self:getKey() .. ", 找到敌人key = " .. attackObj:getKey())
            --if attackObj:isDead() then print("attackObj已经死亡") end
            self.attackObjInfo.obj = attackObj
            self.attackObjInfo.key = attackObj:getKey()

            if self:getKey() == 112 then
                local c = 0 --test code
            end
            self.roleAi:setAi(ObjectDefine.Ai.runToFoe)
        else
            print("未找到敌人")
            if self:getCamp() == ObjectDefine.Camp.enemy then
                attackObj = self.objectManager_:seekObject(self, ObjectDefine.Camp.own)
            elseif self:getCamp() == ObjectDefine.Camp.own then
                attackObj = self.objectManager_:seekObject(self, ObjectDefine.Camp.enemy)
            end
            local function repeatFind()
                self.roleAi:setAi(ObjectDefine.Ai.seekFoe)
            end
            self.AI_seekFoe_schedule = performWithDelay(self, repeatFind, 
            self.roleProperty.attackCD * self.roleProperty.attackSpeed)
            self:Play(ROLE_IDLE_ANIMATION_NAME, nil, true)
        end
    end

    if event == ObjectDefine.Ai_Event.execute then
    end

    if event == ObjectDefine.Ai_Event.exit then
        if self.AI_seekFoe_schedule then self:stopAction(self.AI_seekFoe_schedule) self.AI_seekFoe_schedule = nil end
    end
end

function RoleLeader:AI_runToFoe(event, param)
    if event == ObjectDefine.Ai_Event.enter then
        self:Play(self.move_anim_name, nil, true)
        local function moving()
            if not self.attackObjInfo.key then
                local x = 1
            end
           if not self.objectManager_:objectIsLife(self.attackObjInfo.key) then
                --self.attackObjInfo = {}
                self.roleAi:setAi(ObjectDefine.Ai.seekFoe)

            else
                local attObjPosX,attObjPosY = self.attackObjInfo.obj:getPosition()
                local selfObjPosX,selfObjPosY = self:getPosition()

                local max_dis = 20
                if not self:isLRS() then
                    local attRangeX = self.roleProperty.attackRange --攻击距离
                    local attRangeY = 16

                    local atRect = nil
                    if selfObjPosX > attObjPosX then
                        atRect = cc.rect(attObjPosX, attObjPosY-attRangeY/2, attRangeX, attRangeY)
                    else
                        atRect = cc.rect(attObjPosX-attRangeX, attObjPosY-attRangeY/2, attRangeX, attRangeY)
                    end

                    --在攻击范围
                    if selfObjPosX >= atRect.x and selfObjPosY >= atRect.y and selfObjPosX <= (atRect.x+atRect.width) and selfObjPosY <= (atRect.y+atRect.height) then
                        --距离太近，移动开一定范围
                        if selfObjPosX - atRect.x > 0 and selfObjPosX - atRect.x < 8 then
                            self:moveTo({x=atRect.x + attRangeX, y=selfObjPosY}, moving)

                        elseif atRect.x - selfObjPosX > 0 and atRect.x - selfObjPosX < 8 then
                            self:moveTo({x=atRect.x - attRangeX, y=selfObjPosY}, moving)

                        else
                            self.roleAi:setAi(ObjectDefine.Ai.attack)
                        end
                        
                    --不在攻击范围
                    else
                        local randx = math.random(0, attRangeX/3)
                        randx = selfObjPosX > attObjPosX and randx or -randx
                        local randy = math.random(-attRangeY/3, attRangeY/3)

                        local tx = attObjPosX + randx
                        local ty = attObjPosY + randy
                        local dis = cc.pGetDistance(cc.p(tx,ty), cc.p(selfObjPosX,selfObjPosY))
                        local mm = math.max(1,dis/max_dis)

                        self:moveTo({x=selfObjPosX + (tx-selfObjPosX)/mm, y=selfObjPosY + (ty-selfObjPosY)/mm}, moving)
                        --local dis = cc.pGetDistance(cc.p(tx,ty), cc.p(selfObjPosX,selfObjPosY))
                        --local c = math.min(20, max_dis)--最大移动
                        --local b = (ty - selfObjPosY) * (c/dis)
                        --local a = math.sqrt( math.pow(c,2) - math.pow(math.abs(b),2) )
                        --self:moveTo({x=a+selfObjPosX, y= b+selfObjPosY}, moving)
                    end

                else
                    local dis = cc.pGetDistance(cc.p(attObjPosX,attObjPosY), cc.p(selfObjPosX,selfObjPosY))
                    if self.roleProperty.attackRange > dis then--达到攻击距离
                        self.roleAi:setAi(ObjectDefine.Ai.attack)

                    else
                        --勾股定理
                        local c = math.min(max_dis, dis)--最大移动
                        local b = (attObjPosY - selfObjPosY) * (c/dis)
                        local a = math.sqrt( math.pow(c,2) - math.pow(math.abs(b),2) )
                        if attObjPosX < selfObjPosX then a = -a end--方向调整
                        self:moveTo({x=a+selfObjPosX, y=b+selfObjPosY}, moving)
                    end
                end

                self:setFlipX(attObjPosX < selfObjPosX)--转向
            end
        end
        moving()
    end

    if event == ObjectDefine.Ai_Event.execute then
    end

    if event == ObjectDefine.Ai_Event.exit then
        self:stopMove()
    end
end


function RoleLeader:AI_attack(event, param)
    if event == ObjectDefine.Ai_Event.enter then
        local function playAnim()
            local function reallyAttack()
                return self.attackFunction(self, self.attackObjInfo.key, self.attackObjInfo.obj, 0)
            end
                        
            local function tickCD()
                local attackRes = reallyAttack()
                local function  attackNormalCDFunc()
                    if self.roleAi:getAi() ~= ObjectDefine.Ai.attack then
                        return
                    end
                    if attackRes then 
                        playAnim()
                    else
                        self:Play(ROLE_IDLE_ANIMATION_NAME, nil, true)
                        self.roleAi:setAi(ObjectDefine.Ai.seekFoe)
                    end
                end

                performWithDelay(self, attackNormalCDFunc, self.roleProperty.attackCD * self.roleProperty.attackSpeed)
            end
            
            if #self.attackSpineEvent > 0 then
                for k,v in pairs( self.attackSpineEvent ) do
                    local function attackEff_EventCallback()
                       self:PlayEffectSkeleton(v)
                    end
                    self:addEventCallback(v, attackEff_EventCallback)
                end
            end

            local function attack_EventCallback()
                tickCD()
            end
            self:addEventCallback("attack", attack_EventCallback)

            self:Play(self.attack_anim_name, function() self:Play(ROLE_IDLE_ANIMATION_NAME, nil, true) end, false)
            self:setTimeScale(self.roleProperty.attackSpeed)
        end
        
        playAnim()
    end

    if event == ObjectDefine.Ai_Event.execute then
    end

    if event == ObjectDefine.Ai_Event.exit then
        self:setTimeScale(1.0)
        self:delEventCallback("attack")
    end
end

--延时随机等待，直线冲锋
function RoleLeader:AI_charge(event, param)
    if event == ObjectDefine.Ai_Event.enter then
        
        local delayTime = math.random(1, 5000)/10000
        
        performWithDelay(self, function()
            local moveX = 20
            if self:getCamp() == ObjectDefine.Camp.enemy then
                moveX = - moveX
            end

            local function callback()
                self.roleAi:setAi(ObjectDefine.Ai.seekFoe)
            end
            self:moveBy({x=moveX, y=0}, callback)
            
            self:Play(self.move_anim_name, nil, true)        
            end, delayTime)
    end

    if event == ObjectDefine.Ai_Event.execute then
    end

    if event == ObjectDefine.Ai_Event.exit then
        self:stopMove()
    end
end

function RoleLeader:AI_dead(event, param)
    if event == ObjectDefine.Ai_Event.enter then
        --print(self.roleProperty.name .. " ：死亡")
        local function dieCallback()
            --transition.fadeOut(self.skeleton, {time=1.5,onComplete=function() end})
        end

        self:deadTipPop()
        self:Play(ROLE_DEAD_ANIMATION_NAME, dieCallback, false)
        g_fightLogic:deleteLeader(self, 2)

        self:clearEffectSkeleton()

        --清除skill按钮
        if self:canPlaySkill() and self:campIsOwn() then
            local skillID = self.roleSkill:getActiveSkill()
            if skillID then
                Notifier.postNotifty("removeSkillReally_notify", {skillID = skillID})
            end
        end
    end

    if event == ObjectDefine.Ai_Event.execute then
    end

    if event == ObjectDefine.Ai_Event.exit then
    end
end

function RoleLeader:AI_fightWin(event, param)
    if event == ObjectDefine.Ai_Event.enter then
        local function schFunc()
            self:Play(ROLE_WIN_ANIMATION_NAME, nil, true)
        end
        if not self:isDead() then
            performWithDelay(self, schFunc, 2)
            self:Play(ROLE_IDLE_ANIMATION_NAME, nil, true)
        end
    end

    if event == ObjectDefine.Ai_Event.execute then
    end

    if event == ObjectDefine.Ai_Event.exit then
    end
end

function RoleLeader:AI_freeze(event, param)
    
    if event == ObjectDefine.Ai_Event.enter then
        self.orgTimeScale = self:getTimeScale()
        self:setTimeScale(0.0)
        local lastAI = param.lastAi
        local function schFunc()
            self:setAi(lastAI)
        end
        performWithDelay(self, schFunc, param.time/1000)
    end

    if event == ObjectDefine.Ai_Event.execute then
    end

    if event == ObjectDefine.Ai_Event.exit then
        self:setTimeScale(self.orgTimeScale)
    end
end

--施放技能
function RoleLeader:playSkill()

    self.activeSkillIndex = true
    self.roleAi:setAi(ObjectDefine.Ai.skillAttack)    
end

--技能字冒泡
function RoleLeader:skillNamePop()
    if not self:campIsOwn() and #self.skillSpineEvent > 0 then
        local namePath = SKILL_NAME_UI_PATH .. "/" .. self.skillSpineEvent[1] .. ".png"
        local skillNameSpr = cocosMake.newSprite(namePath)
        if skillNameSpr then
            skillNameSpr:setPosition(0, 147)
            skillNameSpr:setLocalZOrder(9999)
            local spawn = cc.Spawn:create(CCMoveTo:create(0.14, cc.p(0, 149)), CCScaleTo:create(0.14, 1.5))
            local sequence = transition.sequence({
                    spawn,
                    cc.DelayTime:create(0.48),
                    CCFadeOut:create(0.32),
                    cc.RemoveSelf:create()
                })
            skillNameSpr:runAction(sequence)
            self:addChild(skillNameSpr)
        end
    end
end

--死亡提示字冒泡
function RoleLeader:deadTipPop()
    local namePath = SKILL_NAME_UI_PATH .. "/jisha.png"
    if self:campIsOwn() then
        namePath = SKILL_NAME_UI_PATH .. "/siwang.png"
    end

    local killTipSpr = cocosMake.newSprite(namePath)
    if killTipSpr then
        killTipSpr:setPosition(0, 147)
        killTipSpr:setLocalZOrder(9999)
        local spawn = cc.Spawn:create(CCMoveTo:create(0.14, cc.p(0, 149)), CCScaleTo:create(0.14, 1.5))
        local sequence = transition.sequence({
                spawn,
                cc.DelayTime:create(0.48),
                CCFadeOut:create(0.32),
                cc.RemoveSelf:create()
            })
        killTipSpr:runAction(sequence)
        self:addChild(killTipSpr)
    end
end

function RoleLeader:AI_skillAttack(event, param)
    if event == ObjectDefine.Ai_Event.enter then
        local function playSkillWithAI()
            if #self.skillSpineEvent > 0 then
                for k,v in pairs( self.skillSpineEvent ) do
                    local function skill_EventCallback()
                       self:PlayEffectSkeleton(v)
                    end
                    self:addEventCallback(v, skill_EventCallback)
                end
            end

            local function attack_EventCallback()
                local reallyPlaySkillID = self.roleSkill:getActiveSkill()
                if reallyPlaySkillID then
                    self.roleSkill:playSkill(reallyPlaySkillID)
                end
            end
            self:addEventCallback("attack", attack_EventCallback)
            
            local orgZ = self:getLocalZOrder()
            self:setLocalZOrder(9999)
            local function skillAnimFinishCallback()
                self:Play(ROLE_IDLE_ANIMATION_NAME, nil, true)

                self:emptyVital()--主动技能，清空怒气
                self.roleAi:setAi(ObjectDefine.Ai.seekFoe)
                self:setLocalZOrder(orgZ)
            end
            self:Play(ROLE_MAGICATTACK_ANIMATION_NAME, skillAnimFinishCallback, false)
        end
        if self:campIsOwn() then
            Notifier.postNotifty("playComboSkill_notify",{role=self, tab=self.skillSpineEvent[1] or "tx_magic_attack_53",  completeCallback=playSkillWithAI})
        else
            self:skillNamePop()
            playSkillWithAI()
        end
        
    end

    if event == ObjectDefine.Ai_Event.execute then
    end

    if event == ObjectDefine.Ai_Event.exit then
        self:setTimeScale(1.0)
        self:delEventCallback("attack")
    end
end

--武将被选中区域
function RoleLeader:getRoleBoundBox()
    local rect = {}
    local x,y = self:getPosition()
    rect.x = x - 50
    rect.y = y - 50
    rect.width = 100
    rect.height = 100

    return rect
end

function RoleLeader:debugDrawRoleBoundBox()
    local rect = {}
    local w = 165
    local h = 165
    local x,y = self:getPosition()
    rect.x = x - w/2
    rect.y = y
    rect.width = w
    rect.height = h

    local parent = self:getParent()
    local spr1 = cocosMake.newSprite("Star.png", rect.x, rect.y)
    spr1:setLocalZOrder(10000)
    parent:addChild(spr1)

    local spr2 = cocosMake.newSprite("Star.png", rect.x + w, rect.y + h)
    spr2:setLocalZOrder(10000)
    parent:addChild(spr2)

    return rect
end

--下阵
function RoleLeader:downer(downerCallback)
    --先更新血量再移除（移除当做死亡处理）
    for k,v in pairs(self.soldiersList) do
        v:downer()
    end

    g_fightLogic:updateVSHP({type=updateHP_Type.downLimit_loseHp, hp=self.roleProperty:getHP(), camp=self:getCamp()})
    g_fightLogic:deleteLeader(self)

    if downerCallback then downerCallback() end
end

--士兵dead
function RoleLeader:soldierDead(role)
    for k,v in pairs(self.soldiersList) do
        if v == role then
            self.soldiersList[k] = nil
            break
        end
    end
end

--[[
function RoleLeader:showBeSelectEffect(isShow)
    if isShow then
        if not self.selectMoveEffect then
            self.selectMoveEffect = cocosMake.newSprite(FIGTHUI_UIPATH.."buzhen/selectMoveEffect.png")
            self:addChild(self.selectMoveEffect)
            self.selectMoveEffect:setPosition(cc.p(0,0))
            self.orgGlobalZ__ = self:getGlobalZOrder()
            self.skeleton:setGlobalZOrder(self.orgGlobalZ__+2)
            
            self.selectMoveEffect:setGlobalZOrder(self.orgGlobalZ__+1)
        end
    else
        if self.selectMoveEffect then
            self.selectMoveEffect:removeFromParent(true)
            self.selectMoveEffect = nil
            self.skeleton:setGlobalZOrder(self.orgGlobalZ__)
        end
    end
end
--]]


return RoleLeader