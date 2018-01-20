require "Basepack"
selectChar_c = class("selectChar_c",Basepack)
function selectChar_c:ctor()
    self._packtype = 10006    --[int]包标识,0x2716
    self._packindex = nil    --[int]标志
    self.aid = nil    --[int]账号id

    local function appendToTable(t)
        -- print("selectChar_c:getPack")
        if t~= nil and type(t) == "table" then
            self:appendInt(t,self._packtype)
            self:appendInt(t,self._packindex)
            self:appendInt(t,self.aid)
        end
    end
    self._appendToTable = appendToTable
end
function selectChar_c:create()
    local ret = selectChar_c.new()
    return ret
end
function selectChar_c:getPack()
    local pack = {}
    self._appendToTable(pack)
    return pack
end