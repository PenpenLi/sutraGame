------------------------------------
-- desc:状态基类
------------------------------------
local StateBase = class("StateBase", {})
function StateBase:ctor(state_type)
    self.state_type = state_type
end

function StateBase:GetType()
    return self.state_type
end

function StateBase:Enter(...)
    
end

function StateBase:Exit(...)

end

return StateBase