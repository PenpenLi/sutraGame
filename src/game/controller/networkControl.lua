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
	local uuid = UserData:getUuid()
	
	local function loginCallback(event)
		log("###############loginCallback result: ", event)
		if event == self.auser.STATE.login_ok then
			--LayerManager.show(luaFile.roomLayer)
			self.state = GAME_STATE.login
			
			self.ausgame:connectGameServer()
		else
			
		end
	end
	self.auser.start_login(uuid, TARGET_PLATFORM == cc.PLATFORM_OS_WINDOWS and "windows" or "", loginCallback)
end

return networkControl