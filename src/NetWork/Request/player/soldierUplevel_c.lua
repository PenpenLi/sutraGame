require "Basepack"
soldierUplevel_c = class("soldierUplevel_c",Basepack)
function soldierUplevel_c:ctor()
    self._packtype = 10320    --[int]包标识,0x2850
    self._packindex = nil    --[int]标志
    self.leaderBaseId = nil    --[double]主武将BaseID
    self.soldierBaseId = nil    --[double]士兵BaseId

    local function appendToTable(t)
        -- print("soldierUplevel_c:getPack")
        if t~= nil and type(t) == "table" then
            self:appendInt(t,self._packtype)
            self:appendInt(t,self._packindex)
            self:appendDouble(t,self.leaderBaseId)
            self:appendDouble(t,self.soldierBaseId)
        end
    end
    self._appendToTable = appendToTable
end
function soldierUplevel_c:create()
    local ret = soldierUplevel_c.new()
    return ret
end
function soldierUplevel_c:getPack()
    local pack = {}
    self._appendToTable(pack)
    return pack
end