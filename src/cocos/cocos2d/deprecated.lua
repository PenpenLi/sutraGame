
function schedule(node, callback, delay)
    local delay = cc.DelayTime:create(delay)
    local sequence = cc.Sequence:create(delay, cc.CallFunc:create(callback))
    local action = cc.RepeatForever:create(sequence)
    node:runAction(action)
    return action
end

function scheduleG(callback, delay)
    local delay = cc.DelayTime:create(delay)
    local sequence = cc.Sequence:create(delay, cc.CallFunc:create(callback))
    local action = cc.RepeatForever:create(sequence)
    cc.Director:getInstance():getRunningScene():runAction(action)
    return action
end

function unScheduleG(handle)
	if handle then
		cc.Director:getInstance():getRunningScene():stopAction(handle)
	end
end

function performWithDelay(node, callback, delay)
    local delay = cc.DelayTime:create(delay)
    local sequence = cc.Sequence:create(delay, cc.CallFunc:create(callback))
    node:runAction(sequence)
    return sequence
end

function performWithDelayG( callback, delay)
    local delay = cc.DelayTime:create(delay)
    local sequence = cc.Sequence:create(delay, cc.CallFunc:create(callback))
    cc.Director:getInstance():getRunningScene():runAction(sequence)
    return sequence
end
