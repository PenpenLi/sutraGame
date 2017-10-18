require "Basepack"
leaderUplevelDelete_s = class("leaderUplevelDelete_s",Basepack)
function leaderUplevelDelete_s:ctor()
    self._packtype = 10303    --[int]包标识,0x283f
    self._packindex = nil    --[int]标志
    self.leaderIds = nil    --[array]消耗的武将列表（传baseId）

    local function appendToTable(t)
        -- print("leaderUplevelDelete_s:getPack")
        if t~= nil and type(t) == "table" then
            self:appendInt(t,self._packtype)
            self:appendInt(t,self._packindex)
            self:appendDoubleArray(t,self.leaderIds)
        end
    end
    self._appendToTable = appendToTable
end
function leaderUplevelDelete_s:create()
    local ret = leaderUplevelDelete_s.new()
    return ret
end
function leaderUplevelDelete_s:getPack()
    local pack = {}
    self._appendToTable(pack)
    return pack
end