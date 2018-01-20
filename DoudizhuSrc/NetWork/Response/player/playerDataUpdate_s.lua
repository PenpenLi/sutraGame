require "Basepack"
playerDataUpdate_s = class("playerDataUpdate_s",Basepack)
function playerDataUpdate_s:ctor()
    self._packtype = 10070    --[int]包标识,0x2756
    self._packindex = nil    --[int]标志
    self.changeKeys = nil    --[array]记录有变化的键
    self.changeValues = nil    --[array]记录有变化的值

    local function appendToTable(t)
        -- print("playerDataUpdate_s:getPack")
        if t~= nil and type(t) == "table" then
            self:appendInt(t,self._packtype)
            self:appendInt(t,self._packindex)
            self:appendStringArray(t,self.changeKeys)
            self:appendStringArray(t,self.changeValues)
        end
    end
    self._appendToTable = appendToTable
end
function playerDataUpdate_s:create()
    local ret = playerDataUpdate_s.new()
    return ret
end
function playerDataUpdate_s:getPack()
    local pack = {}
    self._appendToTable(pack)
    return pack
end