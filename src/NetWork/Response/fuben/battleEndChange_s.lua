require "Basepack"
battleEndChange_s = class("battleEndChange_s",Basepack)
function battleEndChange_s:ctor()
    self._packtype = 10207    --[int]包标识,0x27df
    self._packindex = nil    --[int]标志
    self.sceneId = nil    --[int]场景ID
    self.fbId = nil    --[int]副本Id
    self.gateId = nil    --[int]关卡ID
    self.amount = nil    --[int]关卡剩余挑战次数
    self.currGateExtent = nil    --[gateExtentSnap]当前关卡更新

    local function appendToTable(t)
        -- print("battleEndChange_s:getPack")
        if t~= nil and type(t) == "table" then
            self:appendInt(t,self._packtype)
            self:appendInt(t,self._packindex)
            self:appendInt(t,self.sceneId)
            self:appendInt(t,self.fbId)
            self:appendInt(t,self.gateId)
            self:appendInt(t,self.amount)
            self:appendObject(t,self.currGateExtent)
        end
    end
    self._appendToTable = appendToTable
end
function battleEndChange_s:create()
    local ret = battleEndChange_s.new()
    return ret
end
function battleEndChange_s:getPack()
    local pack = {}
    self._appendToTable(pack)
    return pack
end