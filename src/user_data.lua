

local UserData = class("UserData")

function UserData:ctor( ... )
    
    self:init()

end



function UserData:init( ... )
	self.signDay = CacheUtil:getCacheVal(CacheType.signDay)
	self.buddhasLightLevel = CacheUtil:getCacheVal(CacheType.buddhasLightLevel)
	self.buddhasLightDay = CacheUtil:getCacheVal(CacheType.buddhasLightDay)
	
	self.incenseDay = CacheUtil:getCacheVal(CacheType.incenseDay)

	self.songDay = CacheUtil:getCacheVal(CacheType.songDay)
	
	self.birthday = CacheUtil:getCacheVal(CacheType.birthday)
	
	self.toolList = CacheUtil:getCacheVal(CacheType.tools)--我的物品
	self.buddhasId = CacheUtil:getCacheVal(CacheType.buddhasId)--界面显示的佛祖
	self.usedTool = "1"--改成只有一种木鱼
	
	--self.chenghaoLv = 0--称号等级
	
	self.buddhasLightLevel = 3--佛光定为3级
	if self.buddhasLightLevel == 0 then 
		self.buddhasLightLevel = 1
		CacheUtil:setCacheVal(CacheType.buddhasLightLevel, self.buddhasLightLevel)
	end
	if self.birthday == 0 then 
		self.birthday = os.time()
		CacheUtil:setCacheVal(CacheType.birthday, self.birthday)
	end
	if self.buddhasLightDay == 0 then 
		self.buddhasLightDay = os.time()
		CacheUtil:setCacheVal(CacheType.buddhasLightDay, self.buddhasLightDay)
	end
	
	--解析我的物品数据
	local tools = string.split(self.toolList, ",")
	self.toolList = {}
	for k,v in pairs(tools) do 
		local tool = string.split(v, ":")
		self.toolList[tostring(tool[1])] = tonumber(tool[2])
	end
		
	self.todayCanSign = true
	self.todayCanIncense = true
	self.todayCanSong = true
	
	self.songCount = 0
	self.songContinueCount = 0
	
	self.signCount = 0
	self.signContinueCount = 0
	
	self.incenseCount = 0
	
	--当前选中的佛经
	self.selectSongs = 1
	
	--净土已打开数据
	self.jingtuOpenData = {}
	
	self.monthWeekDay = {}
	
	self.uuid = "ABCDEFG123456789"
	
	
	self.today = {month=0, day=0, year=0}
	local todayStr = self:getDayByTime(os.time())
	self.today.month, self.today.day, self.today.year = todayStr.month, todayStr.day, todayStr.year
	
	self:calcSign()
	self:calcIncense()
	self:calcSong()
	
	self:saveIncenseData()
	self:loadMusicRhythmData()
end

function UserData:saveUseTool( val )
	self.usedTool = tostring(val)
	self.usedTool = "1"--改成只有一种木鱼
	CacheUtil:setCacheVal(CacheType.usedTool, self.usedTool)
end

--保存登录数据
function UserData:saveSignData( ... )
	CacheUtil:setCacheVal(CacheType.signDay, self.signDay)
end

--保存点香数据
function UserData:saveIncenseData( ... )
	CacheUtil:setCacheVal(CacheType.incenseDay, self.incenseDay)
	self.buddhasLightLevel = 3--佛光定为3级
	CacheUtil:setCacheVal(CacheType.buddhasLightLevel, self.buddhasLightLevel)
	CacheUtil:setCacheVal(CacheType.buddhasLightDay, self.buddhasLightDay)
end

--保存诵经数据
function UserData:saveSongData( ... )
	CacheUtil:setCacheVal(CacheType.songDay, self.songDay)
end

