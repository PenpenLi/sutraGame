require "Basepack"
gateExtentSnap = class("gateExtentSnap",Basepack)
function gateExtentSnap:ctor()
    self.id = nil    --[int]关卡ID,0x0
    self.type = nil    --[int]关卡类型（1普通，2简单，3困难）
    self.grade = nil    --[int]"评分(1

    local function appendToTable(t)
        -- print("gateExtentSnap:getPack")
        if t~= nil and type(t) == "table" then
            self:appendInt(t,self.id)
            self:appendInt(t,self.type)
            self:appendInt(t,self.grade)
        end
    end
    self._appendToTable = appendToTable
end
function gateExtentSnap:create()
    local ret = gateExtentSnap.new()
    return ret
end
function gateExtentSnap:getPack()
    local pack = {}
    self._appendToTable(pack)
    return pack
end