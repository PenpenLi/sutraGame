--region *.lua
--Date
--此文件由[BabeLua]插件自动生成



--endregion
recvPackageResponse={}

function recvPackageResponse.ItemList(obj)
    print("recvPackageResponse:ItemList")
    DataModeManager:getActor():GetPart(Actor_Part_Item):clear()
    DataModeManager:getActor():GetPart(Actor_Part_Item):setSize(obj.valid_gird)
    for k,v in ipairs(obj.item_list) do
        if v.itemid > 0 then
            recvPackageResponse.dealItem(v)
            DataModeManager:getActor():GetPart(Actor_Part_Item):pushMode(v.thisid)
        end
    end
end

function recvPackageResponse.dealItem(data)
    if data == nil or next(data) == nil then return end
    local baseID = data.thisid
    local item = DataModeManager:getModeData(baseID,"ItemData")
    if item ~= nil then
        item:updateData(data)
    else
        item = DataModeManager:CreateItemData(data)
        if item == nil then return end
        Notifier.postNotifty("Notifty_Item_Create",{data = baseID})
    end
end

function recvPackageResponse.updateItem(data)
    if data == nil or next(data) == nil then return end
    local baseID = data.thisid
    local item = DataModeManager:getModeData(baseID,"ItemData")
    if item ~= nil then
        item:SetProperty({propID = Item_Prop_Num,value = data.num})
        if data.num <= 0 then
            DataModeManager:getActor():GetPart(Actor_Part_Item):popMode(baseID)
            DataModeManager:removeModeData(baseID,"ItemData")
        end
    end
end

function recvPackageResponse:registerResponse()
    EventHelper:addListener("10045",recvPackageResponse.updateItem)
end