require "Basepack"
info_s = class("info_s",Basepack)
function info_s:ctor()
    self._packtype = 10045    --[int]包标识,0x273d
    self._packindex = nil    --[int]标志
    self.thisid = nil    --[int]道具唯一id
    self.baseid = nil    --[int]类型
    self.num = nil    --[int]数量

    local function appendToTable(t)
        -- print("info_s:getPack")
        if t~= nil and type(t) == "table" then
            self:appendInt(t,self._packtype)
            self:appendInt(t,self._packindex)
            self:appendInt(t,self.thisid)
            self:appendInt(t,self.baseid)
            self:appendInt(t,self.num)
        end
    end
    self._appendToTable = appendToTable
end
function info_s:create()
    local ret = info_s.new()
    return ret
end
function info_s:getPack()
    local pack = {}
    self._appendToTable(pack)
    return pack
end