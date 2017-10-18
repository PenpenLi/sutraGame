require "Basepack"
expAdd_s = class("expAdd_s",Basepack)
function expAdd_s:ctor()
    self._packtype = 10082    --[int]包标识,0x2762
    self._packindex = nil    --[int]标志
    self.change = nil    --[int]改变体力数量
    self.total = nil    --[int]当前体力数量

    local function appendToTable(t)
        -- print("expAdd_s:getPack")
        if t~= nil and type(t) == "table" then
            self:appendInt(t,self._packtype)
            self:appendInt(t,self._packindex)
            self:appendInt(t,self.change)
            self:appendInt(t,self.total)
        end
    end
    self._appendToTable = appendToTable
end
function expAdd_s:create()
    local ret = expAdd_s.new()
    return ret
end
function expAdd_s:getPack()
    local pack = {}
    self._appendToTable(pack)
    return pack
end