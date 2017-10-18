require "Basepack"
leaderUplevel_s = class("leaderUplevel_s",Basepack)
function leaderUplevel_s:ctor()
    self._packtype = 10301    --[int]包标识,0x283d
    self._packindex = nil    --[int]标志
    self.result = nil    --[int]操作结果
    self.type = nil    --[int]升级类型（1:武将，2:将魂）
    self.leaderId = nil    --[double]主武将baseId
    self.level = nil    --[int]升了多少级

    local function appendToTable(t)
        -- print("leaderUplevel_s:getPack")
        if t~= nil and type(t) == "table" then
            self:appendInt(t,self._packtype)
            self:appendInt(t,self._packindex)
            self:appendInt(t,self.result)
            self:appendInt(t,self.type)
            self:appendDouble(t,self.leaderId)
            self:appendInt(t,self.level)
        end
    end
    self._appendToTable = appendToTable
end
function leaderUplevel_s:create()
    local ret = leaderUplevel_s.new()
    return ret
end
function leaderUplevel_s:getPack()
    local pack = {}
    self._appendToTable(pack)
    return pack
end