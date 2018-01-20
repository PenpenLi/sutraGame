require "Basepack"
gateSnap = class("gateSnap",Basepack)
function gateSnap:ctor()
    self.id = nil    --[int]主关卡ID,0x0
    self.amount = nil    --[int]关卡挑战剩余次数
    self.gateExtentSnaps = nil    --[array]关卡难易程度的信息列表

    local function appendToTable(t)
        -- print("gateSnap:getPack")
        if t~= nil and type(t) == "table" then
            self:appendInt(t,self.id)
            self:appendInt(t,self.amount)
            self:appendObjectArray(t,self.gateExtentSnaps)
        end
    end
    self._appendToTable = appendToTable
end
function gateSnap:create()
    local ret = gateSnap.new()
    return ret
end
function gateSnap:getPack()
    local pack = {}
    self._appendToTable(pack)
    return pack
end