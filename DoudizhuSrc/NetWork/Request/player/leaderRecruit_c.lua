require "Basepack"
leaderRecruit_c = class("leaderRecruit_c",Basepack)
function leaderRecruit_c:ctor()
    self._packtype = 10100    --[int]包标识,0x2774
    self._packindex = nil    --[int]标志
    self.cardType = nil    --[int]招募的类型：1初级，2中级，3高级，4高级批量招募
    self.expenseType = nil    --[int]招募消耗：1免费次数，2金币或元宝，3好友值

    local function appendToTable(t)
        -- print("leaderRecruit_c:getPack")
        if t~= nil and type(t) == "table" then
            self:appendInt(t,self._packtype)
            self:appendInt(t,self._packindex)
            self:appendInt(t,self.cardType)
            self:appendInt(t,self.expenseType)
        end
    end
    self._appendToTable = appendToTable
end
function leaderRecruit_c:create()
    local ret = leaderRecruit_c.new()
    return ret
end
function leaderRecruit_c:getPack()
    local pack = {}
    self._appendToTable(pack)
    return pack
end