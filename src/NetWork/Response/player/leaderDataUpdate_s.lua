require "Basepack"
leaderDataUpdate_s = class("leaderDataUpdate_s",Basepack)
function leaderDataUpdate_s:ctor()
    self._packtype = 10105    --[int]包标识,0x2779
    self._packindex = nil    --[int]标志
    self.leaderData = {}    --[leaderDataSnap]添加或更新的武将数据

    local function appendToTable(t)
        -- print("leaderDataUpdate_s:getPack")
        if t~= nil and type(t) == "table" then
            self:appendInt(t,self._packtype)
            self:appendInt(t,self._packindex)
            self:appendObject(t,self.leaderData)
        end
    end
    self._appendToTable = appendToTable
end
function leaderDataUpdate_s:create()
    local ret = leaderDataUpdate_s.new()
    return ret
end
function leaderDataUpdate_s:getPack()
    local pack = {}
    self._appendToTable(pack)
    return pack
end