--region *.lua
--Date
--此文件由[BabeLua]插件自动生成



--endregion
recvPlayerPropResponse={}

function recvPlayerPropResponse.moneychange(obj)
    print("recvPlayerPropResponse:moneychange")
    if obj.moneytype == 0 then
        DataModeManager:getActor():SetProperty({propID=Actor_Prop_Silver,value=obj.total})
    elseif obj.moneytype == 1 then
        DataModeManager:getActor():SetProperty({propID=Actor_Prop_Gold,value=obj.total})
    end
end

function recvPlayerPropResponse.expchange(obj)
    print("recvPlayerPropResponse:expchange")
    DataModeManager:getActor():SetProperty({propID=Actor_Prop_Exp,value=obj.total})
end

function recvPlayerPropResponse.vitchange(obj)
    print("recvPlayerPropResponse:vitchange")
    DataModeManager:getActor():SetProperty({propID=Actor_Prop_Body,value=obj.total})
end

function recvPlayerPropResponse.lvlup(obj)
    print("recvPlayerPropResponse:lvlup")
    DataModeManager:getActor():SetProperty({propID=Actor_Prop_Lvl,value=obj.level})
end

function recvPlayerPropResponse.propChange(obj)
    print("recvPlayerPropResponse:propChange")
    for k,v in pairs(obj.changeKeys) do
        recvPlayerPropResponse.dealpropChange(obj,k)
    end
end

function recvPlayerPropResponse.dealpropChange(obj,k)
    local key = DataModeManager:getActor():getKeyByPropName(tostring(obj.changeKeys[k]))
    if key == nil then
        print("unknown prop key of actordata --"..tostring(obj.changeKeys[k]).."  "..key);
        return
    end
    local data = DataModeManager:getActor():GetProperty(key)
    if data == nil then
        print("unknown prop of actordata --"..tostring(obj.changeKeys[k]));
        return
    end
    if type(data) == "number" then
        DataModeManager:getActor():SetProperty({propID=key,value=tonumber(obj.changeValues[k])})
    elseif type(data) == "string" then
        DataModeManager:getActor():SetProperty({propID=key,value=tostring(obj.changeValues[k])})
    end
    print("set prop of actordata --"..tostring(obj.changeKeys[k].."  "..obj.changeValues[k]));
end

function recvPlayerPropResponse:registerResponse()
    EventHelper:addListener("10080",recvPlayerPropResponse.moneychange)
    EventHelper:addListener("10081",recvPlayerPropResponse.vitchange)
    EventHelper:addListener("10082",recvPlayerPropResponse.expchange)
    EventHelper:addListener("10083",recvPlayerPropResponse.lvlup)
    EventHelper:addListener("10070",recvPlayerPropResponse.propChange)
end