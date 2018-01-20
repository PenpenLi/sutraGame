--´Ì¿ÍÊ¿±ø
local CikeSoldier = class("CikeSoldier", require(luaFile.RoleInfantry))

function CikeSoldier:ctor(param)
    self:init(param)
end

function CikeSoldier:init(param)
    self:setCorbet(true)
end
function CikeSoldier:setCorbet(c)
    if self.isCorbet ~= c then
        self.isCorbet = c
        if c then
            self.skeleton:setOpacity(128)
        else
            self.skeleton:setOpacity(255)
        end
    end
end
function CikeSoldier:canBeSeek()
    return not self.isCorbet
end
function CikeSoldier:AI_attack(event, param)
    if event == ObjectDefine.Ai_Event.enter then
        self:setCorbet(false)
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

return CikeSoldier