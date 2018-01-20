require "Basepack"
loginAccount_s = class("loginAccount_s",Basepack)
function loginAccount_s:ctor()
    self._packtype = 10003    --[int]包标识,0x2713
    self._packindex = nil    --[int]标志
    self.retcode = nil    --[int]结果

    local function appendToTable(t)
        -- print("loginAccount_s:getPack")
        if t~= nil and type(t) == "table" then
            self:appendInt(t,self._packtype)
            self:appendInt(t,self._packindex)
            self:appendInt(t,self.retcode)
        end
    end
    self._appendToTable = appendToTable
end
function loginAccount_s:create()
    local ret = loginAccount_s.new()
    return ret
end
function loginAccount_s:getPack()
    local pack = {}
    self._appendToTable(pack)
    return pack
end