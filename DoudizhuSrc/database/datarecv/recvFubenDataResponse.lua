--region *.lua
--Date
--此文件由[BabeLua]插件自动生成



--endregion
recvFubenDataResponse={}

function recvFubenDataResponse.InitfubenData(obj)
    print("recvFubenDataResponse:InitfubenData")
    local mgr = DataModeManager:CreateTollgetDataMgr(obj)
    mgr:UnLockTollgate()
end

function recvFubenDataResponse.tollgateFinish(obj)
    print("recvFubenDataResponse:tollgateFinish")
    local mgr = DataModeManager:getTollGateDataMgr()
    mgr:UpdateData(obj)
end

function recvFubenDataResponse:registerResponse()
    EventHelper:addListener("10208",recvFubenDataResponse.InitfubenData)
    EventHelper:addListener("10207",recvFubenDataResponse.tollgateFinish)
end