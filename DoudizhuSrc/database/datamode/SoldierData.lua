--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

--endregion
local SoldierData = class("SoldierData", require "database.datamode.dataMode.lua")

function SoldierData:registerProp()
    self.property = {
    }
    self.property.EnumKey = {
        [	Soldier_Prop_Baseid 	] = "baseId",
        [	Soldier_Prop_Soldierid 	] = "soldierId",
        [	Soldier_Prop_Level 	] = "level",
        [	Soldier_Prop_Quality 	] = "quality",
        [	Soldier_Prop_Exp 	] = "exp",
        [	Soldier_Prop_Amount 	] = "amount",
        [	Soldier_Prop_Physicsattack 	] = "physicsAttack",
        [	Soldier_Prop_Magicattack 	] = "magicAttack",
        [	Soldier_Prop_Barmor 	] = "barmor",
        [	Soldier_Prop_Bresistance 	] = "bresistance",
        [	Soldier_Prop_Hp 	] = "hp",
        [	Soldier_Prop_Hit 	] = "hit",
        [	Soldier_Prop_Dodge 	] = "dodge",
        [	Soldier_Prop_Crit 	] = "crit",
        [	Soldier_Prop_Opposecrit 	] = "opposeCrit",
        [	Soldier_Prop_Endhurt 	] = "endHurt",
        [	Soldier_Prop_Offsethurt 	] = "offsetHurt"
    }
    self.static_prop = {}
    self.static_prop.EnumKey = {
        [	Soldier_StaticProp_Id	] = "id",
        [	Soldier_StaticProp_Name	] = "name",
        [	Soldier_StaticProp_Bulletspeed	] = "bulletSpeed",
        [	Soldier_StaticProp_Type	] = "type",
        [	Soldier_StaticProp_Modelid	] = "modelId",
        [	Soldier_StaticProp_Beginquelity	] = "beginQuelity",
        [	Soldier_StaticProp_Endquelity	] = "endQuelity",
        [	Soldier_StaticProp_Attackrange	] = "attackRange",
        [	Soldier_StaticProp_Attackcd	] = "attackCD",
        [	Soldier_StaticProp_Speed	] = "speed",
        [	Soldier_StaticProp_Bcritdamage	] = "bcritDamage",
        [	Soldier_StaticProp_Physicsattack	] = "physicsAttack",
        [	Soldier_StaticProp_Magicattack	] = "magicAttack",
        [	Soldier_StaticProp_Barmor	] = "barmor",
        [	Soldier_StaticProp_Bresistance	] = "bresistance",
        [	Soldier_StaticProp_Hp	] = "hp",
        [	Soldier_StaticProp_Hit	] = "hit",
        [	Soldier_StaticProp_Dodge	] = "dodge",
        [	Soldier_StaticProp_Crit	] = "crit",
        [	Soldier_StaticProp_Opposecrit	] = "opposeCrit",
        [	Soldier_StaticProp_Endhurt	] = "endHurt",
        [	Soldier_StaticProp_Offsethurt	] = "offsetHurt",
        [	Soldier_StaticProp_Physicsattackagress	] = "physicsAttackAgress",
        [	Soldier_StaticProp_Magicattackagress	] = "magicAttackAgress",
        [	Soldier_StaticProp_Barmoragress	] = "barmorAgress",
        [	Soldier_StaticProp_Bresistanceagress	] = "bresistanceAgress",
        [	Soldier_StaticProp_Hpagress	] = "hpAgress",
        [	Soldier_StaticProp_Hitagress	] = "hitAgress",
        [	Soldier_StaticProp_Dodgeagress	] = "dodgeAgress",
        [	Soldier_StaticProp_Critagress	] = "critAgress",
        [	Soldier_StaticProp_Opposecritagress	] = "opposeCritAgress",
        [	Soldier_StaticProp_Endhurtagress	] = "endHurtAgress",
        [	Soldier_StaticProp_Offsethurtagress	] = "offsetHurtAgress",
        [	Soldier_StaticProp_Description	] = "description"
    }
end

function SoldierData:ctor(param)
    self:registerProp()
    self:init(param)
    self:BrushProp()
end

function SoldierData:getBaseID()
    return self.property.baseId
end

function SoldierData:getType()
    return "SoldierData"
end

