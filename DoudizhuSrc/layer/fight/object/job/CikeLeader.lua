--´Ì¿Í½«Áì
local CikeLeader = class("CikeLeader", require(luaFile.RoleLeader))

function CikeLeader:ctor(param)
    self:init(param)
end

function CikeLeader:init(param)
    self:setCorbet(true)
end
function CikeLeader:setCorbet(c)
    if self.isCorbet ~= c then
        self.isCorbet = c
        if c then
            self.skeleton:setOpacity(128)
        else
            self.skeleton:setOpacity(255)
        end
    end
end
function CikeLeader:canBeSeek()
    return not self.isCorbet
end
function CikeLeader:AI_attack(event, param)
    if event == ObjectDefine.Ai_Event.enter then
        self:setCorbet(false)
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

return CikeLeader