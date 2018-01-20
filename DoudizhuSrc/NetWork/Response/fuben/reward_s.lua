require "Basepack"
reward_s = class("reward_s",Basepack)
function reward_s:ctor()
    self._packtype = 902    --[int]包标识,0x386
    self._packindex = nil    --[int]标志
    self.rewards = nil    --[string]获得的奖励拼串

    local function appendToTable(t)
        -- print("reward_s:getPack")
        if t~= nil and type(t) == "table" then
            self:appendInt(t,self._packtype)
            self:appendInt(t,self._packindex)
            self:appendString(t,self.rewards)
        end
    end
    self._appendToTable = appendToTable
end
function reward_s:create()
    local ret = reward_s.new()
    return ret
end
function reward_s:getPack()
    local pack = {}
    self._appendToTable(pack)
    return pack
end