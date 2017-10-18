require "Basepack"
leaderPacket_c = class("leaderPacket_c",Basepack)
function leaderPacket_c:ctor()
    self._packtype = 10102    --[int]包标识,0x2776
    self._packindex = nil    --[int]标志

    local function appendToTable(t)
        -- print("leaderPacket_c:getPack")
        if t~= nil and type(t) == "table" then
            self:appendInt(t,self._packtype)
            self:appendInt(t,self._packindex)
        end
    end
    self._appendToTable = appendToTable
end
function leaderPacket_c:create()
    local ret = leaderPacket_c.new()
    return ret
end
function leaderPacket_c:getPack()
    local pack = {}
    self._appendToTable(pack)
    return pack
end