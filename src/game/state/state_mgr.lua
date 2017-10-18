------------------------------------
-- desc:状态管理器
------------------------------------
local StateMgr = class("StateMgr", {})

StateType = {
    Game=1,
}

local StateClass = {
    luaFile.StateGame,
}

function StateMgr:ctor( ... )
    self.cur_state_type = nil
    self.state_list = {}
    self:InitStateList()
end

function StateMgr:InitStateList()
    for _,state_type in pairs(StateType) do
        self.state_list[state_type] = new_class(StateClass[state_type])
    end
end

function StateMgr:ChangeState(state_type,...)
    if self.cur_state_type == state_type then
        return
    end
	
    if self.cur_state_type then
        local pre_state_obj = self.state_list[self.cur_state_type]
        if pre_state_obj then
            pre_state_obj:Exit(...)
        end
    end
    self.cur_state_type = state_type
    local now_state_obj = self.state_list[self.cur_state_type]
    if now_state_obj then
        now_state_obj:Enter(...)
    end
end

function StateMgr:GetState(state_type)
    return self.state_list[self.cur_state_type]
end

function StateMgr:GetStateType()
	return self.cur_state_type
end

return StateMgr