require "Basepack"
sell_c = class("sell_c",Basepack)
function sell_c:ctor()
    self._packtype = 10044    --[int]包标识,0x273c
    self._packindex = nil    --[int]标志
    self.thisid = nil    --[double]出售道具
    self.num = nil    --[int]出售数量

    local function appendToTable(t)
        -- print("sell_c:getPack")
        if t~= nil and type(t) == "table" then
            self:appendInt(t,self._packtype)
            self:appendInt(t,self._packindex)
            self:appendDouble(t,self.thisid)
            self:appendInt(t,self.num)
        end
    end
    self._appendToTable = appendToTable
end
function sell_c:create()
    local ret = sell_c.new()
    return ret
end
function sell_c:getPack()
    local pack = {}
    self._appendToTable(pack)
    return pack
end