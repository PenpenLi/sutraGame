--¹­±øÊ¿±ø
local GongbingSoldier = class("GongbingSoldier", require(luaFile.RoleInfantry))

function GongbingSoldier:ctor(param)
    self:init(param)
end

function GongbingSoldier:init(param)
end

function GongbingSoldier:becomeStrong(param)
    local attackSpeed = self.roleProperty.org.attackSpeed
    local physicsAttack = self.roleProperty.org.physicsAttack
    self.strong_attackSpeed = attackSpeed * 0.3
    self.strong_physicsAttack = physicsAttack * 0.1

    self.roleProperty.attackSpeed = self.roleProperty.attackSpeed + self.strong_attackSpeed
    self.roleProperty.physicsAttack = self.roleProperty.physicsAttack + self.strong_physicsAttack

    self.attack_anim_name = ROLE_JOBBUFF_ANIMATION_NAME
    local originalBullet = DeepCopy( self.bulletSpineEvent )
    if #self.jobBuffEff > 0 then self.bulletSpineEvent = self.jobBuffEff end
    local function restore()
        self.roleProperty.attackSpeed = self.roleProperty.attackSpeed - self.strong_attackSpeed
        self.roleProperty.physicsAttack = self.roleProperty.physicsAttack - self.strong_physicsAttack
        self.strong_attackSpeed = nil
        self.strong_physicsAttack = nil

        self.attack_anim_name = ROLE_ATTACK_ANIMATION_NAME
        self.bulletSpineEvent = originalBullet
    end
    performWithDelay(self, restore, 7)
end

function GongbingSoldier:starGameWithJob()
    performWithDelay(self, function() self:becomeStrong() end, 1)
end


return GongbingSoldier