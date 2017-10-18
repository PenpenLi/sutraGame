require "Basepack"
gm_command_c = class("gm_command_c",Basepack)
function gm_command_c:ctor()
    self._packtype = 904    --[int]包标识,0x388
    self._packindex = nil    --[int]标志
    self.cmd = nil    --[string]GM特权命令）
    self.data = nil    --[string]参数

    local function appendToTable(t)
        -- print("gm_command_c:getPack")
        if t~= nil and type(t) == "table" then
            self:appendInt(t,self._packtype)
            self:appendInt(t,self._packindex)
            self:appendString(t,self.cmd)
            self:appendString(t,self.data)
        end
    end
    self._appendToTable = appendToTable
end
function gm_command_c:create()
    local ret = gm_command_c.new()
    return ret
end
function gm_command_c:getPack()
    local pack = {}
    self._appendToTable(pack)
    return pack
end