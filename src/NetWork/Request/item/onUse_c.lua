require "Basepack"
onUse_c = class("onUse_c",Basepack)
function onUse_c:ctor()
    self._packtype = 10043    --[int]包标识,0x273b
    self._packindex = nil    --[int]标志
    self.thisid = nil    --[int]道具唯一id
    self.num = nil    --[int]数量

    local function appendToTable(t)
        -- print("onUse_c:getPack")
        if t~= nil and type(t) == "table" then
            self:appendInt(t,self._packtype)
            self:appendInt(t,self._packindex)
            self:appendInt(t,self.thisid)
            self:appendInt(t,self.num)
        end
    end
    self._appendToTable = appendToTable
end
function onUse_c:create()
    local ret = onUse_c.new()
    return ret
end
function onUse_c:getPack()
    local pack = {}
    self._appendToTable(pack)
    return pack
end