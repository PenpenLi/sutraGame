--region *.lua
--Date
--此文件由[BabeLua]插件自动生成



--endregion
local DataModePool = class("DataModePool")
DataModePool.vec = {}
function DataModePool:ctor()
    
end

function DataModePool:pushMode(modeData)
    local modeBaseID = modeData:getBaseID()
    local data = modeData
    local strType = data:getType()
    self.vec[strType] = self.vec[data:getType()] or {}
    self.vec[strType][modeBaseID] = data
end

function DataModePool:getModeData(modeBaseID,type)
    local typePool = self.vec[type] or {}
    return typePool[modeBaseID]
end

function DataModePool:eraseModeData(modeBaseID,type)
    if self.vec[type] ~= nil then
        self.vec[type][modeBaseID] = nil
    end
end

return DataModePool