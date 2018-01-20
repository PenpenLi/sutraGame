--region *.lua
--Date
--此文件由[BabeLua]插件自动生成



--endregion
recvGeneralPropResponse={}

function recvGeneralPropResponse.leaderPacket(obj)
    print("recvGeneralPropResponse.leaderPacket")
    if obj.result == nil then
        print("recvGeneralPropResponse.leaderPacket  error : " .. obj.result)
        return
    elseif obj.result ~= ERR_SUCCESS then
        print("recvGeneralPropResponse.leaderPacket  error : " .. obj.result)
        return
    end
    for _,v in pairs(obj.leaderPacket) do
        if v ~= nil then
            recvGeneralPropResponse.dealLeaderData(v)
        end
    end
end

function recvGeneralPropResponse.leaderDataUpdate(obj)
    recvGeneralPropResponse.dealLeaderData(obj.leaderData)
end

function recvGeneralPropResponse.dealLeaderData(data)
    if data == nil or next(data) == nil then return end
    local baseID = data.baseId
    local general = DataModeManager:getModeData(baseID,"GeneralData")
    if general ~= nil then
        data.soldiers = nil
        if general:getType() == "ActorData"then
            print("catch1  "..baseID)
        elseif general:getType() == "SoldierData"then
            print("catch2  "..baseID)
        end
        general:updateData(data)
    else
        local soldier = {}
        if data.soldiers ~= nil then
            for key,value in pairs(data.soldiers) do
                if value ~= nil then
                    soldier[tostring(key)] = value
                end
            end
            data.soldiers = nil
            data.armId = soldier.baseId
            recvGeneralPropResponse.dealSoldier(soldier)
        end
        general = DataModeManager:CreateGeneralData(data)
        if general == nil then return end
        local playerID = general:GetProperty(General_Prop_Playerid)
        local actor = DataModeManager:getActorData(playerID)
        if actor ~= nil then
            local part = actor:GetPart(Actor_Part_General)
            if part:contain(baseID) == false then
                part:pushMode(baseID)
                Notifier.postNotifty("Notifty_General_Create",{data = baseID})
            end
        end
    end
end

function recvGeneralPropResponse.dealSoldier(data)
    local baseID = data.baseId
    local soldier = DataModeManager:getModeData(baseID,"SoldierData")
    if soldier ~= nil then
        soldier:updateData(data)
    else
        soldier = DataModeManager:CreateSoldierData(data)
        if soldier == nil then return end
        Notifier.postNotifty("Notifty_Soldier_Create",{data = baseID})
    end
end

function recvGeneralPropResponse.deleteGeneral(data)
    for k,v in pairs(data.leaderIds) do
        DataModeManager:getActor():GetPart(Actor_Part_General):popMode(v)
        DataModeManager:removeModeData(v,"GeneralData")
    end
    Notifier.postNotifty("Notifty_General_Delete",{data = data.leaderIds})
end

function recvGeneralPropResponse:registerResponse()
    EventHelper:addListener("10105",recvGeneralPropResponse.leaderDataUpdate)
    EventHelper:addListener("10303",recvGeneralPropResponse.deleteGeneral)
end