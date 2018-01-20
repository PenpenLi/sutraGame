require "Basepack"
pushFubenNews_s = class("pushFubenNews_s",Basepack)
function pushFubenNews_s:ctor()
    self._packtype = 10208    --[int]包标识,0x27e0
    self._packindex = nil    --[int]标志
    self.sceneList1 = nil    --[array]场景1副本数据列表
    self.sceneList2 = nil    --[array]场景2副本数据列表
    self.sceneList3 = nil    --[array]场景3副本数据列表

    local function appendToTable(t)
        -- print("pushFubenNews_s:getPack")
        if t~= nil and type(t) == "table" then
            self:appendInt(t,self._packtype)
            self:appendInt(t,self._packindex)
            self:appendObjectArray(t,self.sceneList1)
            self:appendObjectArray(t,self.sceneList2)
            self:appendObjectArray(t,self.sceneList3)
        end
    end
    self._appendToTable = appendToTable
end
function pushFubenNews_s:create()
    local ret = pushFubenNews_s.new()
    return ret
end
function pushFubenNews_s:getPack()
    local pack = {}
    self._appendToTable(pack)
    return pack
end