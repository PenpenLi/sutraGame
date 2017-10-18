require "Basepack"
openPackage_c = class("openPackage_c",Basepack)
function openPackage_c:ctor()
    self._packtype = 10041    --[int]包标识,0x2739
    self._packindex = nil    --[int]标志
    self.type = nil    --[int]打开背包

    local function appendToTable(t)
        -- print("openPackage_c:getPack")
        if t~= nil and type(t) == "table" then
            self:appendInt(t,self._packtype)
            self:appendInt(t,self._packindex)
            self:appendInt(t,self.type)
        end
    end
    self._appendToTable = appendToTable
end
function openPackage_c:create()
    local ret = openPackage_c.new()
    return ret
end
function openPackage_c:getPack()
    local pack = {}
    self._appendToTable(pack)
    return pack
end