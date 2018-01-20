require "Basepack"
createAccount_s = class("createAccount_s",Basepack)
function createAccount_s:ctor()
    self._packtype = 10001    --[int]包标识,0x2711
    self._packindex = nil    --[int]标志
    self.retcode = nil    --[int]账号

    local function appendToTable(t)
        -- print("createAccount_s:getPack")
        if t~= nil and type(t) == "table" then
            self:appendInt(t,self._packtype)
            self:appendInt(t,self._packindex)
            self:appendInt(t,self.retcode)
        end
    end
    self._appendToTable = appendToTable
end
function createAccount_s:create()
    local ret = createAccount_s.new()
    return ret
end
function createAccount_s:getPack()
    local pack = {}
    self._appendToTable(pack)
    return pack
end