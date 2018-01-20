local TollgetDataMgr = class("TollgetDataMgr")

TollgetDataMgr[".isclass"] = true

function TollgetDataMgr:ctor(data)
    self.vec = {}
    self:pushData(data)
end

function TollgetDataMgr:pushData(param)
    self.vec[170001] = {}
    self.vec[170002] = {}
    self.vec[170003] = {}
    if param ~= nil then
        self.vec[170001] = self:loadDataList(param.sceneList1)
        self.vec[170002] = self:loadDataList(param.sceneList2)
        self.vec[170003] = self:loadDataList(param.sceneList3)
        self:initStars(170001)
        self:initStars(170002)
        self:initStars(170003)
    end
end

function TollgetDataMgr:loadDataList(param)
    if param == nil then
        return {}
    end
    local list = {}
    for k,v in pairs(param) do
        if "table" == type(v) then
            if v.id ~= nil then
                list[tonumber(v.id)]=self:loadDataList(v)
            else
                list[tostring(k)]=self:loadDataList(v)
            end
        else
            if "number" == type(k) then
                list[k]=v
            else
                list[tostring(k)]=v
            end
        end
    end
    return list
end

function TollgetDataMgr:UpdateData(param)
    self.vec[param.sceneId][param.fbId].gateSnaps[param.gateId].amount = param.amount
    local smallGateData = self:loadDataList(param.currGateExtent)
    local grade = self.vec[param.sceneId][param.fbId].gateSnaps[param.gateId].gateExtentSnaps[param.currGateExtent.id].grade
    self.vec[param.sceneId][param.fbId].gateSnaps[param.gateId].gateExtentSnaps[param.currGateExtent.id] = smallGateData
    local bigGateData = self.vec[param.sceneId][param.fbId].gateSnaps[param.gateId]
    local copyData = self.vec[param.sceneId][param.fbId]
    local star = self:getBigGateStar(bigGateData)
    self.vec[param.sceneId][param.fbId].gateSnaps[param.gateId].star = star
    star = self:getCopyStars(copyData)
    self.vec[param.sceneId][param.fbId].star = star
    local stData = DataManager.getCopyStaticDataByID(param.fbId)
    local iNum = self.vec[param.sceneId][param.fbId].starReward1
    if tonumber(stData.firstStarCondition) ~= 0 then
        if iNum ~= nil and iNum == 1 then
            if tonumber(stData.firstStarCondition) <= star then
                self.vec[param.sceneId][param.fbId].starReward1 = 2
            end
        end
    end
    iNum = self.vec[param.sceneId][param.fbId].starReward2
    if tonumber(stData.secondStarCondition) ~= 0 then
        if iNum ~= nil and iNum == 1 then
            if tonumber(stData.secondStarCondition) <= star then
                self.vec[param.sceneId][param.fbId].starReward2 = 2
            end
        end
    end
    iNum = self.vec[param.sceneId][param.fbId].starReward3
    if tonumber(stData.thirdStarCondition) ~= 0 then
        if iNum ~= nil and iNum == 1 then
            if tonumber(stData.thirdStarCondition) <= star then
                self.vec[param.sceneId][param.fbId].starReward3 = 2
            end
        end
    end
    if (grade == nil or grade <= 0) and (smallGateData.grade ~= nil and smallGateData.grade > 0) then
        self:UnLockTollgate()
    end
end

function TollgetDataMgr:UpdateCopyRewardData(data)
    local stData = DataManager.getCopyStaticDataByID(data.id)
    local copyData = self.vec[stData.belongScene][data.id]
    if data.starType == 1 then
        self.vec[stData.belongScene][data.id].starReward1 = data.starState
    elseif data.starType == 2 then
        self.vec[stData.belongScene][data.id].starReward2 = data.starState
    elseif data.starType == 3 then
        self.vec[stData.belongScene][data.id].starReward3 = data.starState
    end
end

function TollgetDataMgr:initStars(id)
    local tlist = self.vec[id]
    if tlist == nil then
        return
    end
    for k,v in pairs(tlist) do
        local star = 0
        for i,j in pairs(v.gateSnaps) do
            star = self:getBigGateStar(j)
            self.vec[id][k].gateSnaps[i].star = star
        end
        star = self:getCopyStars(v)
        self.vec[id][k].star = star
    end
end

function TollgetDataMgr:getCopyStars(data)
    local star = 0
    for _,v in pairs(data.gateSnaps) do
        star = star + self:getBigGateStar(v)
    end
    return star
end

function TollgetDataMgr:getBigGateStar(data)
    local star = 0
    for _,v in pairs(data.gateExtentSnaps) do
        if v.grade ~= nil and v.grade > 0 then
            star = star+1
        end
    end
    return star
end

function TollgetDataMgr:UnLockTollgate()
    local stData = DataManager.getSmallGateStaticData()
    for k,v in pairs(stData) do
        if v ~= nil and v.id~=nil and v.id ~="" then
            local condition = v.openCondition
            local condis = string.split(condition,"|")
            local bIsUnlock = false
            local ret = self:isExitTollgate(v)
            if ret == 1 then
                for _,value in pairs(condis) do
                    bIsUnlock = false
                    local t = string.sub(value,1,1)
                    local j = string.sub(value,3)
                    if self:judgeCondition(tonumber(t),tonumber(j)) == true then
                        bIsUnlock = true
                    end
                end
            end
            if bIsUnlock then 
                self:AddNewTollgate(v)
            end
        end
    end
end

