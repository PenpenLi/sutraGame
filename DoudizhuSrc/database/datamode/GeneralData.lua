--region *.lua
--Date
--此文件由[BabeLua]插件自动生成



--endregion
local GeneralData = class("GeneralData", require "database.datamode.dataMode.lua")

function GeneralData:ctor(param)
    self:registerProp()
    self:init(param)
    self:BrushProp()
end

function GeneralData:registerProp()
    self.property = {
                            playerId = 0,
                            baseId = 0,
                            leaderId = 0,
                            level = 0,
                            talentLv = 0,
                            seat = 0,
                            state = 0,
                            exp = 0,
                            physicsAttack = 0,
                            magicAttack = 0,
                            barmor = 0,
                            bresistance = 0,
                            hp = 0,
                            hit = 0,
                            dodge = 0,
                            crit = 0,
                            opposeCrit = 0,
                            endHurt = 0,
                            offsetHurt = 0,
                            fightingcapacity = 0,
                            grade = 0,
                     }
    self.static_prop = {}
                     
    self.property.EnumKey = {
        [	General_Prop_Playerid	] = "playerId",
        [	General_Prop_Baseid	] = "baseId",
        [	General_Prop_Leaderid	] = "leaderId",
        [	General_Prop_Level	] = "level",
        [	General_Prop_Talentlv	] = "talentLv",
        [	General_Prop_Seat	] = "seat",
        [	General_Prop_State	] = "state",
        [	General_Prop_Exp	] = "exp",
        [	General_Prop_ArmId	] = "armId",
        [	General_Prop_Physicsattack	] = "physicsAttack",
        [	General_Prop_Magicattack	] = "magicAttack",
        [	General_Prop_Barmor	] = "barmor",
        [	General_Prop_Bresistance	] = "bresistance",
        [	General_Prop_Hp	] = "hp",
        [	General_Prop_Hit	] = "hit",
        [	General_Prop_Dodge	] = "dodge",
        [	General_Prop_Crit	] = "crit",
        [	General_Prop_Opposecrit	] = "opposeCrit",
        [	General_Prop_Endhurt	] = "endHurt",
        [	General_Prop_Offsethurt	] = "offsetHurt",
        [	General_Prop_FC	] = "fightingcapacity",
        [   General_Prop_Grade  ] = "grade"
    }

    self.static_prop.EnumKey = {
        [	General_StaticProp_Id	] = "id",
        [	General_StaticProp_Name	] = "name",
        [	General_StaticProp_Bulletspeed	] = "bulletSpeed",
        [	General_StaticProp_Type	] = "type",
        [	General_StaticProp_Camp	] = "Camp",
        [	General_StaticProp_Beginlevel	] = "beginLevel",
        [	General_StaticProp_Endlevel	] = "endLevel",
        [	General_StaticProp_Beginquelity	] = "beginQuelity",
        [	General_StaticProp_Endquelity	] = "endQuelity",
        [	General_StaticProp_Beginstar	] = "beginStar",
        [	General_StaticProp_Endstar	] = "endStar",
        [	General_StaticProp_Beginaptitude	] = "beginAptitude",
        [	General_StaticProp_Endaptitude	] = "endAptitude",
        [	General_StaticProp_Agility	] = "agility",
        [	General_StaticProp_Force	] = "force",
        [	General_StaticProp_Endurance	] = "endurance",
        [	General_StaticProp_Wit	] = "wit",
        [	General_StaticProp_Armid	] = "armId",
        [	General_StaticProp_Skillid	] = "skillID",
        [	General_StaticProp_Modelid	] = "modelId",
        [	General_StaticProp_Attackrange	] = "attackRange",
        [	General_StaticProp_Attackcd	] = "attackCD",
        [	General_StaticProp_Speed	] = "speed",
        [	General_StaticProp_Bcritdamage	] = "bcritDamage",
        [	General_StaticProp_Physicsattack	] = "physicsAttack",
        [	General_StaticProp_Magicattack	] = "magicAttack",
        [	General_StaticProp_Barmor	] = "barmor",
        [	General_StaticProp_Bresistance	] = "bresistance",
        [	General_StaticProp_Hp	] = "hp",
        [	General_StaticProp_Hit	] = "hit",
        [	General_StaticProp_Dodge	] = "dodge",
        [	General_StaticProp_Crit	] = "crit",
        [	General_StaticProp_Opposecrit	] = "opposeCrit",
        [	General_StaticProp_Endhurt	] = "endHurt",
        [	General_StaticProp_Offsethurt	] = "offsetHurt",
        [	General_StaticProp_Physicsattackagress	] = "physicsAttackAgress",
        [	General_StaticProp_Magicattackagress	] = "magicAttackAgress",
        [	General_StaticProp_Barmoragress	] = "barmorAgress",
        [	General_StaticProp_Bresistanceagress	] = "bresistanceAgress",
        [	General_StaticProp_Hpagress	] = "hpAgress",
        [	General_StaticProp_Hitagress	] = "hitAgress",
        [	General_StaticProp_Dodgeagress	] = "dodgeAgress",
        [	General_StaticProp_Critagress	] = "critAgress",
        [	General_StaticProp_Opposecritagress	] = "opposeCritAgress",
        [	General_StaticProp_Endhurtagress	] = "endHurtAgress",
        [	General_StaticProp_Offsethurtagress	] = "offsetHurtAgress",
        [   General_StaticProp_Iconid ] = "iconid"
    }
end

function GeneralData:getBaseID()
    return self.property.baseId
end

function GeneralData:getType()
    return "GeneralData"
end

function GeneralData:init(param)
    for key,value in pairs(param) do
        if value ~= nil then
            self.property[tostring(key)] = value
        end
    end
end

