
local AiRole = class("AiRole")


function AiRole:ctor()
    self.owner = nil
    self.AiList = {}
    self.Ai = ObjectDefine.Ai.none
end

function AiRole:setOwner(target)
    self.owner  = target
end

function AiRole:registerAI(Ai, updateFuncionName)
    self.AiList[Ai] = updateFuncionName
end

function AiRole:getAi()
    return self.Ai
end

function AiRole:setAi(cAi, param)
    local Ai = cAi or ObjectDefine.Ai_Event.none
    local lastAi = self.Ai
    param = param or {}
    param.lastAi = lastAi
    if self.AiList[self.Ai] then
        self.owner[ self.AiList[self.Ai] ](self.owner, ObjectDefine.Ai_Event.exit, param)
    end
    
    self.Ai = Ai
    if self.AiList[self.Ai] then
        self.owner[ self.AiList[self.Ai] ](self.owner, ObjectDefine.Ai_Event.enter, param)
    end
end

function AiRole:update(param)
    if self.AiList[self.Ai] then
        self.owner[ self.AiList[self.Ai] ](ObjectDefine.Ai_Event.execute, param)
    end
end

return AiRole
