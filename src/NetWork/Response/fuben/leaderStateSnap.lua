require "Basepack"
leaderStateSnap = class("leaderStateSnap",Basepack)
function leaderStateSnap:ctor()
    self.leaderBaseId = nil    --[double]将领baseId,0x0
    self.site = nil    --[int]站位

    local function appendToTable(t)
        -- print("leaderStateSnap:getPack")
        if t~= nil and type(t) == "table" then
            self:appendDouble(t,self.leaderBaseId)
            self:appendInt(t,self.site)
        end
    end
    self._appendToTable = appendToTable
end
function leaderStateSnap:create()
    local ret = leaderStateSnap.new()
    return ret
end
function leaderStateSnap:getPack()
    local pack = {}
    self._appendToTable(pack)
    return pack
end