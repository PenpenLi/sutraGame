--步兵
local RoleInfantry = class("RoleInfantry", require(luaFile.RoleBase))
RoleInfantry.notify = {"fightWin_role_notify"}
RoleInfantry[".isclass"] = true

function RoleInfantry:ctor(param)
    self:init(param)
end

function RoleInfantry:handleNotification(notifyName, body)
    if notifyName == "fightWin_role_notify" then
        self:fightWinFunc()
    end
end

function RoleInfantry:init(param)
    self.attackObjInfo = {}--攻击目标
    self.leader = param.leader--所属
    self.leaderKey = self.leader:getKey()

    --站的位置
    self.site = param.site or 1

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

    self.roleAi:setAi(ObjectDefine.Ai.idle)

    self:updateZOrder()

    g_fightLogic:updateVSHP({type=updateHP_Type.upLimit_addHp, hp=self.roleProperty:getHP(), camp=self:getCamp()})

    --人物动作名称
    self.attack_anim_name = ROLE_ATTACK_ANIMATION_NAME
    self.move_anim_name = ROLE_RUN_ANIMATION_NAME
end

function RoleInfantry:getSite()
    return self.site
end

function RoleInfantry:setSite(site)
    self.site = site
end


function RoleInfantry:starGame()
    self.roleAi:setAi(ObjectDefine.Ai.charge)
    self:startRoleSchedule()

    if self.starGameWithJob then self:starGameWithJob() end
end

function RoleInfantry:fightWinFunc()
    self:stopRoleSchedule()
    self.roleAi:setAi(ObjectDefine.Ai.fightWin)
end

function RoleInfantry:AI_run(event, param)
    if event == ObjectDefine.Ai_Event.enter then
        self:Play(self.move_anim_name, nil, true)
        
    end

    if event == ObjectDefine.Ai_Event.execute then
    end

    if event == ObjectDefine.Ai_Event.exit then
    end
end

function RoleInfantry:AI_Idle(event, param)
    if event == ObjectDefine.Ai_Event.enter then
        self:Play(ROLE_IDLE_ANIMATION_NAME, nil, true)
    end

    if event == ObjectDefine.Ai_Event.execute then
    end

    if event == ObjectDefine.Ai_Event.exit then
    end
end

function RoleInfantry:AI_seekFoe(event, param)
    if event == ObjectDefine.Ai_Event.enter then
        --self:Play("idle", nil, false)
        local attackObj = nil
        if self:getCamp() == ObjectDefine.Camp.enemy then
            attackObj = self.objectManager_:seekObject(self, ObjectDefine.Camp.own)
        elseif self:getCamp() == ObjectDefine.Camp.own then
            attackObj = self.objectManager_:seekObject(self, ObjectDefine.Camp.enemy)
        end

        if attackObj and not attackObj:isDead() then
            --if attackObj:isDead() then print("attackObj已经死亡") end
            self.attackObjInfo.obj = attackObj
            self.attackObjInfo.key = attackObj:getKey()
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

function RoleInfantry:AI_runToFoe(event, param)
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

function RoleInfantry:AI_attack(event, param)
    if event == ObjectDefine.Ai_Event.enter then
        local function playAnim()
            local function reallyAttack()
                return self.attackFunction(self, self.attackObjInfo.key, self.attackObjInfo.obj, math.random(20, 40))
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

            local function attack_EventCallback()
                tickCD()
                local cnt = 1
                local function eventCallback()
                    if cnt <= #self.attackSpineEvent then
                        cnt = cnt + 1
                        self:PlayEffectSkeleton(self.attackSpineEvent[cnt-1],eventCallback)
                    end
                end
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

    end
end

--延时随机等待，直线冲锋
function RoleInfantry:AI_charge(event, param)
    if event == ObjectDefine.Ai_Event.enter then
        
        local delayTime = math.random(1, 7000)/10000
        
        performWithDelay(self, function()
            local moveX = 200
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

function RoleInfantry:AI_dead(event, param)
    if event == ObjectDefine.Ai_Event.enter then
        local function dieCallback()
            --transition.fadeOut(self.skeleton, {time=1.5,onComplete=function() end})
        end
        self:Play(ROLE_DEAD_ANIMATION_NAME, dieCallback, false)
        g_fightLogic:deleteSolider(self, 2)
        
        --self.leader:soldierDead(self)
    end

    if event == ObjectDefine.Ai_Event.execute then
    end

    if event == ObjectDefine.Ai_Event.exit then
    end
end

function RoleInfantry:AI_fightWin(event, param)
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

function RoleInfantry:AI_freeze(event, param)
    
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

--下阵
function RoleInfantry:downer()
    --先更新血量再移除（移除当做死亡处理）
    g_fightLogic:updateVSHP({type=updateHP_Type.downLimit_loseHp, hp=self.roleProperty:getHP(), camp=self:getCamp()})
    g_fightLogic:deleteSolider(self)
end

return RoleInfantry