--��ʦʿ��
local FashuSoldier = class("FashuSoldier", require(luaFile.RoleInfantry))

function FashuSoldier:ctor(param)
    self:init(param)
end

function FashuSoldier:init(param)
    self.attackFunction = self.AttackBullet
end

--����������
function FashuSoldier:AttackBullet(objKey, obj, extendPower)
    if self.objectManager_:objectIsLife(objKey) then
        local xp = extendPower or 0
        local power = (self:calcAttackDamage(obj) + xp) * self:kezhiAddition(obj)
        if power < 0 then
            assert(false, "�����powerΪ������ id=" .. self.roleData.id .. ", Ŀ�꣺" .. obj.roleData.id)
        end

        local bullet = self.roleSkill:playBullet(self.bulletSpineEvent, self.roleData.bulletSpeed, power, obj)
        bullet:setTanshe({range=150})
        return true
    else
        return false
    end
end

return FashuSoldier