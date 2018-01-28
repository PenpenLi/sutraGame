local authGame = {}

function authGame:connectGameServer()
	networkManager.logic(networkManager.logicType.game)
	
	networkManager.registerMsgCallback(handler(self, self.serverMessageCallback), "roomLayer")
	
	networkManager.connect(GAME_GAME_IP_ADDRESS,
	GAME_GAME_IP_PORT,
	"",
	handler(self, self.connectServerCallback))
end


function authGame:serverMessageCallback(name, data)
	print("*******authGame:serverMessageCallback", name)
	
	
	if name == "pushUserData" then
		
	end
end

function authGame:connectServerCallback(data)
	if data == "open" then
		print("服务器连接成功")
		
		performWithDelayG( function()
			networkManager.request("totalPush",
			{uuid=UserData:getUuid()}, 
			handler(self, self.totalPushCallback))
				end, 0)
	else
		print("服务器连接失败")
	end
end

function authGame:totalPushCallback(data)
	log("totalPushCallback", data)
	local musicScoreList = string.split(fohaoGroup, ",")
	for k, v in pairs(musicScoreList) do
		local sc = string.split(v, "_")
		UserData:setMusicScoreWithID(tonumber(v[1]), tonumber(v[2]))
	end
	
	
end

return authGame