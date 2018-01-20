--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

--endregion
local ActorData = class("ActorData", require "database.datamode.dataMode.lua")


function ActorData:getType()
    return "ActorData"
end

function ActorData:ctor(param)
    self:registerProp()
    self:init(param)
    ActorData.generalPart = new_class(luaFile.ModePart,{type = Actor_Part_General})
    ActorData.itemPart = new_class(luaFile.ModePart,{type = Actor_Part_Item})
end

function ActorData:getKeyByPropName(param)
    for k,v in pairs(self.property.EnumKey) do
        if v == tostring(param) then
            return k
        end
    end
    return nil
end

function ActorData:registerProp()
    self.generalPart = nil
    self.property = { 
                        uid = 1,
                        name = "",
                        imgID = 0,
                        sex = 0,
                        level = 0,
                        exp = 0,
                        gold = 0,
                        silver = 0,
                        body = 0,
                        endurance = 0,
                        viplvl = 0,
                        vipexp = 0,
                        fightingcapacity = 0,
                        lowRecruitFreeNum = 0,
                        highRecruitNum = 0,
                        leaderSoul = 0
                     }

    self.property.EnumKey = {
        [Actor_Prop_ID] = "uid",
        [Actor_Prop_Name] = "name",
        [Actor_Prop_ImgID] = "imgID",
        [Actor_Prop_Sex] = "sex",
        [Actor_Prop_Lvl] = "level",
        [Actor_Prop_Exp] = "exp",
        [Actor_Prop_Gold] = "gold",
        [Actor_Prop_Silver] = "silver",
        [Actor_Prop_Body] = "body",
        [Actor_Prop_Endurance] = "endurance",
        [Actor_Prop_LeaderSoul] = "leaderSoul",
        [Actor_Prop_VIPLvl] = "viplvl",
        [Actor_Prop_VIPExp] = "vipexp",
        [Actor_Prop_FC] = "fightingcapacity",
        [Actor_Prop_LowRecruitFreeNum] = "lowRecruitFreeNum",
        [Actor_Prop_HighRecruitNum] = "highRecruitNum"
    }
end

function ActorData:getBaseID()
    return self.property.uid
end

function ActorData:init(param)
    for key,value in pairs(param) do
        self.property[tostring(key)] = value
    end

    self:postNotifty("Notifty_Actor_Create")
end

function ActorData:SetProperty(param)
    local oldValue = nil
    local key = self.property.EnumKey[param.propID]
    if key ~= nil then
        oldValue = self.property[key]
        self.property[key] = param.value
    else
        print("ActorData:SetProperty nil")
    end
    self:postNotifty("Notifty_Actor_Set_Prop",{propID = param.propID,value = param.value,oldvalue = oldValue})
end

function ActorData:GetProperty(propID)
    local key = self.property.EnumKey[propID]
    if key ~= nil then
        return self.property[key]
    end
    print("ActorData:GetProperty nil propID : "..propID)
    return nil
end

function ActorData:GetPart(partID)
    if partID == Actor_Part_General then
        return self.generalPart
    elseif partID == Actor_Part_Item then
        return self.itemPart
    end
    return nil
end

return ActorData