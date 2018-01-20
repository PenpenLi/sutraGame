require "Basepack"
buyAttr_c = class("buyAttr_c",Basepack)
function buyAttr_c:ctor()
    self._packtype = 10090    --[int]包标识,0x276a
    self._packindex = nil    --[int]标志
    self.attr = nil    --[int]属性类型
    self.num = nil    --[double]改变数量

    local function appendToTable(t)
        -- print("buyAttr_c:getPack")
        if t~= nil and type(t) == "table" then
            self:appendInt(t,self._packtype)
            self:appendInt(t,self._packindex)
            self:appendInt(t,self.attr)
            self:appendDouble(t,self.num)
        end
    end
    self._appendToTable = appendToTable
end
function buyAttr_c:create()
    local ret = buyAttr_c.new()
    return ret
end
function buyAttr_c:getPack()
    local pack = {}
    self._appendToTable(pack)
    return pack
end