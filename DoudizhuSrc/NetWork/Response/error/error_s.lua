require "Basepack"
error_s = class("error_s",Basepack)
function error_s:ctor()
    self._packtype = 900    --[int]包标识,0x384
    self._packindex = nil    --[int]标志
    self.retcode = nil    --[int]错误代码

    local function appendToTable(t)
        -- print("error_s:getPack")
        if t~= nil and type(t) == "table" then
            self:appendInt(t,self._packtype)
            self:appendInt(t,self._packindex)
            self:appendInt(t,self.retcode)
        end
    end
    self._appendToTable = appendToTable
end
function error_s:create()
    local ret = error_s.new()
    return ret
end
function error_s:getPack()
    local pack = {}
    self._appendToTable(pack)
    return pack
end