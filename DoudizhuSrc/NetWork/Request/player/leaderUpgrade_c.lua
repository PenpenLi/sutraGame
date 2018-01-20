require "Basepack"
leaderUpgrade_c = class("leaderUpgrade_c",Basepack)
function leaderUpgrade_c:ctor()
    self._packtype = 10304    --[int]包标识,0x2840
    self._packindex = nil    --[int]标志
    self.leaderId = nil    --[double]主武将ID

    local function appendToTable(t)
        -- print("leaderUpgrade_c:getPack")
        if t~= nil and type(t) == "table" then
            self:appendInt(t,self._packtype)
            self:appendInt(t,self._packindex)
            self:appendDouble(t,self.leaderId)
        end
    end
    self._appendToTable = appendToTable
end
function leaderUpgrade_c:create()
    local ret = leaderUpgrade_c.new()
    return ret
end
function leaderUpgrade_c:getPack()
    local pack = {}
    self._appendToTable(pack)
    return pack
end