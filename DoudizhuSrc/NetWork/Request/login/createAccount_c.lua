require "Basepack"
createAccount_c = class("createAccount_c",Basepack)
function createAccount_c:ctor()
    self._packtype = 10000    --[int]包标识,0x2710
    self._packindex = nil    --[int]标志
    self.account = nil    --[string]账号
    self.pwd = nil    --[string]密码

    local function appendToTable(t)
        -- print("createAccount_c:getPack")
        if t~= nil and type(t) == "table" then
            self:appendInt(t,self._packtype)
            self:appendInt(t,self._packindex)
            self:appendString(t,self.account)
            self:appendString(t,self.pwd)
        end
    end
    self._appendToTable = appendToTable
end
function createAccount_c:create()
    local ret = createAccount_c.new()
    return ret
end
function createAccount_c:getPack()
    local pack = {}
    self._appendToTable(pack)
    return pack
end