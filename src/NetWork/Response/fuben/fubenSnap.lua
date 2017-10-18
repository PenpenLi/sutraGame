require "Basepack"
fubenSnap = class("fubenSnap",Basepack)
function fubenSnap:ctor()
    self.id = nil    --[int]副本ID,0x0
    self.star = nil    --[int]副本总星级
    self.starReward1 = nil    --[int]第一星级奖励状态（1表示为未激活，2表示激活未领取，3表示已领取）
    self.starReward2 = nil    --[int]第二星级奖励状态
    self.starReward3 = nil    --[int]第三星级奖励状态
    self.gateSnaps = nil    --[array]关卡信息列表

    local function appendToTable(t)
        -- print("fubenSnap:getPack")
        if t~= nil and type(t) == "table" then
            self:appendInt(t,self.id)
            self:appendInt(t,self.star)
            self:appendInt(t,self.starReward1)
            self:appendInt(t,self.starReward2)
            self:appendInt(t,self.starReward3)
            self:appendObjectArray(t,self.gateSnaps)
        end
    end
    self._appendToTable = appendToTable
end
function fubenSnap:create()
    local ret = fubenSnap.new()
    return ret
end
function fubenSnap:getPack()
    local pack = {}
    self._appendToTable(pack)
    return pack
end