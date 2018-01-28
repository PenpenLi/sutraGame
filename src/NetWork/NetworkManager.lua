--require "json"

local networkManager = class("networkManager")
networkManager.logicType = { none = 0, userAuth = 1, game = 2 }
networkManager.stateCode = { close = 0, open = 1, }

networkManager.handlers = {}
networkManager.handlers[networkManager.logicType.userAuth] = require(luaFile.networkAuthUser)
networkManager.handlers[networkManager.logicType.game] = require(luaFile.networkGame)
for k,v in pairs(networkManager.handlers) do v.init(networkManager) end
networkManager.handle = networkManager.handlers[networkManager.logicType.userAuth]

networkManager.state = networkManager.stateCode.close





-- request message
function networkManager.request(...)
	networkManager.handle.request(...)
end


--private
function networkManager.send(msg, sz)
	CGame:NetReqRaw(msg, sz)
end

--private
function networkManager.recv(type, msg)
    print("networkManager.recv : type = "..type .. ", msg : " .. msg)
		

	if type == Constant.Network.CODE_ONOPEN then
		networkManager.state = networkManager.stateCode.open
		networkManager.handle.onOpen(type, msg)
		
	elseif type == Constant.Network.CODE_ONMESSAGE then
		networkManager.handle.onMessage(type, msg)
		
	elseif type == Constant.Network.CODE_ONERROR then
		networkManager.state = networkManager.stateCode.close
		networkManager.handle.onError(type, msg)
		
	elseif type == Constant.Network.CODE_ONCLOSE then
		networkManager.state = networkManager.stateCode.close
		networkManager.handle.onClose(type, msg)
	    
	elseif type == Constant.Network.CODE_RECONNECT then
		networkManager.state = networkManager.stateCode.open
		networkManager.handle.onReconnect(type, msg)
		
	elseif type == Constant.Network.CODE_RECONNECTERROR then
		networkManager.state = networkManager.stateCode.close
		networkManager.handle.onReconnectError(type, msg)
	end
end

--是否在线
function networkManager.isConnect()
    return networkManager.state == networkManager.stateCode.open
end

function networkManager.logic(st)
	for k,v in pairs(networkManager.logicType) do
		if st == v then
			networkManager.handle = networkManager.handlers[st]
			break
		end
	end
end


function networkManager.HttpGet(address,callback,timeout)
	CGame:HttpReqGet(address,callback,timeout or 20)
end


function networkManager.disconnect()
    CGame:NetDisconnect()
end

function networkManager.connect( ip, port, domain, connectCallback )
	print("networkManager.connect")
	local ip = ip or ""
    local port = port or 0
    local domain = domain or ""
    if domain ~= "" then ip = nil end
    
	networkManager.handle.setEventCallback(Constant.Network.CODE_ONOPEN, connectCallback)
	
    local fd = CGame:NetInitRaw(ip,port,domain,networkManager.recv) --初始化socket
    return fd
end


function networkManager.reconnect(ip,port,domain,reconnectCallback)
	print("networkManager.connect")
	local ip = ip or Config.LOGIN_SERVER_IP
    local port = port or Config.LOGIN_SERVER_PORT
    local domain = domain or ""
    if domain ~= "" then ip = nil end
    networkManager.handle.setEventCallback(Constant.Network.CODE_ONOPEN, reconnectCallback)
	
    local fd = CGame:NetReconnectWithIP(ip,port) --初始化socket
    return fd
end

--注册接收消息回调
function networkManager.registerMsgCallback(callback, registerName)
	networkManager.handle.setEventCallback(Constant.Network.CODE_ONMESSAGE, callback, registerName)
end
function networkManager.unRegisterMsgCallback(registerName)
	networkManager.handle.setUnEventCallback(Constant.Network.CODE_ONMESSAGE, registerName)
end
return networkManager