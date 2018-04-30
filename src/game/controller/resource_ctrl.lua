
resourceCtrl = class("resourceCtrl", HotRequire(luaFile.CtrlBase))

local m_audioCachePath = "sutraGameAudioCache"

function resourceCtrl:ctor( ... )
	self.super.ctor(self, ... )
	this = self
	self:init()
end


function resourceCtrl:init()
	--cocosMake.textureCache:pngEncode(true)
	m_audioCachePath = cc.FileUtils:getInstance():getWritablePath() .. m_audioCachePath
	
end

function resourceCtrl:decodeAudio()
	--[[if not cc.FileUtils:getInstance():isDirectoryExist(m_audioCachePath) then
		cc.FileUtils:getInstance():createDirectory(m_audioCachePath)
		cc.FileUtils:getInstance():createDirectory(m_audioCachePath .. "/audio")
		cc.FileUtils:getInstance():createDirectory(m_audioCachePath .. "/audio/song")
		
		local img = cc.Image:new()
		local mp3list = require("src/mp3list.lua")
		for k,v in pairs(mp3list) do
			local cacheFile = m_audioCachePath .. "/" .. v
			log(cacheFile)
			img:pngDecode(v, cacheFile, true)
		end
		cc.FileUtils:getInstance():purgeCachedEntries()
	end

	cc.FileUtils:getInstance():addSearchPath(m_audioCachePath, true)	--]]
end