--计算登录数据
function UserData:calcSign( ... )
	local signDay = self.signDay
	
	if not self.signDay[self.today.year] then self.signDay[self.today.year] = {} end
	if not self.signDay[self.today.year][self.today.month] then
		self.signDay[self.today.year][self.today.month] = {}
		for i=1, 31 do self.signDay[self.today.year][self.today.month][i] = false end
	end
	
	log("self.today", self.today)
	--當月
	for i=1, 31 do
		local dayTime = self:getTimeByDay(self.today.year, self.today.month, i)
		if not dayTime then
			break
		end
		
		local day = self:getDayByTime(dayTime)
		
		local sign = false
		if signDay[day.year] and signDay[day.year][day.month] and signDay[day.year][day.month][day.day] then--是否簽到
			if day.year == self.today.year and day.month == self.today.month and day.day == self.today.day then
				self.todayCanSign = false
			end
			sign = true
		else
		end
		self.monthWeekDay[i] = {wday=day.wday, sign=sign}--星期天为1
	end
	
	
	--登錄累計
	self.signCount = 0
	for y,yd in pairs(signDay) do
		for m,md in pairs(yd) do
			for d,dd in pairs(md) do
				if dd then self.signCount = self.signCount + 1 end
			end
		end
	end
	
	--连续登录
	self.signContinueCount = 0
	local curTime = self:getDayNoByTime( os.time() )
	local ondayTime = 60*60*24
	while true do
		local tday = self:getDayByTime(curTime)
		if signDay[tday.year] and signDay[tday.year][tday.month] and signDay[tday.year][tday.month][tday.day] then
			self.signContinueCount = self.signContinueCount + 1
		else
			break
		end
		curTime = curTime - ondayTime
	end
end

--计算点香数据
function UserData:calcIncense( ... )
	
	local incenseDay = self.incenseDay
	if not self.incenseDay[self.today.year] then self.incenseDay[self.today.year] = {} end
	if not self.incenseDay[self.today.year][self.today.month] then
		self.incenseDay[self.today.year][self.today.month] = {}
		for i=1, 31 do self.incenseDay[self.today.year][self.today.month][i] = false end
	end
	
	
	if self.incenseDay[self.today.year] and self.incenseDay[self.today.year][self.today.month] and self.incenseDay[self.today.year][self.today.month][self.today.day] then
		self.todayCanIncense = false
	end
	
	
	--上香累计
	self.incenseCount = 0
	for y,yd in pairs(self.incenseDay) do
		for m,md in pairs(yd) do
			for d,dd in pairs(md) do
				if dd then self.incenseCount = self.incenseCount + 1 end
			end
		end
	end
	
	--连续上香的佛光等级增益
	local tday = self:getDayByTime( self.buddhasLightDay )
	local lastInc = incenseDay[tday.year] and incenseDay[tday.year][tday.month] and incenseDay[tday.year][tday.month][tday.day]
	local curTime = self:getDayNoByTime( os.time() )
	local effLv = 0
	local ondayTime = 60*60*24
	local incTime = self.buddhasLightDay
	while true do
		if curTime < self:getDayNoByTime(incTime) then
			break
		end
		tday = self:getDayByTime( incTime )
		local inc = incenseDay[tday.year] and incenseDay[tday.year][tday.month] and incenseDay[tday.year][tday.month][tday.day]
		if inc ~= lastInc then
			effLv = 0
			log("!!!!", inc and "true" or "false", lastInc and "true" or "false")
			lastInc = inc
		end
		--log(">>", self:getDayNoByTime(incTime), curTime, inc and "true" or "false", tday, effLv, lastInc)
		incTime = incTime + ondayTime
		effLv = effLv + 1
		if effLv%3 == 0 then
			self.buddhasLightDay = incTime
			self.buddhasLightLevel = math.min(3, math.max(0, self.buddhasLightLevel + (lastInc and 1 or -1)))
			self.buddhasLightLevel = 3--佛光定为3级
		end
	end
end

function UserData:calcSong( ... )
	local songDay = self.songDay
	if not songDay[self.today.year] then songDay[self.today.year] = {} end
	if not songDay[self.today.year][self.today.month] then
		songDay[self.today.year][self.today.month] = {}
		for i=1, 31 do songDay[self.today.year][self.today.month][i] = false end
	end
	
	
	if songDay[self.today.year] and songDay[self.today.year][self.today.month] and songDay[self.today.year][self.today.month][self.today.day] then
		self.todayCanSong = false
	end
	
	--念经总数
	self.songCount = 0
	for y,yd in pairs(songDay) do
		for m,md in pairs(yd) do
			for d,dd in pairs(md) do
				if dd then self.songCount = self.songCount + 1 end
			end
		end
	end
	
	--连续念经天数
	self.songContinueCount = 0
	local curTime = self:getDayNoByTime( os.time() )
	local ondayTime = 60*60*24
	while true do
		local tday = self:getDayByTime(curTime)
		if songDay[tday.year] and songDay[tday.year][tday.month] and songDay[tday.year][tday.month][tday.day] then
			self.songContinueCount = self.songContinueCount + 1
		else
			break
		end
		curTime = curTime - ondayTime
	end
