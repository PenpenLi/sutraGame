require "Basepack"
yuqiang_s = class("yuqiang_s",Basepack)
function yuqiang_s:ctor()
    self._packtype = 11001    --[int]包标识,0x2af9
    self._packindex = nil    --[int]标志
    self.retNum = nil    --[float]返回测试内容

    local function appendToTable(t)
        -- print("yuqiang_s:getPack")
        if t~= nil and type(t) == "table" then
            self:appendInt(t,self._packtype)
            self:appendInt(t,self._packindex)
            self:appendFloat(t,self.retNum)
        end
    end
    self._appendToTable = appendToTable
end
function yuqiang_s:create()
    local ret = yuqiang_s.new()
    return ret
end
function yuqiang_s:getPack()
    local pack = {}
    self._appendToTable(pack)
    return pack
end