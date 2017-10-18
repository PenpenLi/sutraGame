require "Basepack"
yuqiang_c = class("yuqiang_c",Basepack)
function yuqiang_c:ctor()
    self._packtype = 11000    --[int]包标识,0x2af8
    self._packindex = nil    --[int]标志
    self.num = nil    --[float]测试double

    local function appendToTable(t)
        -- print("yuqiang_c:getPack")
        if t~= nil and type(t) == "table" then
            self:appendInt(t,self._packtype)
            self:appendInt(t,self._packindex)
            self:appendFloat(t,self.num)
        end
    end
    self._appendToTable = appendToTable
end
function yuqiang_c:create()
    local ret = yuqiang_c.new()
    return ret
end
function yuqiang_c:getPack()
    local pack = {}
    self._appendToTable(pack)
    return pack
end