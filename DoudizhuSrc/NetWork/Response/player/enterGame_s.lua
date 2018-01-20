require "Basepack"
enterGame_s = class("enterGame_s",Basepack)
function enterGame_s:ctor()
    self._packtype = 10023    --[int]包标识,0x2727
    self._packindex = nil    --[int]标志
    self.baseData = {}    --[playerDataSnap]玩家基础数据

    local function appendToTable(t)
        -- print("enterGame_s:getPack")
        if t~= nil and type(t) == "table" then
            self:appendInt(t,self._packtype)
            self:appendInt(t,self._packindex)
            self:appendObject(t,self.baseData)
        end
    end
    self._appendToTable = appendToTable
end
function enterGame_s:create()
    local ret = enterGame_s.new()
    return ret
end
function enterGame_s:getPack()
    local pack = {}
    self._appendToTable(pack)
    return pack
end