require "Basepack"
enterBattle_c = class("enterBattle_c",Basepack)
function enterBattle_c:ctor()
    self._packtype = 10200    --[int]包标识,0x27d8
    self._packindex = nil    --[int]标志
    self.gateId = nil    --[int]小关卡ID

    local function appendToTable(t)
        -- print("enterBattle_c:getPack")
        if t~= nil and type(t) == "table" then
            self:appendInt(t,self._packtype)
            self:appendInt(t,self._packindex)
            self:appendInt(t,self.gateId)
        end
    end
    self._appendToTable = appendToTable
end
function enterBattle_c:create()
    local ret = enterBattle_c.new()
    return ret
end
function enterBattle_c:getPack()
    local pack = {}
    self._appendToTable(pack)
    return pack
end