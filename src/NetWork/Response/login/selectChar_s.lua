require "Basepack"
selectChar_s = class("selectChar_s",Basepack)
function selectChar_s:ctor()
    self._packtype = 10007    --[int]包标识,0x2717
    self._packindex = nil    --[int]标志
    self.charid = nil    --[int]角色id
    self.name = nil    --[string]名字

    local function appendToTable(t)
        -- print("selectChar_s:getPack")
        if t~= nil and type(t) == "table" then
            self:appendInt(t,self._packtype)
            self:appendInt(t,self._packindex)
            self:appendInt(t,self.charid)
            self:appendString(t,self.name)
        end
    end
    self._appendToTable = appendToTable
end
function selectChar_s:create()
    local ret = selectChar_s.new()
    return ret
end
function selectChar_s:getPack()
    local pack = {}
    self._appendToTable(pack)
    return pack
end