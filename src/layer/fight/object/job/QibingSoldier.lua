--骑兵士兵
local QibingSoldier = class("QibingSoldier", require(luaFile.RoleInfantry))

function QibingSoldier:ctor(param)
    self:init(param)
end

function QibingSoldier:init(param)
    
end
function QibingSoldier:becomeStrongMore()
    local movespeed = self.roleProperty.org.moveSpeed
    local physicsAttack = self.roleProperty.org.physicsAttack
    self.strong_movespeed = movespeed * 0.3
    self.strong_physicsAttack = physicsAttack * 0.2

    self.roleProperty.moveSpeed = self.roleProperty.moveSpeed + self.strong_movespeed
    self.roleProperty.physicsAttack = self.roleProperty.physicsAttack + self.strong_physicsAttack

    self.move_anim_name = ROLE_JOBBUFF_ANIMATION_NAME
    self:Play(self.move_anim_name, nil, true)     
    self.isStrongBuff = true

    for i=1,#self.jobBuffEff do
        self:PlayEffectSkeleton(self.jobBuffEff[i], nil, true)
    end  
end
function QibingSoldier:restoreRight()
    if self.isStrongBuff then
        self.roleProperty.moveSpeed = self.roleProperty.moveSpeed - self.strong_movespeed
        self.roleProperty.physicsAttack = self.roleProperty.physicsAttack - self.strong_physicsAttack
        self.strong_movespeed = nil
        self.strong_physicsAttack = nil
        self.isStrongBuff = false

        self.move_anim_name = ROLE_RUN_ANIMATION_NAME

        for i=1,#self.jobBuffEff do
            self:clearEffectSkeleton(self.jobBuffEff[i])
        end
    end
end
function QibingSoldier:AI_attack(event, param)
    if event == ObjectDefine.Ai_Event.enter then
        self:restoreRight()
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
            self:addEventCallback(self.attack_anim_name, attack_EventCallback)

            self:Play(ROLE_ATTACK_ANIMATION_NAME, function() self:Play(ROLE_IDLE_ANIMATION_NAME, nil, true) end, false)
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

function QibingSoldier:starGameWithJob()
    --职业特性
    self.msx, self.msy = self:getPosition()--move开始位置
    local function checkMoveFunc()
        local cx,cy = self:getPosition()
        local dis = cc.pGetDistance(cc.p(self.msx, self.msy), cc.p(cx, cy))
        if dis > 100 then
            self:stopAction(self.moveCheckAciton)
            self:becomeStrongMore()
            self.moveCheckAciton = nil
        end
    end
    self.moveCheckAciton = schedule(self, checkMoveFunc, 1)
end
return QibingSoldier