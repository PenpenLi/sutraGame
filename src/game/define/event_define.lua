
eventSerial = 100000
GlobalEvent = {}-- 全局事件

local function ID()
	eventSerial = eventSerial + 1
	return tostring(eventSerial)
end
function regGlobalEvent(event)
	if GlobalEvent[event] then
		error("GlobalEvent重写!!")
	else
		GlobalEvent[event] = ID()
	end
end

regGlobalEvent("NETWORK") 
regGlobalEvent("MESSAGE_ERRORCODE_SUCCESS") 
regGlobalEvent("ENTER_BACKGROUND")
regGlobalEvent("ENTER_FOREGROUND")
regGlobalEvent("SHOW_LOADING")
regGlobalEvent("REMOVE_LOADING")

regGlobalEvent("SIGN_VIEW_SHOW")
regGlobalEvent("SUTRA_VIEW_SHOW")
regGlobalEvent("SUTRAOVER_VIEW_SHOW")
regGlobalEvent("EXITGAME_VIEW_SHOW")
regGlobalEvent("RANK_VIEW_SHOW")
regGlobalEvent("TASK_VIEW_SHOW")
regGlobalEvent("TOOL_VIEW_SHOW")
regGlobalEvent("CLICK_WOODENFINISH_SUCCESS")

