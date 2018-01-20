--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
--endregion
require(luaFile.recvPlayerPropResponse)
require(luaFile.recvGeneralPropResponse)
require(luaFile.recvFubenDataResponse)
require(luaFile.recvPackageResponse)
DataModeManager = {}
DataModeManager.dataModePool = new_class(luaFile.DataModePool)

function DataModeManager:CreateTollgetDataMgr(param)
    local tMgr = {
        sceneList1 = {
            [0] = {
                id = 180000,
                star = 0,
                gateSnaps = {
                    [0] = {
                        id = 200001,
                        amount = 99,
                        gateExtentSnaps = {
                            [0] = {
                                id = 190001,
                                type = 1,
                                grade = nil
                            }
                        }
                    }
                }
            }
        },
        sceneList2 = {
        },
        sceneList3 = {
        }
    }
    if param == nil or next(param) == nil then
        param = tMgr
    end
    self.tollgetDataMgr = new_class(luaFile.TollgetDataMgr,param)
    return self.tollgetDataMgr
end

function DataModeManager:getTollGateDataMgr()
    return self.tollgetDataMgr
end

function DataModeManager:CreateActor(param)
    local tAct = {
                    uid = 100,
                    name = "大唐丶小gong举",
                    level = 85,
                    exp = 0,
                    imgID = 0,
                    gold = 8000,
                    silver = 5470,
                    body = 100,
                    endurance = 20,
                    viplvl = 5,
                    vipexp = 100,
                    fightingcapacity = 34980,
                    lowRecruitFreeNum = 0,
                    highRecruitNum = 0,
                    leaderSoul = 0
                }
    for k,v in pairs(param) do
        if v ~= nil then
            print("tAct "..k.." ------ "..v)
            tAct[tostring(k)] = v
        end
    end
    self.Actor = self:CreateModeData(luaFile.ActorData,tAct)
    return self.Actor
end

function DataModeManager:CreateGeneralData(param)
    local ret = self:CreateModeData(luaFile.GeneralData,param)
    return ret
end

function DataModeManager:CreateSoldierData(param)
    local ret = self:CreateModeData(luaFile.SoldierData,param)
    return ret
end

function DataModeManager:CreateItemData(param)
    local ret = self:CreateModeData(luaFile.ItemData,param)
    return ret
end

function DataModeManager:getActor()
    return self.Actor
end

function DataModeManager:CreateModeData(name,data)
    if data == nil or next(data) == nil  then return nil end
    local ret = new_class(name,data)
    if ret ~= nil then
        self.dataModePool:pushMode(ret)
    end
    return ret
end

function DataModeManager:getModeData(modeBaseID,type)
    return self.dataModePool:getModeData(modeBaseID,type)
end

function DataModeManager:getActorData(modeBaseID)
    return self.dataModePool:getModeData(modeBaseID,"ActorData")
end

function DataModeManager:getGeneralData(modeBaseID)
    return self.dataModePool:getModeData(modeBaseID,"GeneralData")
end

function DataModeManager:getSoldierData(modeBaseID)
    return self.dataModePool:getModeData(modeBaseID,"SoldierData")
end

function DataModeManager:getItemData(modeBaseID)
    return self.dataModePool:getModeData(modeBaseID,"ItemData")
end

function DataModeManager:removeModeData(modeBaseID,type)
    return self.dataModePool:eraseModeData(modeBaseID,type)
end

function DataModeManager:RegisterResponse()
    recvPlayerPropResponse:registerResponse()
    recvGeneralPropResponse:registerResponse()
    recvFubenDataResponse:registerResponse()
    recvPackageResponse:registerResponse()
end