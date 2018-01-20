require "Basepack"
levelUp_s = class("levelUp_s",Basepack)
function levelUp_s:ctor()
    self._packtype = 10083    --[int]包标识,0x2763
    self._packindex = nil    --[int]标志
    self.level = nil    --[int]当前等级

    local function appendToTable(t)
        -- print("levelUp_s:getPack")
        if t~= nil and type(t) == "table" then
            self:appendInt(t,self._packtype)
            self:appendInt(t,self._packindex)
            self:appendInt(t,self.level)
        end
    end
    self._appendToTable = appendToTable
end
function levelUp_s:create()
    local ret = levelUp_s.new()
    return ret
end
function levelUp_s:getPack()
    local pack = {}
    self._appendToTable(pack)
    return pack
end