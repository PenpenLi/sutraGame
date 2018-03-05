
local musicPlayerCtrl = class("musicPlayerCtrl", HotRequire(luaFile.CtrlBase))
local this = musicPlayerCtrl
function musicPlayerCtrl:ctor( ... )
	self.super.ctor(self, ... )
	self:Init()
end

function musicPlayerCtrl:Init( ... )
	self.super.Init(self)
	self.xxSprites = {}
	self.clickScore = {}
	self.clickLegalSprs = {}
	self.fojuScore = 0
	self.clickValidCallback = nil
	self.songSuccessIndex = false
	self.validOffsetTime = -0.10--敲击有效时间偏移
end

function musicPlayerCtrl:recyclexx(xx)
	self.xxSprites[#self.xxSprites+1] = xx
	if xx.moveLineAction then
		xx:stopAction(xx.moveLineAction)
		xx.moveLineAction = nil
	end
	xx:setTexture("res/homeUI/xingguang.png")
	xx:setVisible(false)
end

function musicPlayerCtrl:createxx()
	local xx = cocosMake.newSprite("res/homeUI/xingguang.png")
	xx:runAction(cc.RepeatForever:create(cc.RotateBy:create(1.0, 360)))
	return xx
end

function musicPlayerCtrl:getxx()
	if #self.xxSprites == 0 then
		local xx = self:createxx()
		self.containWidget:addChild(xx)
		self.xxSprites[#self.xxSprites+1] = xx
	end
	local spr = self.xxSprites[#self.xxSprites]
	self.xxSprites[#self.xxSprites] = nil
	return spr
end
function musicPlayerCtrl:clearxx()
	for k,v in pairs(self.xxSprites) do
		v:removeFromParent()
	end
	self.xxSprites = {}
end


function musicPlayerCtrl:setParam(startPos, endPos, speed, containWidget)
	self.startPos = startPos
	self.endPos = endPos
	self.moveSpeed = speed
	self.containWidget = containWidget
	
	self.moveTime = (self.startPos.x - self.endPos.x)/self.moveSpeed
	self.moveMiddleTime = self.moveTime/2.0
	--log("self.moveMiddleTime:", self.moveTime, self.moveMiddleTime)
	
end

function musicPlayerCtrl:playMusic(musicId, musicRes, musicTime, musicClickData, fohaoNum)
	self.musicId = musicId
	self.musicRes = musicRes
	self.clickScore = {}
	self.clickScoreIndex = 1
	for i=1, fohaoNum do self.clickScore[i] = 0 end
	self.clickLegalSprs = {}
	self.musicRhythm = DeepCopy(musicClickData)
    self.musicRunRhythm = DeepCopy(musicClickData)
	self.musicRhythmCount = #musicClickData
	self.musicTime = musicTime
	self.fohaoNum = fohaoNum
	self.playing = true
	self.errTime = 0
	self.curStep = -20--帧缓冲
	self:run()

	
	self.songSuccessIndex = false
	
    ccexp.AudioEngine:preload("res/audio/song/" .. self.musicRes .. ".mp3")
end

function musicPlayerCtrl:update(ft)
	self.clock=self.clock+ft
	--log("update", ft, self.clock, self.curStep, self.musicRunRhythm[self.curStep], os.clock())

	if ft <= 0.0 then
		return
	end

    if self.state == "resume" then
		if self.musicHandle then
			log("musicPlayerCtrl:update.state.resume", self.musicHandle, self.musicPauseTime)
			ccexp.AudioEngine:resume(self.musicHandle)
			if self.musicPauseTime>=self.songPlayDelayTime then
				ccexp.AudioEngine:setCurrentTime(self.musicHandle, self.musicPauseTime-self.songPlayDelayTime)
			end
		end
        self.state = ""
    end


	if self.musicRhythmCount < self.curStep then
		if self.clock >= self.musicTime + self.errTime then
			self.curStep = -2--歌曲连续播放的时候，用来对齐时间轴用的缓冲帧数
			self.clock = 0.0
            self.musicRunRhythm = DeepCopy(self.musicRhythm)
		end
		return
	end
	
	if not self.musicRunRhythm[self.curStep] then
		self.curStep = self.curStep + 1
		self.clock = 0.0
        log("musicPlayerCtrl not self.curStep", self.curStep)

		if self.musicRunRhythm[self.curStep] then
			local action_list = {}
			self.errTime = ft
			self.songPlayDelayTime = self.moveMiddleTime - self.errTime
            log("musicPlayerCtrl self.songPlayDelayTime", self.songPlayDelayTime)
			action_list[#action_list + 1] = cc.DelayTime:create(self.songPlayDelayTime)
			action_list[#action_list + 1] = cc.CallFunc:create(function ()
                    local musicres = "res/audio/song/" .. self.musicRes .. ".mp3"
					log("musicPlayerCtrl play music", musicres)
                    self.musicHandle = ccexp.AudioEngine:play2d(musicres, false)
                    ccexp.AudioEngine:setVolume(self.musicHandle, 100)
				end)
			 self.containWidget:runAction(cc.Sequence:create(unpack(action_list)))
		end
		return 
	end

	if self.clock >= self.musicRunRhythm[self.curStep] then
        local curStep = self.curStep
		local xx = self:getxx()
		xx:setVisible(true)
		xx:setPosition(self.startPos)

        local offt = 1*(self.clock - self.musicRunRhythm[self.curStep])
		local action_list = {}
		action_list[#action_list + 1] = cc.MoveTo:create(self.moveTime - offt, self.endPos)
		action_list[#action_list + 1] = cc.CallFunc:create(function () self:recyclexx(xx) end)
		local moveLineAction = xx:runAction(cc.Sequence:create(unpack(action_list)))
		xx.moveLineAction = moveLineAction
		
		--移动到中心位置，左右0.2秒
		local action_clickLegal = {}
		action_clickLegal[#action_clickLegal + 1] = cc.DelayTime:create(math.max(0, self.moveMiddleTime - 0.2 + self.validOffsetTime - offt/2))
		action_clickLegal[#action_clickLegal + 1] = cc.CallFunc:create(function ()
			self.clickLegalSprs[#self.clickLegalSprs+1] = {xx=xx, index=curStep}
		end)
		action_clickLegal[#action_clickLegal + 1] = cc.DelayTime:create(0.2*2)
		action_clickLegal[#action_clickLegal + 1] = cc.CallFunc:create(function ()
			for lk,lv in pairs(self.clickLegalSprs) do
				if lv.xx == xx then
					table.remove(self.clickLegalSprs, lk)
					break
				end
			end
			self:setClickScore(-1)
			xx:setTexture("res/homeUI/xingguang2.png")
		end)
		local clickLegalAction = xx:runAction(cc.Sequence:create(unpack(action_clickLegal)))
		xx.clickLegalAction = clickLegalAction
		
		--查找离此次最近的佛句时间点
		self.curStep=self.curStep+1
		for i=self.curStep, self.musicRhythmCount do
			if self.clock <= self.musicRunRhythm[i] then
				self.curStep = i
				break
			end
		end
	end
end
--开始播放经文
function musicPlayerCtrl:run()
	--[[self.beginClock = os.clock()
	schedule(self.containWidget, function ()
		self:update(os.clock() - self.beginClock)
	end, 0.0)
	--]]
	self.clock = 0.0
	self.containWidget:onUpdate(handler(self, self.update))
end

function musicPlayerCtrl:clickEvent()
	if #self.clickLegalSprs > 0 then
		local xx = self.clickLegalSprs[1].xx
		xx:stopAction(xx.clickLegalAction)
		xx.clickLegalAction = nil
		xx:stopAction(xx.moveLineAction)
		xx.moveLineAction = nil
		
		local action_list = {}
		action_list[#action_list + 1] = cc.MoveBy:create(0.2, cc.p(0, 100))
		action_list[#action_list + 1] = cc.CallFunc:create(function () 
			self:recyclexx(xx)
		end)
		xx:runAction(cc.Sequence:create(unpack(action_list)))
		
		local idx = self.clickLegalSprs[1].index
		table.remove(self.clickLegalSprs, 1)
		
		self:setClickScore(1)
		if self.clickValidCallback then
			self.clickValidCallback()
		end
		return idx
	end
	return 0
end


function musicPlayerCtrl:setClickValidCallback(callback)
	self.clickValidCallback = callback
end

function musicPlayerCtrl:setClickScore(val)
	
	self.clickScore[self.clickScoreIndex] = val
	self.clickScoreIndex = self.clickScoreIndex + 1
	if self.clickScoreIndex > self.fohaoNum then
		local failed = false
		for i=1, #self.clickScore do
			if self.clickScore[i] ~= 1 then
				failed = true
				break
			end
		end
		if not failed then
			self.fojuScore = self.fojuScore + 1
		end
		if self.fojuScore == 100 then
			GameController:dispatchEvent({name = GlobalEvent.CLICK_WOODENFINISH_SUCCESS, data={}})
			self.songSuccessIndex = true
		end
		self.clickScoreIndex = 1
		logc("playMusicOver_calcFoju, fohaoScore:", self.fojuScore)
	end
	
end

function musicPlayerCtrl:pause()
    log("musicPlayerCtrl:pause", self.clock)
	if self.playing then
		cocosMake.setGameSpeed(0)
		if self.musicHandle then
			ccexp.AudioEngine:pause(self.musicHandle)
			self.musicPauseTime = self.clock
		end
	end
end

function musicPlayerCtrl:resume()
    log("musicPlayerCtrl:resume", self.clock)
	if self.playing then
		cocosMake.setGameSpeed(1)
        self.state = "resume"
	end
end


function musicPlayerCtrl:stop()
	if self.playing then
		self.containWidget:unscheduleUpdate()
		cocosMake.setGameSpeed(1)
        ccexp.AudioEngine:stop(self.musicHandle or 0)
		self.playing = false
		self.musicHandle = nil
	end
end

function musicPlayerCtrl:clear()
	self.songSuccessIndex = false
	self:clearxx()
	self.clickValidCallback = nil
	self.fojuScore = 0
	self.containWidget:removeAllChildren()
	
	
	self.musicId = 0
	self.musicRes = ""
	self.clickScore = {}
	self.clickScoreIndex = 1
	self.clickLegalSprs = {}
	self.musicTime = 0
	self.fohaoNum = 0
end

function musicPlayerCtrl:isPlaying()
	return self.playing
end

function musicPlayerCtrl:isSuccessed()
	return self.songSuccessIndex
end

function musicPlayerCtrl:getFojuScore()
	return self.fojuScore
end

function musicPlayerCtrl:getMusicId()
	return self.musicId
end


return musicPlayerCtrl
