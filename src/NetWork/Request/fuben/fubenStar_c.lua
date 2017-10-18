require "Basepack"
fubenStar_c = class("fubenStar_c",Basepack)
function fubenStar_c:ctor()
    self._packtype = 10204    --[int]包标识,0x27dc
    self._packindex = nil    --[int]标志
    self.fbIds = nil    --[array]副本ID列表

    local function appendToTable(t)
        -- print("fubenStar_c:getPack")
        if t~= nil and type(t) == "table" then
            self:appendInt(t,self._packtype)
            self:appendInt(t,self._packindex)
            self:appendIntArray(t,self.fbIds)
        end
    end
    self._appendToTable = appendToTable
end
function fubenStar_c:create()
    local ret = fubenStar_c.new()
    return ret
end
function fubenStar_c:getPack()
    local pack = {}
    self._appendToTable(pack)
    return pack
end