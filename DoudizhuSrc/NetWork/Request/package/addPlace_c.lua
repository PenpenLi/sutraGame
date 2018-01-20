require "Basepack"
addPlace_c = class("addPlace_c",Basepack)
function addPlace_c:ctor()
    self._packtype = 10040    --[int]包标识,0x2738
    self._packindex = nil    --[int]标志
    self.type = nil    --[int]增加包裹容量

    local function appendToTable(t)
        -- print("addPlace_c:getPack")
        if t~= nil and type(t) == "table" then
            self:appendInt(t,self._packtype)
            self:appendInt(t,self._packindex)
            self:appendInt(t,self.type)
        end
    end
    self._appendToTable = appendToTable
end
function addPlace_c:create()
    local ret = addPlace_c.new()
    return ret
end
function addPlace_c:getPack()
    local pack = {}
    self._appendToTable(pack)
    return pack
end