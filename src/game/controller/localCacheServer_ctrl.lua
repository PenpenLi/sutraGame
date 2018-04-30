
local localCacheServerCtrl = class("localCacheServerCtrl", HotRequire(luaFile.CtrlBase))

function localCacheServerCtrl:ctor( ... )
    self.super.ctor(self, ... )

    self:init()
end

function localCacheServerCtrl:init()
	self.cacheData = CacheUtil:getCacheVal(CacheType.localCacheServer)
end

function localCacheServerCtrl:addCache(key, valueMap)
	if not networkControl:isLogin() then
		self.cacheData[#self.cacheData+1] = {key, valueMap}
		CacheUtil:setCacheVal(CacheType.localCacheServer, self.cacheData)
	end
end

function localCacheServerCtrl:syncCacheServer()
	for k,v in pairs(self.cacheData) do
		if v[1] == "signLine" then
			self:pushSignLine(v[2].signLine, v[2].time)
			
		elseif v[1] == "censerNum" then
			self:pushIncenseData(v[2].time)
			
		elseif v[1] == "songScore" then
			self:pushSongScoreData(v[2].songData, v[2].time)
		end
	end
	
	self.cacheData = {}
	CacheUtil:setCacheVal(CacheType.localCacheServer, self.cacheData)
end

function localCacheServerCtrl:pushSignLine(signLine, time)
	networkControl:sendMessage("updateUserData", {type="signLine", data=signLine, ostime=time, isSync=true})
end

function localCacheServerCtrl:pushIncenseData(time)
	networkControl:sendMessage("updateUserData", {type="censerNum", data="", ostime=time, isSync=true})
end

function localCacheServerCtrl:pushSongScoreData(songData, time)
	networkControl:sendMessage("updateUserData", {type="songScore", data=songData, ostime=time, isSync=true})
end

return localCacheServerCtrl
