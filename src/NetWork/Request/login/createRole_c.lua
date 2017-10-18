require "Basepack"
createRole_c = class("createRole_c",Basepack)
function createRole_c:ctor()
    self._packtype = 10004    --[int]包标识,0x2714
    self._packindex = nil    --[int]标志
    self.job = nil    --[int]玩家职业
    self.name = nil    --[string]玩家名字
    self.aid = nil    --[int]玩家aid

    local function appendToTable(t)
        -- print("createRole_c:getPack")
        if t~= nil and type(t) == "table" then
            self:appendInt(t,self._packtype)
            self:appendInt(t,self._packindex)
            self:appendInt(t,self.job)
            self:appendString(t,self.name)
            self:appendInt(t,self.aid)
        end
    end
    self._appendToTable = appendToTable
end
function createRole_c:create()
    local ret = createRole_c.new()
    return ret
end
function createRole_c:getPack()
    local pack = {}
    self._appendToTable(pack)
    return pack
end