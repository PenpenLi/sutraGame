require "Basepack"
starSnap = class("starSnap",Basepack)
function starSnap:ctor()
    self.id = nil    --[int]副本ID,0x0
    self.star = nil    --[int]副本星级
    self.challengeAmout = nil    --[int]剩余挑战次数

    local function appendToTable(t)
        -- print("starSnap:getPack")
        if t~= nil and type(t) == "table" then
            self:appendInt(t,self.id)
            self:appendInt(t,self.star)
            self:appendInt(t,self.challengeAmout)
        end
    end
    self._appendToTable = appendToTable
end
function starSnap:create()
    local ret = starSnap.new()
    return ret
end
function starSnap:getPack()
    local pack = {}
    self._appendToTable(pack)
    return pack
end