function GeneralData:updateData(param)
    for key,value in pairs(param) do
        if param[tostring(key)] ~= nil and self.property[tostring(key)] ~= nil then
            if self.property[tostring(key)] ~= param[tostring(key)] then
                local kEnum = self:getPropEnumKeyByName(tostring(key))
                if kEnum ~= -1 then
                    self:SetProperty({propID = kEnum,value = value})
                end
            end
        end
    end
    self:BrushProp()
    self:postNotifty("Notifty_General_Update",{baseId = self.property.baseId})
end

function GeneralData:getPropEnumKeyByName(name)
    for key,value in pairs(self.property.EnumKey) do
        if value == name then return key end
    end
    return -1
end

function GeneralData:SetProperty(param)
    local oldValue = nil
    local key = self.property.EnumKey[param.propID]
    if key ~= nil then
        oldValue = self.property[key]
        self.property[key] = param.value
    else
        print("GeneralData:SetProperty key nil")
    end
    self:postNotifty("Notifty_General_Set_Prop",{baseId = self.property.baseId,propID = param.propID,value = param.value,oldvalue = oldValue})
end

function GeneralData:GetProperty(propID)
    local key = self.property.EnumKey[propID]
    if key ~= nil then
        return self.property[key]
    end
    print("GeneralData:GetProperty nil")
    return nil
end

function GeneralData:GetStaticProperty(propID)
    local key = self.static_prop.EnumKey[propID]
    local dataT = DataManager.getLeaderStaticDataByID(self.property.leaderId)
    if key ~= nil and dataT ~= nil then
        return dataT[key]
    end
    print("GeneralData:GetStaticProperty nil")
    return nil
end

function GeneralData:countFC()
    local stData = DataManager.getGeneralStaticData()
    local power = stData[HP_FIGHT_VALUE].value * self.property.hp/100
    power = power + stData[HIT_FIGHT_VALUE].value * self.property.hit
    power = power + stData[DODGE_FIGHT_VALUE].value * self.property.dodge
    power = power + stData[CRIT_FIGHT_VALUE].value * self.property.crit
    power = power + stData[OPPOSECIRT_FIGHT_VALUE].value * self.property.opposeCrit
    power = power + stData[MAGICATTACK_FIGHT_VALUE].value * self.property.magicAttack
    power = power + stData[PHYSICSATTACK_FIGHT_VALUE].value * self.property.physicsAttack
    power = power + stData[BARMOR_FIGHT_VALUE].value * self.property.barmor
    power = power + stData[BRESISTANCE_FIGHT_VALUE].value * self.property.bresistance
    power = power + stData[FINAL_HARM_FIGHT_VALUE].value * self.property.endHurt
    power = power + stData[FINAL_OFFSETHARM_FIGHT_VALUE].value * self.property.offsetHurt
    self.property.fightingcapacity = math.ceil(power)
end

function GeneralData:BrushProp()
    local dataT = DataManager.getLeaderStaticDataByID(self.property.leaderId)
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
    self:countFC()
    self:countTalentLv()
    self:countTalent()
end

function GeneralData:countTalentLv()
    local dataT = DataManager.getLeaderStaticDataByID(self.property.leaderId)
    local iGradeLv = self.property.grade
    for i = 1,10,1 do
        local str = dataT["openTalentCondition"..i]
        if str ~= nil and str ~= "" then
            local iNum = tonumber(str)
            if iNum > 0 and iGradeLv >= iNum then
                self.property.talentLv = i
            end
        end
    end
end

function GeneralData:countTalent()
    local iTalentLvl = self.property.talentLv
    local dataT = DataManager.getLeaderStaticDataByID(self.property.leaderId)
    for i = 1,iTalentLvl,1 do
        local str = dataT["talent"..i]
        local strList = string.split(str,"_")
        if tonumber(strList[1]) > 0 then
            local iAddNum = tonumber(strList[3])
            local propId = General_Prop_Physicsattack - 1 + tonumber(strList[1])
            local key = self.property.EnumKey[propId]
            if tonumber(strList[2]) == 1 then
                iAddNum = self.property[key] * iAddNum/100
            end
            self.property[key] = self.property[key] + iAddNum
        end
    end
end

function GeneralData:countProp(key,ibase,igress)
    if ibase == nil or igress == nil then
        return
    end
    igress = igress / 10
    local ilvl = self.property.level
    local iAdvanceLvl = self.property.grade
    local iNum = self:countLvlPropNum(ibase,igress,ilvl) + self:countAdvancePropNum(ibase,igress,iAdvanceLvl)
    self.property[key] = iNum
end

function GeneralData:countLvlPropNum(ibase,igress,ilvl)
    return ibase + igress*(ilvl-1)
end

function GeneralData:countAdvancePropNum(ibase,igress,ilvl)
    if ilvl == 0 then return 0 end
    local iaddnum = DataManager.getGeneralStaticDataByID(TALENT_ADD_VALUE).value / 10
    local imultnum = DataManager.getGeneralStaticDataByID(TALENT_UNIT_VALUE).value / 10
    return ibase + (iaddnum + imultnum*ilvl) * igress * ilvl / 2
end

function GeneralData:GetFightData()
    local dataT = DataManager.getLeaderStaticDataByID(self.property.leaderId)
    local tFightData = {
        id = dataT.id, 
        name = dataT.name,
        bulletSpeed = dataT.bulletSpeed,
        type = dataT.type,
        beginQuelity = dataT.beginQuelity,
        agility = dataT.agility, 
        skillID = dataT.skillID, 
        modelId = dataT.modelId, 
        attackRange = dataT.attackRange, 
        attackCD = dataT.attackCD, 
        speed = dataT.speed, 
        bcritDamage = dataT.bcritDamage, 
        level = self.property.level,
        armId = self.property.armId, 
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

return GeneralData