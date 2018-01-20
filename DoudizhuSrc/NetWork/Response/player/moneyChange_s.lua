require "Basepack"
moneyChange_s = class("moneyChange_s",Basepack)
function moneyChange_s:ctor()
    self._packtype = 10080    --[int]包标识,0x2760
    self._packindex = nil    --[int]标志
    self.moneytype = nil    --[int]金钱类型
    self.change = nil    --[double]改变金钱数量
    self.total = nil    --[double]当前金钱数量

    local function appendToTable(t)
        -- print("moneyChange_s:getPack")
        if t~= nil and type(t) == "table" then
            self:appendInt(t,self._packtype)
            self:appendInt(t,self._packindex)
            self:appendInt(t,self.moneytype)
            self:appendDouble(t,self.change)
            self:appendDouble(t,self.total)
        end
    end
    self._appendToTable = appendToTable
end
function moneyChange_s:create()
    local ret = moneyChange_s.new()
    return ret
end
function moneyChange_s:getPack()
    local pack = {}
    self._appendToTable(pack)
    return pack
end