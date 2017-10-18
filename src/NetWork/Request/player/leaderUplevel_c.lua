require "Basepack"
leaderUplevel_c = class("leaderUplevel_c",Basepack)
function leaderUplevel_c:ctor()
    self._packtype = 10300    --[int]包标识,0x283c
    self._packindex = nil    --[int]标志
    self.leaderId = nil    --[double]主武将BaseID
    self.type = nil    --[int]升级类型（1:武将，2:将魂）
    self.leaderIds = nil    --[array]消耗的武将列表（传BaseId）
    self.soulType = nil    --[int]"将魂升级类型（1:升1级

    local function appendToTable(t)
        -- print("leaderUplevel_c:getPack")
        if t~= nil and type(t) == "table" then
            self:appendInt(t,self._packtype)
            self:appendInt(t,self._packindex)
            self:appendDouble(t,self.leaderId)
            self:appendInt(t,self.type)
            self:appendDoubleArray(t,self.leaderIds)
            self:appendInt(t,self.soulType)
        end
    end
    self._appendToTable = appendToTable
end
function leaderUplevel_c:create()
    local ret = leaderUplevel_c.new()
    return ret
end
function leaderUplevel_c:getPack()
    local pack = {}
    self._appendToTable(pack)
    return pack
end