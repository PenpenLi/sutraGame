require "Basepack"
fubenStar_s = class("fubenStar_s",Basepack)
function fubenStar_s:ctor()
    self._packtype = 10205    --[int]包标识,0x27dd
    self._packindex = nil    --[int]标志
    self.fbStars = nil    --[array]根据请求的ID列表，返回通关副本的星级

    local function appendToTable(t)
        -- print("fubenStar_s:getPack")
        if t~= nil and type(t) == "table" then
            self:appendInt(t,self._packtype)
            self:appendInt(t,self._packindex)
            self:appendObjectArray(t,self.fbStars)
        end
    end
    self._appendToTable = appendToTable
end
function fubenStar_s:create()
    local ret = fubenStar_s.new()
    return ret
end
function fubenStar_s:getPack()
    local pack = {}
    self._appendToTable(pack)
    return pack
end