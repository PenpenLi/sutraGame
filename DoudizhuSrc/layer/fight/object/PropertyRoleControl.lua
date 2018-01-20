
local PropertyRoleControl = class("attributeControl")

function PropertyRoleControl:ctor(param)
    self:init(param)
end


--初始化角色属性,可以通过读属性表的方式，或者外部传入的方式
--角色属性，外部不允许直接改写属性
function PropertyRoleControl:init(args)
    self.org = {}
    self.buff = {}
    local roleAttr = args.roleData
    local property = args.property
    self.owner = args.owner

    self.hp = tonumber(property.hp or roleAttr.hp)
    self.org.hp = self.hp
    self.dabHp = self.org.hp/100

    self.name = property.name or roleAttr.name
    self.org.name = self.name

    self.level = tonumber(property.level or roleAttr.level)
    
    self.org.level = self.level

    self.attackRange = tonumber(property.attackRange or roleAttr.attackRange)--攻击距离
    self.org.attackRange = self.attackRange
    self.buff.attackRange = {}--增益

    self.attackSpeed = tonumber(property.attackSpeed or roleAttr.attackSpeed)--攻击速度
    self.attackSpeed = self.attackSpeed or 1
    self.org.attackSpeed = self.attackSpeed
    self.buff.attackSpeed = {}

    self.attackCD = tonumber(property.attackCD or roleAttr.attackCD)--攻击CD
    self.attackCD = self.attackCD/1000
    self.org.attackCD = self.attackCD
    self.buff.attackCD = {}

    self.moveSpeed = tonumber(property.speed or roleAttr.speed)
    self.org.moveSpeed = self.moveSpeed
    self.buff.moveSpeed = {}

    self.bcritDamage = tonumber(property.bcritDamage or roleAttr.bcritDamage)--基础暴击伤害
    self.org.bcritDamage = self.bcritDamage
    self.buff.bcritDamage = {}

    self.physicsAttack = tonumber(property.physicsAttack or roleAttr.physicsAttack)--物攻
    self.org.physicsAttack = self.physicsAttack
    self.buff.physicsAttack = {}

    self.magicAttack = tonumber(property.magicAttack or roleAttr.magicAttack)--魔伤
    self.org.magicAttack = self.magicAttack
    self.buff.magicAttack = {}

    self.barmor = tonumber(property.barmor or roleAttr.barmor)--物防
    self.org.barmor = self.barmor
    self.buff.barmor = {}

    self.bresistance = tonumber(property.bresistance or roleAttr.bresistance)--法防
    self.org.bresistance = self.bresistance
    self.buff.bresistance = {}

    self.hit = tonumber(property.hit or roleAttr.hit)--命中
    self.org.hit = self.hit
    self.buff.hit = {}

    self.dodge = tonumber(property.dodge or roleAttr.dodge)--闪避
    self.org.dodge = self.dodge
    self.buff.dodge = {}

    self.crit = tonumber(property.crit or roleAttr.crit)--暴击
    self.org.crit = self.crit
    self.buff.crit = {}

    self.opposeCrit = tonumber(property.opposeCrit or roleAttr.opposeCrit)--抗暴
    self.org.opposeCrit = self.opposeCrit
    self.buff.opposeCrit = {}

    self.endHurt = tonumber(property.endHurt or roleAttr.endHurt)--最终伤害
    self.org.endHurt = self.endHurt
    self.buff.endHurt = {}

    self.offsetHurt = tonumber(property.offsetHurt or roleAttr.offsetHurt)--最终免伤
    self.org.offsetHurt = self.offsetHurt
    self.buff.offsetHurt = {}

    self.god = tonumber(property.god or roleAttr.god)--无敌，不受到任何伤害 0是不无敌
    self.org.god = self.god
    self.buff.god = {}
    
    self.vitalValue = 0--精气
    self.org.vitalValue = self.vitalValue
    self.buff.vitalValue = {}

    local jobInfo =property.type or  roleAttr.type--职业
    local job = string.split(jobInfo, "_")
    self.job = tonumber(job[1])
    

    --设置克制
    self.kezhi = {}--job-addition
    if self.owner:getType() == ObjectDefine.objectType.infantry then
        self.kezhi[tonumber(roleAttr.restrainId)] = tonumber(roleAttr.restrainHurt)/100
        self.kezhi[tonumber(roleAttr.restrainIdZ)] = tonumber(roleAttr.restrainHurtZ)/100

    elseif self.owner:getType() == ObjectDefine.objectType.leader then
        local arm = DataManager.getSoldierStaticDataByID(roleAttr.armId)
        self.kezhi[tonumber(arm.restrainId)] = tonumber(arm.restrainHurt)/100
        self.kezhi[tonumber(arm.restrainIdZ)] = tonumber(arm.restrainHurtZ)/100
    end
end

function PropertyRoleControl:getJob()
    return self.job
end


--无敌状态？
function PropertyRoleControl:isGod()
    return self.god > 0
end

--增加HP
function PropertyRoleControl:addHP(v)
    local newHp = self.hp + v
    if newHp > self.org.hp then
        local returnHp = self.org.hp - self.hp
        self.hp = self.hp + returnHp
        return returnHp

    elseif newHp < 0 then
        local returnHp = -self.hp
        self.hp = self.hp + returnHp
        return returnHp

    else    
        self.hp = newHp
        return v
    end
end

function PropertyRoleControl:getHP()
    return self.hp
end
function PropertyRoleControl:getHPMax()
    return self.org.hp
end
function PropertyRoleControl:setHpTop(v)
    
    self.org.hp = v
    self.hp = self.org.hp
end

return PropertyRoleControl
