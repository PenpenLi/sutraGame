--骑兵将领
local QibingLeader = class("QibingLeader", require(luaFile.RoleLeader))

function QibingLeader:ctor(param)
    self:init(param)
end

function QibingLeader:starGameWithJob()
    local function strFuncion()
        local strKey = self:getKey()
        local strLabel = cocosMake.newLabelTTF(tostring(strKey))
        self.roleName:addChild(strLabel)
    end
    --strFuncion()--test code

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

function QibingLeader:init(param)
    
end
function QibingLeader:becomeStrongMore()
    local movespeed = self.roleProperty.org.moveSpeed
    local physicsAttack = self.roleProperty.org.physicsAttack
    self.strong_movespeed = movespeed * 0.3
    self.strong_physicsAttack = physicsAttack * 0.2

    self.roleProperty.moveSpeed = self.roleProperty.moveSpeed + self.strong_movespeed
    self.roleProperty.physicsAttack = self.roleProperty.physicsAttack + self.strong_physicsAttack
    self.isStrongBuff = true

    self.move_anim_name = ROLE_JOBBUFF_ANIMATION_NAME
    self:Play(self.move_anim_name, nil, true)   
    
    for i=1,#self.jobBuffEff do
        self:PlayEffectSkeleton(self.jobBuffEff[i], nil, true)
    end  
end

function QibingLeader:restoreRight()
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

function QibingLeader:AI_attack(event, param)
    if event == ObjectDefine.Ai_Event.enter then
        self:restoreRight()
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

            self:Play(ROLE_ATTACK_ANIMATION_NAME, function() self:Play(ROLE_IDLE_ANIMATION_NAME, nil, true) end, false)
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

return QibingLeader