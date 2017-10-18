require "Basepack"
battleEnd_c = class("battleEnd_c",Basepack)
function battleEnd_c:ctor()
    self._packtype = 10202    --[int]包标识,0x27da
    self._packindex = nil    --[int]标志
    self.gateId = nil    --[int]小关卡ID
    self.grade = nil    --[int]通关评级

    local function appendToTable(t)
        -- print("battleEnd_c:getPack")
        if t~= nil and type(t) == "table" then
            self:appendInt(t,self._packtype)
            self:appendInt(t,self._packindex)
            self:appendInt(t,self.gateId)
            self:appendInt(t,self.grade)
        end
    end
    self._appendToTable = appendToTable
end
function battleEnd_c:create()
    local ret = battleEnd_c.new()
    return ret
end
function battleEnd_c:getPack()
    local pack = {}
    self._appendToTable(pack)
    return pack
end