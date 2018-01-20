require "Basepack"
fubenStarReward_c = class("fubenStarReward_c",Basepack)
function fubenStarReward_c:ctor()
    self._packtype = 10210    --[int]包标识,0x27e2
    self._packindex = nil    --[int]标志
    self.id = nil    --[int]副本ID
    self.starType = nil    --[int]"领取星级奖励（1 第一星阶奖励

    local function appendToTable(t)
        -- print("fubenStarReward_c:getPack")
        if t~= nil and type(t) == "table" then
            self:appendInt(t,self._packtype)
            self:appendInt(t,self._packindex)
            self:appendInt(t,self.id)
            self:appendInt(t,self.starType)
        end
    end
    self._appendToTable = appendToTable
end
function fubenStarReward_c:create()
    local ret = fubenStarReward_c.new()
    return ret
end
function fubenStarReward_c:getPack()
    local pack = {}
    self._appendToTable(pack)
    return pack
end