function TollgetDataMgr:judgeCondition(t,v)
    if t == 1 then
        local iLevel = DataModeManager:getActor():GetProperty(Actor_Prop_Lvl)
        if iLevel >= v then
            return true
        end
    elseif t == 2 then
        local smallGateData = self:getSmallGateDataByID(v)
        if smallGateData == nil then
            return false
        end
        if smallGateData.grade == nil or smallGateData.grade <= 0 then
            return false
        else
            return true
        end
    elseif t == 3 then
    end
    return false
end

function TollgetDataMgr:isExitTollgate(data)
    local stBigGateData = DataManager.getBigGateStaticDataByID(data.bigGateId)
    local stCopyData = DataManager.getCopyStaticDataByID(stBigGateData.copyId)
    if stBigGateData == nil or stCopyData == nil then
        return 0
    end
    local sceneData = self.vec[stCopyData.belongScene]
    if sceneData == nil then return 1 end
    local copyData = sceneData[stCopyData.id]
    if copyData == nil then return 1 end
    if copyData.gateSnaps == nil then return 1 end

    local bigGateData = copyData.gateSnaps[stBigGateData.id]

    if bigGateData == nil then return 1 end
    if bigGateData.gateExtentSnaps == nil then return 1 end

    local smallGateData = bigGateData.gateExtentSnaps[data.id]
    if smallGateData == nil or next(smallGateData) == nil then
        return 1
    end
    return 2
end

function TollgetDataMgr:getData(data)

    local sceneData = self.vec[data.sceneId]
    if sceneData == nil then return nil end

    if data.copyId == nil then return sceneData end
    local copyData = sceneData[data.copyId]
    if copyData == nil then return nil end
    if copyData.gateSnaps == nil then return nil end

    if data.gateId == nil then return copyData end
    local bigGateData = copyData.gateSnaps[data.gateId] 
    if bigGateData == nil then return nil end
    if bigGateData.gateExtentSnaps == nil then return nil end

    if data.smallgateId == nil then return bigGateData end
    local smallGateData = bigGateData.gateExtentSnaps[data.smallgateId]
    return smallGateData
end

function TollgetDataMgr:getBigGateData(data)
    local sceneData = self.vec[data.sceneId]
    if sceneData == nil then return nil end
    local copyData = sceneData[data.copyId]
    if copyData == nil then return nil end
    if copyData.gateSnaps == nil then return nil end
    local bigGateData = copyData.gateSnaps[data.gateId] 
    return bigGateData
end

function TollgetDataMgr:getSmallGateDataByID(id)
    local stData = DataManager.getSmallGateStaticDataByID(id)
    local stBigGateData = DataManager.getBigGateStaticDataByID(stData.bigGateId)
    local stCopyData = DataManager.getCopyStaticDataByID(stBigGateData.copyId)
    local sceneData = self.vec[stCopyData.belongScene]
    if sceneData == nil then return nil end
    local copyData = sceneData[stCopyData.id]
    if copyData == nil then return nil end
    if copyData.gateSnaps == nil then return nil end

    local bigGateData = copyData.gateSnaps[stBigGateData.id]

    if bigGateData == nil then return nil end
    if bigGateData.gateExtentSnaps == nil then return nil end

    local smallGateData = bigGateData.gateExtentSnaps[id]
    return smallGateData
end

function TollgetDataMgr:getSmallGateData(data)
    local stBigGateData = DataManager.getBigGateStaticDataByID(data.bigGateId)
    local stCopyData = DataManager.getCopyStaticDataByID(stBigGateData.copyId)
    local sceneData = self.vec[stCopyData.belongScene]
    if sceneData == nil then return nil end
    local copyData = sceneData[stCopyData.id]
    if copyData == nil then return nil end
    if copyData.gateSnaps == nil then return nil end

    local bigGateData = copyData.gateSnaps[stBigGateData.id]

    if bigGateData == nil then return nil end
    if bigGateData.gateExtentSnaps == nil then return nil end

    local smallGateData = bigGateData.gateExtentSnaps[data.id]
    return smallGateData
end

function TollgetDataMgr:AddNewTollgate(data)
    local stBigGateData = DataManager.getBigGateStaticDataByID(data.bigGateId)
    local newData = {id = data.id,type = data.gateDifficulty,grade = nil}
    local stCopyData = DataManager.getCopyStaticDataByID(stBigGateData.copyId)
    local sceneData = self.vec[stCopyData.belongScene]
    local isceneID = stCopyData.belongScene
    local icopyID = stCopyData.id
    local ibigGateID = stBigGateData.id
    local ismallGateID = data.id
    if sceneData == nil then 
        sceneData = {}
        self.vec[isceneID] = {}
    end
    local copyData = sceneData[icopyID]
    if copyData == nil then
        local tTemp = {id = icopyID,starReward1 = 1,starReward2 = 1,starReward3 = 1,star = 0,gateSnaps = {}}
        self.vec[isceneID][icopyID] = tTemp
        copyData = self.vec[isceneID][icopyID]
    end
    if copyData.gateSnaps == nil then
        self.vec[isceneID][icopyID].gateSnaps = {}
        copyData.gateSnaps = {}
    end
    local bigGateData = copyData.gateSnaps[ibigGateID]
    if bigGateData == nil then 
        local tTemp = {id = ibigGateID,star = 0,amount = stBigGateData.challenge,gateExtentSnaps = {}}
        self.vec[isceneID][icopyID].gateSnaps[ibigGateID] = tTemp
        bigGateData = self.vec[isceneID][icopyID].gateSnaps[ibigGateID]
    end
    if bigGateData.gateExtentSnaps == nil then 
        self.vec[isceneID][icopyID].gateSnaps[ibigGateID].gateExtentSnaps = {}
        bigGateData.gateExtentSnaps = {}
    end
    self.vec[isceneID][icopyID].gateSnaps[ibigGateID].gateExtentSnaps[data.id] = newData
end

return TollgetDataMgr