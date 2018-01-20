require "Basepack"
fubenStarReward_s = class("fubenStarReward_s",Basepack)
function fubenStarReward_s:ctor()
    self._packtype = 10211    --[int]包标识,0x27e3
    self._packindex = nil    --[int]标志
    self.result = nil    --[int]领取成功与否 0表示成功 >1则是相应错误信息
    self.id = nil    --[int]副本ID
    self.starType = nil    --[int]当前领取的星阶类型
    self.starState = nil    --[int]星阶状态（1未达到，2已达到未领取，3已领取）
    self.reward = nil    --[string]奖励内容

    local function appendToTable(t)
        -- print("fubenStarReward_s:getPack")
        if t~= nil and type(t) == "table" then
            self:appendInt(t,self._packtype)
            self:appendInt(t,self._packindex)
            self:appendInt(t,self.result)
            self:appendInt(t,self.id)
            self:appendInt(t,self.starType)
            self:appendInt(t,self.starState)
            self:appendString(t,self.reward)
        end
    end
    self._appendToTable = appendToTable
end
function fubenStarReward_s:create()
    local ret = fubenStarReward_s.new()
    return ret
end
function fubenStarReward_s:getPack()
    local pack = {}
    self._appendToTable(pack)
    return pack
end