function SoldierData:init(param)
    for key,value in pairs(param) do
        if value ~= nil then
            self.property[tostring(key)] = value
        end
    end
end

function SoldierData:updateData(param)
    for key,value in pairs(param) do
        if value ~= nil and self.property[tostring(key)] ~= nil then
            if self.property[tostring(key)] ~= param[tostring(key)] then
                local kEnum = self:getPropEnumKeyByName(tostring(key))
                if kEnum ~= -1 then
                    self:SetProperty({propID = kEnum,value = value})
                end
            end
        end
    end
end

function SoldierData:BrushProp()
    local dataT = DataManager.getSoldierStaticDataByID(self.property.soldierId)
    self:countProp("physicsAttack",dataT["physicsAttack"],dataT["physicsAttackAgress"])
    self:countProp("magicAttack",dataT["magicAttack"],dataT["magicAttackAgress"])
    self:countProp("barmor",dataT["barmor"],dataT["barmorAgress"])
    self:countProp("bresistance",dataT["bresistance"],dataT["bresistanceAgress"])
    self:countProp("hp",dataT["hp"],dataT["hpAgress"])
    self:countProp("hit",dataT["hit"],dataT["hitAgress"])
    self:countProp("dodge",dataT["dodge"],dataT["dodgeAgress"])
    self:countProp("crit",dataT["crit"],dataT["critAgress"])
    self:countProp("opposeCrit",dataT["opposeCrit"],dataT["opposeCritAgress"])
    self:countProp("endHurt",dataT["endHurt"],dataT["endHurtAgress"])
    self:countProp("offsetHurt",dataT["offsetHurt"],dataT["offsetHurtAgress"])
end

function SoldierData:countProp(key,ibase,igress)
    if ibase == nil or igress == nil then
        return
    end
    igress = igress / 10
    local ilvl = self.property.level
    local iTalentLvl = self.property.talentLv
    local iNum = self:countLvlPropNum(ibase,igress,ilvl)
    self.property[key] = iNum
end

function SoldierData:countLvlPropNum(ibase,igress,ilvl)
    return ibase + igress*(ilvl-1)
end

function SoldierData:getPropEnumKeyByName(name)
    for key,value in pairs(self.property.EnumKey) do
        if value == name then return key end
    end
    return -1
end

function SoldierData:SetProperty(param)
    local oldValue = nil
    local key = self.property.EnumKey[param.propID]
    if key ~= nil then
        oldValue = self.property[key]
        self.property[key] = param.value
    else
        print("SoldierData:SetProperty nil")
    end
    self:postNotifty("Notifty_Soldier_Set_Prop",{propID = param.propID,value = param.value,oldvalue = oldValue})
end

function SoldierData:GetProperty(propID)
    local key = self.property.EnumKey[propID]
    if key ~= nil then
        return self.property[key]
    end
    print("SoldierData:GetProperty nil")
    return nil
end

function SoldierData:GetStaticProperty(propID)
    local key = self.static_prop.EnumKey[propID]
    local dataT = DataManager.getSoldierStaticDataByID(self.property.soldierId)
    if key ~= nil and dataT ~= nil then
        return dataT[key]
    end
    print("SoldierData:GetStaticProperty nil")
    return nil
end

function SoldierData:GetFightData()
    local dataT = DataManager.getSoldierStaticDataByID(self.property.soldierId)
    local tFightData = {
        id = dataT.id, 
        name = dataT.name,
        bulletSpeed = dataT.bulletSpeed,
        type = dataT.type,
        modelId = dataT.modelId, 
        attackRange = dataT.attackRange, 
        attackCD = dataT.attackCD, 
        speed = dataT.speed, 
        bcritDamage = dataT.bcritDamage,
        amount = self.property.amount,
        level = self.property.level,
        physicsAttack = self.property.physicsAttack, 
        magicAttack = self.property.magicAttack, 
        barmor = self.property.barmor, 
        bresistance = self.property.bresistance, 
        hp = self.property.hp, 
        hit = self.property.hit, 
        dodge = self.property.dodge, 
        crit = self.property.crit, 
        opposeCrit = self.property.opposeCrit, 
        endHurt = self.property.endHurt, 
        offsetHurt = self.property.offsetHurt
    }
    return tFightData
end

return SoldierData