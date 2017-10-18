require "Basepack"
battleEnd_s = class("battleEnd_s",Basepack)
function battleEnd_s:ctor()
    self._packtype = 10203    --[int]包标识,0x27db
    self._packindex = nil    --[int]标志
    self.result = nil    --[int]0挑战成功，1挑战失败
    self.fbId = nil    --[int]副本ID
    self.gateId = nil    --[int]小关卡ID
    self.showReward = nil    --[string]显示固定奖励
    self.showBoxReward = nil    --[array]显示宝箱奖励列表

    local function appendToTable(t)
        -- print("battleEnd_s:getPack")
        if t~= nil and type(t) == "table" then
            self:appendInt(t,self._packtype)
            self:appendInt(t,self._packindex)
            self:appendInt(t,self.result)
            self:appendInt(t,self.fbId)
            self:appendInt(t,self.gateId)
            self:appendString(t,self.showReward)
            self:appendObjectArray(t,self.showBoxReward)
        end
    end
    self._appendToTable = appendToTable
end
function battleEnd_s:create()
    local ret = battleEnd_s.new()
    return ret
end
function battleEnd_s:getPack()
    local pack = {}
    self._appendToTable(pack)
    return pack
end