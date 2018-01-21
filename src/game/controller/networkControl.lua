local networkControl = {}

local GAME_STATE = 
{
	unLogin,
	login
}

function networkControl:init()
	self.auser = require(luaFile.authUser)
	
	self.state = GAME_STATE.unLogin
end

function networkControl:authUser()
	local uuid = "ABCDEFG123456789"
	
	local function loginCallback(event)
		log("###############loginCallback result: ", event)
		if event == self.auser.STATE.login_ok then
			--LayerManager.show(luaFile.roomLayer)
			self.state = GAME_STATE.login
		else
			
		end
	end
	self.auser.start_login(uuid, "", loginCallback)
end

return networkControl