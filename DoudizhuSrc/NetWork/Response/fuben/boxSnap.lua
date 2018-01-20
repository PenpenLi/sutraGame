require "Basepack"
boxSnap = class("boxSnap",Basepack)
function boxSnap:ctor()
    self.type = nil    --[int]宝箱类型 金903|银902|铜901,0x0
    self.reward = nil    --[string]奖励的物品（字符串）
    self.state = nil    --[int]状态 0未得到，1已得到

    local function appendToTable(t)
        -- print("boxSnap:getPack")
        if t~= nil and type(t) == "table" then
            self:appendInt(t,self.type)
            self:appendString(t,self.reward)
            self:appendInt(t,self.state)
        end
    end
    self._appendToTable = appendToTable
end
function boxSnap:create()
    local ret = boxSnap.new()
    return ret
end
function boxSnap:getPack()
    local pack = {}
    self._appendToTable(pack)
    return pack
end