end

function UserData:signToday(  )
	if self.todayCanSign then
		self.signDay[self.today.year][self.today.month][self.today.day] = true
		self:calcSign()
		self:saveSignData()
	end
end

function UserData:incenseToday(  )
	if self.todayCanIncense then
		self.incenseDay[self.today.year][self.today.month][self.today.day] = true
		self:calcIncense()
		self:saveIncenseData()
	end
end

function UserData:songToday()
	if self.todayCanSong then
		self.songDay[self.today.year][self.today.month][self.today.day] = true
		self:calcSong()
		self:saveSongData()
		
		--1 玉石木鱼
		--2 白玉木鱼
		--3 莲花
		if self.songContinueCount >= 7 and self.songContinueCount < 30 then if not self.toolList["1"] then TipViewEx:showTip(TipViewEx.tipType.getTool) end self.toolList["1"] = 1 end
		
		if self.songContinueCount >= 30 and self.songContinueCount < 108 then if not self.toolList["2"] then TipViewEx:showTip(TipViewEx.tipType.getTool) end self.toolList["2"] = 1 end
		
		--if self.songContinueCount >= 108 then if not self.toolList["3"] then TipViewEx:showTip(TipViewEx.tipType.getTool) end self.toolList["3"] = 108 end
	end
end

function UserData:setTool_lotus( cnt )
	if not self.toolList["3"] then self.toolList["3"] = 0 end
	self.toolList["3"] = self.toolList["3"] + cnt
	
	self:saveToolsData()
end
function UserData:getTool_lotus(  )
	if not self.toolList["3"] then self.toolList["3"] = 0 end
	return self.toolList["3"]
end

--保存我的道具数据
function UserData:saveToolsData()
	local str = ""
	for k,v in pairs(self.toolList) do
		str = str .. "," .. k .. ":" .. v
	end
	if string.len(str) > 0 then
		str = string.sub(str, 2, string.len(str))
	end
	
	CacheUtil:setCacheVal(CacheType.tools, str)
end


function UserData:getDayByTime( t )
	local dates = os.date("*t", t)
	return dates
end

function UserData:getTimeByDay( year, month, day )
	
	return os.time({year=tonumber(year), month=tonumber(month), day=tonumber(day), hour=0})
end

--返回日历起总的第几天
function UserData:getDayNoByTime( t )
	local y = os.date("%Y", t)
	local d = os.date("%j", t)
	return y*366 + d
end

function UserData:loadMusicRhythmData()
	if not self.musicData then
		local ret = csvParse.LoadMusicRhythm("res/songData.csv")
		
		for k,v in pairs(ret) do
			v.score = 0
		end
		
		self.musicData = ret
		return ret
	else
		return self.musicData
	end
end

--获取选中的经文的佛祖信息
function UserData:getSelectSongInfo()
	if self.selectSongs == 0 then
		return nil
	end
	local musicData = UserData:loadMusicRhythmData()
	return musicData[self.selectSongs]
end

--设置每个music的分数
function UserData:setMusicScoreWithID(id, score)
	for k,v in pairs(self.musicData) do
		if v.id == id then
			v.score = v.score + score
			break
		end
	end
end

--设置净土已打开数据
function UserData:setJingtuOpenData(data)
	self.jingtuOpenData = {}
	local musicScoreList = string.split(data, ",")
	for k, v in pairs(musicScoreList) do
		local sc = string.split(v, ":")
		self.jingtuOpenData[sc[1]] = sc[2]
	end
end
function UserData:getJingtuOpenData(jingtuName)
	for k,v in pairs(self.jingtuOpenData ) do
		
	end
end

function UserData:setBuddhas(id)
	self.buddhasId = id
	CacheUtil:setCacheVal(CacheType.buddhasId, self.buddhasId)
end

function UserData:getBuddhas()
	return self.buddhasId
end

function UserData:getUuid()
	return self.uuid
end


return UserData
