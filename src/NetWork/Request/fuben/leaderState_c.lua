require "Basepack"
leaderState_c = class("leaderState_c",Basepack)
function leaderState_c:ctor()
    self._packtype = 10212    --[int]包标识,0x27e4
    self._packindex = nil    --[int]标志
    self.stateSnap = nil    --[array]上阵状态列表
    self.form = nil    --[int]阵型

    local function appendToTable(t)
        -- print("leaderState_c:getPack")
        if t~= nil and type(t) == "table" then
            self:appendInt(t,self._packtype)
            self:appendInt(t,self._packindex)
            self:appendObjectArray(t,self.stateSnap)
            self:appendInt(t,self.form)
        end
    end
    self._appendToTable = appendToTable
end
function leaderState_c:create()
    local ret = leaderState_c.new()
    return ret
end
function leaderState_c:getPack()
    local pack = {}
    self._appendToTable(pack)
    return pack
end