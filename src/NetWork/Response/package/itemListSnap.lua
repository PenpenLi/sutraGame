require "Basepack"
itemListSnap = class("itemListSnap",Basepack)
function itemListSnap:ctor()
    self.thisid = nil    --[int]undefined,0x0
    self.itemid = nil    --[int]
    self.num = nil    --[int]

    local function appendToTable(t)
        -- print("itemListSnap:getPack")
        if t~= nil and type(t) == "table" then
            self:appendInt(t,self.thisid)
            self:appendInt(t,self.itemid)
            self:appendInt(t,self.num)
        end
    end
    self._appendToTable = appendToTable
end
function itemListSnap:create()
    local ret = itemListSnap.new()
    return ret
end
function itemListSnap:getPack()
    local pack = {}
    self._appendToTable(pack)
    return pack
end