require "Basepack"
leaderPacket_s = class("leaderPacket_s",Basepack)
function leaderPacket_s:ctor()
    self._packtype = 10103    --[int]包标识,0x2777
    self._packindex = nil    --[int]标志
    self.result = nil    --[int]0表示成功，大于0表示相关错误信息
    self.leaderPacket = nil    --[array]已获得的将领列表

    local function appendToTable(t)
        -- print("leaderPacket_s:getPack")
        if t~= nil and type(t) == "table" then
            self:appendInt(t,self._packtype)
            self:appendInt(t,self._packindex)
            self:appendInt(t,self.result)
            self:appendObjectArray(t,self.leaderPacket)
        end
    end
    self._appendToTable = appendToTable
end
function leaderPacket_s:create()
    local ret = leaderPacket_s.new()
    return ret
end
function leaderPacket_s:getPack()
    local pack = {}
    self._appendToTable(pack)
    return pack
end