--法师将领
local FashuLeader = class("FashuLeader", require(luaFile.RoleLeader))

function FashuLeader:ctor(param)
    self:init(param)
end

function FashuLeader:init(param)
    self.attackFunction = self.AttackBullet
end

--飞行器攻击
function FashuLeader:AttackBullet(objKey, obj, extendPower)
    if self.objectManager_:objectIsLife(objKey) then
        local xp = extendPower or 0
        local power = (self:calcAttackDamage(obj) + xp) * self:kezhiAddition(obj)
        if power < 0 then
            assert(false, "打出的power为负数， id=" .. self.roleData.id .. ", 目标：" .. obj.roleData.id)
        end

        local bullet = self.roleSkill:playBullet(self.bulletSpineEvent, self.roleData.bulletSpeed, power, obj)
        bullet:setTanshe({range=150})

        --更新怒气
        local vv = VitalDefine.attack
        if obj:isDead() then
            if obj:isLeader() then
                vv = vv + VitalDefine.skillLeader
            else
                vv = vv + VitalDefine.skillSolider
            end
        end
        self:updateVital(vv)
        return true
    else
        return false
    end
end

return FashuLeader