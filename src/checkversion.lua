
require "config"
require "Network.networkManager"


local checkv = {}
updateVersion.STATE = {
connecting = 1,
connectfail = 2,
checkgameversion = 3,
updategameversion = 4,
latestgameversion = 5,
}
checkv.notifyCallback = function() end

local function checkgameversionCallback(msg)
	local datas = string.split(msg, "_")
	
	--²»ÓÃÉý¼¶
	if datas[1] == Constant.gameVersion then
		checkv.notifyCallback(updateVersion.STATE.latestgameversion)
	else
		checkv.notifyCallback(updateVersion.STATE.updategameversion)
	end
end

local function connectCallback(state)
	if state == networkManager.stateCode.open then
		checkv.notifyCallback(updateVersion.STATE.checkgameversion)
		
		Constant.gameVersion = cc.UserDefault:getInstance():getStringForKey(Constant.savekey_gameVersion, "1.0")
		networkManager.request(Constant.server_checkVersion_desc .. "_" .. Constant.gameVersion)
		networkManager.registerMsgCallback(checkgameversionCallback)
		
	else
		checkv.notifyCallback(updateVersion.STATE.connectfail)
	end
end

function checkv.start(notifyCallback)
	if notifyCallback then checkv.notifyCallback = notifyCallback end
	
	checkv.notifyCallback(updateVersion.STATE.connecting)
	
	networkManager.logic(networkManager.logicType.userAuth)
	networkManager.connect( GAME_LOGIN_IP_ADDRESS, GAME_LOGIN_IP_PORT, "", connectCallback )
end

return checkv