require "Basepack"
pushFubenNewsSnap = class("pushFubenNewsSnap",Basepack)
function pushFubenNewsSnap:ctor()
    self.sceneList1 = nil    --[array]场景1副本数据列表,0x0
    self.sceneList2 = nil    --[array]场景2副本数据列表
    self.sceneList3 = nil    --[array]场景3副本数据列表

    local function appendToTable(t)
        -- print("pushFubenNewsSnap:getPack")
        if t~= nil and type(t) == "table" then
            self:appendObjectArray(t,self.sceneList1)
            self:appendObjectArray(t,self.sceneList2)
            self:appendObjectArray(t,self.sceneList3)
        end
    end
    self._appendToTable = appendToTable
end
function pushFubenNewsSnap:create()
    local ret = pushFubenNewsSnap.new()
    return ret
end
function pushFubenNewsSnap:getPack()
    local pack = {}
    self._appendToTable(pack)
    return pack
end