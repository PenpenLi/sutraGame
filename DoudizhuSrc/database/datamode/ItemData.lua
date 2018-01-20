--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

--endregion
local ItemData = class("ItemData", require "database.datamode.dataMode.lua")

function ItemData:registerProp()
    self.property = {
    }
    self.property.EnumKey = {
        [	Item_Prop_Baseid 	] = "thisid",
        [	Item_Prop_Itemid 	] = "itemid",
        [	Item_Prop_Num 	] = "num"
    }
    self.static_prop = {}
    self.static_prop.EnumKey = {
        [	Item_StaticProp_Id	] = "id",
        [	Item_StaticProp_Name	] = "name",
        [	Item_StaticProp_Icon	] = "icon",
        [	Item_StaticProp_Quality	] = "quality",
        [	Item_StaticProp_Type	] = "type",
        [	Item_StaticProp_Usedlevel	] = "usedLevel",
        [	Item_StaticProp_Saleprice	] = "salePrice",
        [	Item_StaticProp_Usetype	] = "useType",
        [	Item_StaticProp_Usedeffect	] = "usedEffect",
        [	Item_StaticProp_Rewardnumber	] = "rewardNumber",
        [	Item_StaticProp_Dailymaximum	] = "dailyMaximum",
        [	Item_StaticProp_Effectstacklimit	] = "effectStackLimit",
        [	Item_StaticProp_Singlestacklimit	] = "singleStackLimit",
        [	Item_StaticProp_Effectinstruction	] = "effectInstruction",
        [	Item_StaticProp_Getinstruction	] = "getInstruction",
        [	Item_StaticProp_Order	] = "order",
        [	Item_StaticProp_Ifresolve	] = "ifResolve"
    }
end

function ItemData:ctor(param)
    self:registerProp()
    self:init(param)
end

function ItemData:getBaseID()
    return self.property.thisid
end

function ItemData:getType()
    return "ItemData"
end

function ItemData:init(param)
    for key,value in pairs(param) do
        if value ~= nil then
            self.property[tostring(key)] = value
        end
    end
end

function ItemData:updateData(param)
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

function ItemData:getPropEnumKeyByName(name)
    for key,value in pairs(self.property.EnumKey) do
        if value == name then return key end
    end
    return -1
end

function ItemData:SetProperty(param)
    local oldValue = nil
    local key = self.property.EnumKey[param.propID]
    if key ~= nil then
        oldValue = self.property[key]
        self.property[key] = param.value
    else
        print("ItemData:SetProperty nil")
    end
    self:postNotifty("Notifty_Item_Set_Prop",{propID = param.propID,value = param.value,oldvalue = oldValue})
end

function ItemData:GetProperty(propID)
    local key = self.property.EnumKey[propID]
    if key ~= nil then
        return self.property[key]
    end
    print("ItemData:GetProperty nil")
    return nil
end

function ItemData:GetStaticProperty(propID)
    local key = self.static_prop.EnumKey[propID]
    local dataT = DataManager.getItemStaticDataByID(self.property.itemid)
    if key ~= nil and dataT ~= nil then
        return dataT[key]
    end
    print("ItemData:GetStaticProperty nil")
    return nil
end

return ItemData