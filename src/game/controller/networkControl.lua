local networkControl = class("networkControl", HotRequire(luaFile.CtrlBase))

local GAME_STATE = 
{
	unLogin,
	login
}

function networkControl:init()
	self.auser = require(luaFile.authUser)
	self.ausgame = require(luaFile.authGame)
	
	self.state = GAME_STATE.unLogin
end

function networkControl:authUser()
	local uuid = UserData:getUUID()
	
	local function loginCallback(event)
		log("###############loginCallback result: ", event)
		if event == self.auser.STATE.login_ok then
			--LayerManager.show(luaFile.roomLayer)
			self.state = GAME_STATE.login
			
			self.ausgame:connectGameServer()
		else
			
		end
	end
	local phone = "windows"
	if TARGET_PLATFORM == cc.PLATFORM_OS_ANDROID then phone = "android" end
	if TARGET_PLATFORM == cc.PLATFORM_OS_IPHONE or TARGET_PLATFORM == cc.PLATFORM_OS_IPAD then phone = "ios" end
	self.auser.start_login(uuid, phone, loginCallback)
end

function networkControl:sendMessage(msgName, msgData)
	local repeatTime = 0
	local data = DeepCopy(msgData)
	
	local function send()
		networkManager.request(msgName, data, 
			function(recv)
				if recv.errCode ~= 0 and repeatTime < 3 then
					send()
				end
				repeatTime=repeatTime+1
			end, 0)
	end
	
	send()
end


return networkControl