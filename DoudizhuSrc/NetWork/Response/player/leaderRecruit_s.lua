require "Basepack"
leaderRecruit_s = class("leaderRecruit_s",Basepack)
function leaderRecruit_s:ctor()
    self._packtype = 10101    --[int]包标识,0x2775
    self._packindex = nil    --[int]标志
    self.result = nil    --[int]0表示成功，大于0表示相关错误信息
    self.baseIds = nil    --[array]招募成功的武将服务器基础Id

    local function appendToTable(t)
        -- print("leaderRecruit_s:getPack")
        if t~= nil and type(t) == "table" then
            self:appendInt(t,self._packtype)
            self:appendInt(t,self._packindex)
            self:appendInt(t,self.result)
            self:appendDoubleArray(t,self.baseIds)
        end
    end
    self._appendToTable = appendToTable
end
function leaderRecruit_s:create()
    local ret = leaderRecruit_s.new()
    return ret
end
function leaderRecruit_s:getPack()
    local pack = {}
    self._appendToTable(pack)
    return pack
end