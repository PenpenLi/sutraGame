require "Basepack"
playerDataSnap = class("playerDataSnap",Basepack)
function playerDataSnap:ctor()
    self.charid = nil    --[double],0x0
    self.name = nil    --[string]
    self.body = nil    --[int]
    self.exp = nil    --[int]
    self.level = nil    --[int]
    self.endurance = nil    --[int]
    self.money = nil    --[array]0金币 1钻石
    self.lowRecruitFreeNum = nil    --[int]初级招募免费剩余次数
    self.highRecruitNum = nil    --[int]必得高级将领剩余需要次数
    self.leaderSoul = nil    --[int]将魂

    local function appendToTable(t)
        -- print("playerDataSnap:getPack")
        if t~= nil and type(t) == "table" then
            self:appendDouble(t,self.charid)
            self:appendString(t,self.name)
            self:appendInt(t,self.body)
            self:appendInt(t,self.exp)
            self:appendInt(t,self.level)
            self:appendInt(t,self.endurance)
            self:appendDoubleArray(t,self.money)
            self:appendInt(t,self.lowRecruitFreeNum)
            self:appendInt(t,self.highRecruitNum)
            self:appendInt(t,self.leaderSoul)
        end
    end
    self._appendToTable = appendToTable
end
function playerDataSnap:create()
    local ret = playerDataSnap.new()
    return ret
end
function playerDataSnap:getPack()
    local pack = {}
    self._appendToTable(pack)
    return pack
end