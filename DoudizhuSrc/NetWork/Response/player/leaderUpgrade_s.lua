require "Basepack"
leaderUpgrade_s = class("leaderUpgrade_s",Basepack)
function leaderUpgrade_s:ctor()
    self._packtype = 10305    --[int]包标识,0x2841
    self._packindex = nil    --[int]标志
    self.result = nil    --[int]相关错误代码编号
    self.type = nil    --[int]1成功，2失败
    self.leaderId = nil    --[double]主武将ID

    local function appendToTable(t)
        -- print("leaderUpgrade_s:getPack")
        if t~= nil and type(t) == "table" then
            self:appendInt(t,self._packtype)
            self:appendInt(t,self._packindex)
            self:appendInt(t,self.result)
            self:appendInt(t,self.type)
            self:appendDouble(t,self.leaderId)
        end
    end
    self._appendToTable = appendToTable
end
function leaderUpgrade_s:create()
    local ret = leaderUpgrade_s.new()
    return ret
end
function leaderUpgrade_s:getPack()
    local pack = {}
    self._appendToTable(pack)
    return pack
end