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
	log("*******serverMessageCallback", name, data)
	
	if name == "pushUserData" then
		if data.type == "totalRank" then
			UserData:setTotalRank(data.data)
		end
		if data.type == "signNum" then
			UserData:setSignNum(data.data)
		end
		if data.type == "signRank" then
			UserData:setSignRank(data.data)
		end
		if data.type == "censerNum" then
			UserData:setCenserNum(data.data)
		end
		if data.type == "censerRank" then
			UserData:setCenserRank(data.data)
		end
		if data.type == "sutraNum" then
			UserData:setSutraNum(data.data)
		end
		if data.type == "sutraRank" then
			UserData:setSutraRank(data.data)
		end
		if data.type == "lotusNum" then
			UserData:setLotusNum(data.data)
		end
		if data.type == "incenseLastTime" then
			UserData:setIncenseLastTime(tonumber(data.data))
		end
		if data.type == "sutraLastTime" then
			UserData:setSutraLastTime(tonumber(data.data))
		end
		if data.type == "fohaoMonthNum" then
			UserData:setFohaoMonthNum(tonumber(data.data))
		end
		
		
		if data.type == "fohaoGroup" then
			local musicScoreList = string.split(data.data, ",")
			for k, v in pairs(musicScoreList) do
				local sc = string.split(v, ":")
				UserData:setMusicScoreWithID(tonumber(sc[1]), tonumber(sc[2]))
			end
		end
		if data.type == "jingtuGroup" then
			local jingtuList = string.split(data.data, ",")
			for k, v in pairs(jingtuList) do
				local sc = string.split(v, ":")
				UserData:setJingtuOpenData(sc[1], tonumber(sc[2]))
			end
		end
		if data.type == "fohaoMonthNum" then
			UserData:setFohaoMonthNum(tonumber(data.data))
		end
		
		
	elseif name == "sendNote" then
		self:dispatchEvent({name = GlobalEvent.UPDATE_NOTE_NOTIFY, data={note=data.note}})
	end
end

function authGame:connectServerCallback(data)
	if data == "open" then
		print("服务器连接成功")
		self:sendTotalPushRequest()
		
	else
		print("服务器连接失败")
	end
end

function authGame:sendTotalPushRequest()
	if not self.totalPush_DelayHandle then
		self.totalPush_DelayHandle = scheduleG( function() self:sendTotalPushRequest() end, 5)
	end
	
	performWithDelayG( function()
		networkManager.request("totalPush",
		{uuid=UserData:getUUID()}, 
		handler(self, self.totalPushCallback))
			end, 0.1)
end

function authGame:totalPushCallback(data)
	unScheduleG(self.totalPush_DelayHandle)
	
	log("totalPushCallback", data)
	
	UserData:setToday(data.serverTime)
	
	UserData:setSignDayInfo(data.signLine)
	
	UserData:setTotalRank(data.totalRank)
	
	UserData:setSignNum(data.signNum)
	
	UserData:setSignRank(data.signRank)
	
	UserData:setCenserNum(data.censerNum)
	
	UserData:setCenserRank(data.censerRank)
	
	UserData:setSutraNum(data.sutraNum)
	
	UserData:setFohaoMonthNum(data.fohaoMonthNum)
	
	UserData:setSutraRank(data.sutraRank)
	
	UserData:setLotusNum(data.lotusNum)
	
	UserData:setIncenseLastTime(data.incenseLastTime)
	
	UserData:setSutraLastTime(data.sutraLastTime)
	
	
	local musicScoreList = string.split(data.fohaoGroup, ",")
	for k, v in pairs(musicScoreList) do
		local sc = string.split(v, ":")
		UserData:setMusicScoreWithID(tonumber(sc[1]), tonumber(sc[2]))
	end
	
	local jingtuList = string.split(data.jingtuGroup, ",")
	for k, v in pairs(jingtuList) do
		local sc = string.split(v, ":")
		UserData:setJingtuOpenData(sc[1], tonumber(sc[2]))
	end
end

cc.load("event"):setEventDispatcher(authGame, GameController)

return authGame