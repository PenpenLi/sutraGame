networkHandle_game = class("networkHandle_game")
local crypts = require("crypt")
local stringex = require("stringex")
local networkMgr
local networkEvent_callback = {}
local m_host
local m_request
local m_session = 0
local m_packageIndex = 0
local m_responseHandler = {}

local network = networkHandle_game	
function network.init(mgr)
	networkMgr = mgr
	
	local proto = require "skynet.proto"
	local sproto = require "skynet.sproto"
    m_host = sproto.new(proto.s2c):host "package"
    m_request = m_host:attach(sproto.new(proto.c2s))

end


function network.request(protoname, value, handler, showloading, waitTime)
	local function send_package(fd, packMsg)
	    --local pack = string.format( "%q", stringex.pack(">s2", packMsg) )
		local pack = stringex.pack(">s2", packMsg)
	    		
		networkMgr.send(pack, string.len(pack))
    end

	local function send_request(name, args)
	    m_session = m_session + 1
        if m_session > 999999 then m_session = 1 end
				
        m_packageIndex = m_packageIndex + 1
        if m_packageIndex > 999999 then m_packageIndex = 1 end

        print("send_request.name:", name, m_session)
        print_lua_table(args)

	    local str = m_request(name, args, m_session)
	    send_package(fd, str)
    end
    send_request(protoname, value)
	
    if handler then
        m_responseHandler[m_session] = handler
    end
end

function network.setEventCallback( eventType, callback, registerName )
	if not networkEvent_callback[eventType] then 
		networkEvent_callback[eventType] = {}
	end
	
	networkEvent_callback[eventType][registerName or "defaultname"] = callback
end

function network.eventCallback( eventType, ... )
	if networkEvent_callback[eventType] then
		for k,v in pairs(networkEvent_callback[eventType]) do
			v(...)
		end
	end
end

function network.setUnEventCallback(eventType, registerName)
	if networkEvent_callback[eventType] then
		for k,v in pairs(networkEvent_callback[eventType]) do
			if registerName == k then
				networkEvent_callback[eventType][k] = nil
				break
			end
		end
	end
end

function network.onOpen(type, ...)
	network.eventCallback(type, ...)
end

local function unpack_package(text)
	local size = #text
	if size < 2 then
		return nil, text
	end
	local s = text:byte(1) * 256 + text:byte(2)
	if size < s+2 then
		return nil, text
	end

	return text:sub(3,2+s), text:sub(3+s)
end

function network.onMessage(type, msg)
	local v, last = unpack_package(msg)
    local function print_package(t, ...)
		local function print_request(name, args, packageindex)
			print("REQUEST", name)
			--if args then
				network.eventCallback( type, name, args )
			--end
		end
		local function print_response(session, args, packageindex)
			print("RESPONSE", session)
			local pi = tonumber(session)
			if args then
				if m_responseHandler[pi] then
					m_responseHandler[pi](args)
				end
			end
		end

		if t == "REQUEST" then
			print_request(...)
		else
			assert(t == "RESPONSE")
			print_response(...)
		end
	end

	print_package(m_host:dispatch(v))

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

return networkHandle_game