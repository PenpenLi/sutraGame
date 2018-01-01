
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
end


function musicPlayerCtrl:recyclexx(xx)
	self.xxSprites[#self.xxSprites+1] = xx
	if xx.moveLineAction then
		xx:stopAction(xx.moveLineAction)
		xx.moveLineAction = nil
	end
	xx:setVisible(false)
end
function musicPlayerCtrl:createxx()
	local xx = cocosMake.newSprite("res/homeUI/xingguang.png")
	xx:runAction(cc.RepeatForever:create(cc.RotateBy:create(1.0, 360)))
	return xx
end

function musicPlayerCtrl:getxx()
	if #self.xxSprites > 0 then
		local spr = self.xxSprites[#self.xxSprites]
		self.xxSprites[#self.xxSprites] = nil
		return spr
		
	else
		local xx = self:createxx()
		self.containWidget:addChild(xx)
		return xx
	end
end


function musicPlayerCtrl:setParam(startPos, endPos, speed, containWidget)
	self.startPos = startPos
	self.endPos = endPos
	self.moveSpeed = speed
	self.containWidget = containWidget
	
	self.moveTime = (self.startPos.x - self.endPos.x)/self.moveSpeed
	self.moveMiddleTime = self.moveTime/2
end

function musicPlayerCtrl:playMusic(musicRes, musicTime, musicClickData, fohaoNum)
	local action_list = {}
	self.songPlayDelayTime = self.moveMiddleTime - 1/50
	action_list[#action_list + 1] = cc.DelayTime:create(self.songPlayDelayTime)
	action_list[#action_list + 1] = cc.CallFunc:create(function ()
			--audioCtrl:playMusic("res/audio/song/" .. musicRes .. ".mp3", true)
			ccexp.AudioEngine:play2d("res/audio/song/" .. musicRes .. ".mp3", true)
		end)
	self.containWidget:runAction(cc.Sequence:create(unpack(action_list)))
	
	self.clickScore = {}
	self.clickScoreIndex = 1
	for i=1, fohaoNum do self.clickScore[i] = 0 end
	self.clickLegalSprs = {}
	self.musicClickData = musicClickData
	self.musicTime = musicTime
	self.musicClickDataCount = #self.musicClickData
	self.fohaoNum = fohaoNum
	self.playing = true
	
	self.curStep = 1
	self:run(musicClickData, 1)


	
end

function musicPlayerCtrl:update(clock)
	if self.musicClickDataCount < self.curStep then
		if clock >= self.musicTime then
			self.curStep = 1
			self.beginClock = os.clock()
		end
		return
	end
	if clock >= self.musicClickData[self.curStep] then
		log(clock, self.musicClickData[self.curStep], self.curStep, os.clock())
		
		local curStep = self.curStep
		local xx = self:getxx()
		xx:setVisible(true)
		xx:setPosition(self.startPos)
		
		local action_list = {}
		action_list[#action_list + 1] = cc.MoveTo:create(self.moveTime, self.endPos)
		action_list[#action_list + 1] = cc.CallFunc:create(function () self:recyclexx(xx) end)
		local moveLineAction = xx:runAction(cc.Sequence:create(unpack(action_list)))
		xx.moveLineAction = moveLineAction
		
		--移动到中心位置，左右0.2秒
		local action_clickLegal = {}
		action_clickLegal[#action_clickLegal + 1] = cc.DelayTime:create(math.max(0, self.moveMiddleTime-0.2))
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
		end)
		local clickLegalAction = xx:runAction(cc.Sequence:create(unpack(action_clickLegal)))
		xx.clickLegalAction = clickLegalAction
		
		self.curStep=self.curStep+1
		for i=self.curStep, self.musicClickDataCount do
			if clock <= self.musicClickData[i] then
				self.curStep = i
				break
			end
		end
	end
end
--开始播放经文
function musicPlayerCtrl:run(musicClickData, startIndex)
	self.beginClock = os.clock()
	schedule(self.containWidget, function ()
		self:update(os.clock() - self.beginClock)
	end, 0.0)
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
		return idx
	end
	return 0
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
		end
		self.clickScoreIndex = 1
		logc("playMusicOver_calcFoju, fohaoScore:", self.fojuScore)
	end
	
end

return musicPlayerCtrl
