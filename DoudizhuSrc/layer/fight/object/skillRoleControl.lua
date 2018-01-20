
local skillRoleControl = class("skillRoleControl")

function skillRoleControl:ctor(param)
    self.skillList = {}
    self.owner = nil
    self:init(param)
end

function skillRoleControl:setOwner(obj)
    self.owner = obj
end

function skillRoleControl:init(param)
    local skillList = string.split(param.skillID or "", ",")
    for k,v in pairs(skillList) do
        if v ~= "" then
            local s = DataManager.getSkillByID(v)
            self.skillList[tonumber(v)] = s
        end
    end
end

--获取主动技能
function skillRoleControl:getActiveSkill()
    for k,v in pairs(self.skillList) do
        if v.type == 1 then
            return tonumber(k)
        end
    end
    --print("位找到主动技能,角色名" .. self.owner.roleData.id .. ", 名称：" .. self.owner.roleData.name)
end

--技能施放
function skillRoleControl:playSkill(skillID)
    --if true then return true end--test code
    local skill = self.skillList[skillID]
    local power = 0
    local passiveSkillID = 0
    local buffID = 0
    local skillPowerEff = self.owner.skillPowerEff
    local flyPos_skill = self.owner.flyPos_skill
    local picPos_skil = self.owner.picPos_skil
    local skillFlySpeed = self.owner.skillFlySpeed
    local skillPowerScale = self.owner.skillPowerScale
    
    --print(self.owner.roleProperty.name .. "施放技能" )
    local obj = Notifier.getNotifty( "addSkillObject_notify",
    {camp=self.owner:getCamp(), leader=self.owner, skillID=skillID, skillPowerEff=skillPowerEff, flyPos_skill=flyPos_skill,picPos_skil=picPos_skil,skillFlySpeed=skillFlySpeed,skillPowerScale=skillPowerScale} )
    obj:play()
    
end

--远程攻击
function skillRoleControl:playBullet(bullet, bulletSpeed, power, target)
    --if true then return true end--test code
    local picPos_attack = self.owner.picPos_attack
    local obj = Notifier.getNotifty( "addBulletObject_notify",
    {camp=self.owner:getCamp(), leader=self.owner, target=target, power=power, bullet=bullet, bulletSpeed=bulletSpeed, picPos_attack=picPos_attack} )
    return obj
end

return skillRoleControl
