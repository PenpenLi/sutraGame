networkHandle_authUser = class("networkHandle_authUser")
local crypts = require("crypt")
local networkMgr
local networkEvent_callback = {}
local network = networkHandle_authUser

function network.init(mgr)
	networkMgr = mgr
end


function network.request(msg)
	local pack = crypts.base64encode(msg) .. "\n"
	networkMgr.send(pack, string.len(pack))
end

function network.setEventCallback( eventType, callback )
	networkEvent_callback[eventType] = callback
end

function network.eventCallback( eventType, msg )
	if networkEvent_callback[eventType] then
		networkEvent_callback[eventType](msg)
	end
end

function network.onOpen(type, msg)
	network.eventCallback(type, msg)
end

function network.onMessage(type, msg)
	local function unpack_line(text)
		local from = text:find("\n", 1, true)
		if from then
			return text:sub(1, from-1), text:sub(from+1)
		end
		return nil, text
	end
	
	local result, last = unpack_line(msg)
	network.eventCallback( type, crypts.base64decode(result) )
end

function network.onError(type, msg)
	network.eventCallback(type, msg)
end

function network.onClose(type, msg)
	network.eventCallback(type, msg)
end

function network.onReconnect(type, msg)
	network.eventCallback(type, msg)
end

function network.onReconnectError(type, msg)
	network.eventCallback(type, msg)
end

return networkHandle_authUser