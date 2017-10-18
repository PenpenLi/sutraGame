--=======================================================================
-- File Name    : real_timer.lua
-- Creator      : owen(1053210246@qq.com)
-- Date         : 2014/7/1 20:41:20
-- Description  : real timer, no not effect by game pause
-- Modify       :
--=======================================================================

RealTimer = RealTimer or {}

function RealTimer:RegTimerByCount(count, time, call_back, param)
    local handle = nil
    local director = cc.Director:getInstance()
    local rest_count = count
    param = param or {}
    local function onTimer()
        rest_count = rest_count - 1
        -- call_back[#call_back + 1] = rest_count
        call_back(unpack(param))
        -- call_back[#call_back] = nil
        if rest_count <= 0 then
            director:getScheduler():unscheduleScriptEntry(handle)
        end
    end
    handle = director:getScheduler():scheduleScriptFunc(onTimer, time, false)
    return handle
end

function RealTimer:RegTimerLoop(time, call_back, param)
    local handle = nil
    local director = cc.Director:getInstance()
    param = param or {}
    local function onTimer(...)
        call_back(unpack(param))
    end
    handle = director:getScheduler():scheduleScriptFunc(onTimer, time, false)
    return handle
end

function RealTimer:RegTimerLoopImmediate(time, call_back, param)
    param = param or {}
    call_back(unpack(param))
    return self:RegTimerLoop(time, call_back, param)
end

function RealTimer:RegTimerLoopWithTime(time, call_back, param)
    local handle = nil
    local director = cc.Director:getInstance()
    param = param or {}
    local function onTimer(delta_time)
        call_back(delta_time, unpack(param))
    end
    handle = director:getScheduler():scheduleScriptFunc(onTimer, time, false)
    return handle
end

function RealTimer:RegTimerOnce(time, call_back, param)
    local handle = nil
    local director = cc.Director:getInstance()
    param = param or {}
    local function onTimer()
        call_back(unpack(param))
        director:getScheduler():unscheduleScriptEntry(handle)
    end
    handle = director:getScheduler():scheduleScriptFunc(onTimer, time, false)
    return handle
end

function RealTimer:UnRegTimer(handle)
    return cc.Director:getInstance():getScheduler():unscheduleScriptEntry(handle)
end
