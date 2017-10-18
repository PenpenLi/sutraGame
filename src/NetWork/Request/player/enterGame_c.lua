require "Basepack"
enterGame_c = class("enterGame_c",Basepack)
function enterGame_c:ctor()
    self._packtype = 10022    --[int]包标识,0x2726
    self._packindex = nil    --[int]标志
    self.charid = nil    --[int]角色id

    local function appendToTable(t)
        -- print("enterGame_c:getPack")
        if t~= nil and type(t) == "table" then
            self:appendInt(t,self._packtype)
            self:appendInt(t,self._packindex)
            self:appendInt(t,self.charid)
        end
    end
    self._appendToTable = appendToTable
end
function enterGame_c:create()
    local ret = enterGame_c.new()
    return ret
end
function enterGame_c:getPack()
    local pack = {}
    self._appendToTable(pack)
    return pack
end