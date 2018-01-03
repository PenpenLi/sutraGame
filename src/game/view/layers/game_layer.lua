
local GameLayer = class("GameLayer", cocosMake.viewBase)

--cocos studio生成的csb
GameLayer.ui_resource_file = {"GameLayerNode"}

GameLayer.ui_binding_file = {
	qiandao_btn    = {event = "click", method = "qiandao_btnClick"},
	songjing_btn    = {event = "click", method = "songjing_btnClick"},
	jingwen_btn    = {event = "click", method = "jingwen_btnClick"},
	exitGameBtn    = {event = "click", method = "exitGameBtnClick"},
	continueBtn    = {event = "click", method = "continueBtnClick"},
	pauseBtn    = {event = "click", method = "pauseBtnClick"},
}

function GameLayer:onCreate(param)
	
	self:initUI()
	
	self:return_key()
	
	
	audioCtrl:setMusicVolume(100)
	audioCtrl:setVolumn(70)
	
	audioCtrl:playMusic(audioData.background, true)
	
	self.musicPlayerCtrl = new_class(luaFile.musicPlayerCtrl)
end

function GameLayer:initUI()
	self.censerPanel:setVisible(true)
	self.censer_on:setVisible(not UserData.todayCanIncense)
	self.censer_off:setVisible(UserData.todayCanIncense)
	if not UserData.todayCanIncense then self:showCenserFire() end
	
	--点击上香
	self.censerPanel:setTouchEnabled(true)
	self.censerPanel:onClicked(function()
		if UserData.todayCanIncense and not UserData.todayCanSign then
			self.censer_on:setVisible(true)
			self.censer_off:setVisible(false)
			self:showCenserFire()
			audioCtrl:playSound(audioData.censer, false)
			UserData:incenseToday(  )
			
		elseif UserData.todayCanSign then
			TipViewEx:showTip(TipViewEx.tipType.signTip)
			audioCtrl:playSound(audioData.error, false)
		end
	end)
	
	self:setBuddhasImage(UserData:getBuddhas())
	
	--if UserData.buddhasLightLevel == 0 then self.f_g:setVisible(false) end
	
	
	--阳光效果
	local action_list1 = {}
	action_list1[#action_list1 + 1] = cc.FadeOut:create(2.0)
	action_list1[#action_list1 + 1] = cc.FadeIn:create(2.0)
	local action1 = cc.RepeatForever:create(cc.Sequence:create(unpack(action_list1)))
	self.lightEff1:runAction(action1)
	
	local action_list2 = {}
	action_list2[#action_list2 + 1] = cc.FadeIn:create(2.0)
	action_list2[#action_list2 + 1] = cc.FadeOut:create(2.0)
	local action2 = cc.RepeatForever:create(cc.Sequence:create(unpack(action_list2)))
	self.lightEff2:runAction(action2)
	
	
	--动态佛光
	if UserData.buddhasLightLevel >= 3 then
		local scnt = 10
		local sp = 0.1
		for j=1,scnt do
			local frameName =string.format("res/Buddhas/buddhasLightEff/%04d.png",j)
			local s = cocosMake.newSprite(frameName, 0, 0)
			s:setVisible(false)
			s:setScale(1.5)
			
			local sequence = transition.sequence({
				cc.DelayTime:create((j-1)*sp),
				cc.Show:create(),
				cc.DelayTime:create(sp),
				cc.Hide:create(),
				cc.DelayTime:create(math.max(0,(scnt-j))*sp),
			})
			s:runAction(cc.RepeatForever:create(sequence))
			self.buddhasLight:addChild(s)
		end
	end	
	
	--self:updateChenghao()
	
	self:showStartSpeak()
		
	self.touchMaskPanel:setSwallowTouches(false)
	self.touchMaskPanel:onClicked(function()end)
	self.touchMaskPanel:setVisible(true)
	
	self.continueBtn:setVisible(false)
	self.pauseBtn:setVisible(false)
end

function GameLayer:showStartSpeak()
	self.startSpeak:setVisible(true)
	self.startSpeak:onClicked(function()
		self.startSpeak:removeFromParent()
	end)
end

function GameLayer:setBuddhasImage(res)
	self.buddhas:loadTexture(string.format("Buddhas/buddhas/%s.png",  res))
	self.buddhas:setContentSize(self.buddhas:getVirtualRendererSize())
end


function GameLayer:playClickCountNumberEff()
	local animateNode = new_class(luaFile.AnimationSprite, {
		startFrameIndex = 1,                             -- 开始帧索引
		isReversed = false,                              -- 是否反转
		plistFileName = "signBoard/clickNumberEffect.plist", -- plist文件
		pngFileName = "signBoard/clickNumberEffect.png",     -- png文件
		pattern = "clickNumberEffect/",                      -- 帧名称模式串
		frameNum = 8,                                   -- 帧数
		rate = 0.05,                                     -- 
		stay = true,                                    -- 是否停留（是否从cache中移除纹理）
		indexFormat = 4,                                 -- 整数位数
	})
	self.clickCountEffNode:addChild(animateNode)
	animateNode:playOnce(true, 0)	
end


function GameLayer:updateChenghao( ... )
	--更新称号
	local chenghaoLv = 0
	local songCnt = UserData.songCount
	if songCnt >= 7 and songCnt < 15 then chenghaoLv = 1 end
	if songCnt >= 15 and songCnt < 30 then chenghaoLv = 2 end
	if songCnt >= 30 and songCnt < 60 then chenghaoLv = 3 end
	if songCnt >= 60 and songCnt < 120 then chenghaoLv = 4 end
	if songCnt >= 120 and songCnt < 180 then chenghaoLv = 5 end
	if songCnt >= 180 and songCnt < 360 then chenghaoLv = 6 end
	if songCnt >= 360 and songCnt < 720 then chenghaoLv = 7 end
	if songCnt >= 720 and songCnt < 1080 then chenghaoLv = 8 end
	if songCnt >= 1080 and songCnt < 1440 then chenghaoLv = 9 end
	if songCnt >= 1440 then chenghaoLv = 10 end
	if chenghaoLv > 0 then
		if self.chenghaoNode.chSpr then
			self.chenghaoNode.chSpr:removeAllChildren()
		end
		local chSpr = cocosMake.newSprite(string.format("homeUI/chenghao/rw_%02d.png", chenghaoLv))
		self.chenghaoNode:addChild(chSpr)
		self.chenghaoNode.chSpr = chSpr
	end
	UserData.chenghaoLv = chenghaoLv
	if self.lastChenghaoLv and self.lastChenghaoLv < chenghaoLv then
		TipViewEx:showTip(TipViewEx.tipType.getChenghao)
	end
	self.lastChenghaoLv = chenghaoLv
end


function GameLayer:onClose( ... )
end



function GameLayer:exitGameBtnClick(event)
	--[[
	local spr = cocosMake.newSprite("Buddhas/f_01test.png", 0, 0 , {anchor=cc.p(0,0)})
	spr:getTexture():setTexParameters(GL_LINEAR, GL_LINEAR, GL_REPEAT, GL_REPEAT)
	self:addChild(spr)
	
	local program = cc.GLProgram:create("Shaders/shadow.vsh", "Shaders/shadow.fsh")
	program:link()
	program:use()
	program:updateUniforms()
	
	
	local state = cc.GLProgramState:create(program)
	spr:setGLProgramState(state)
	
	local hval = 0.00
	schedule(spr, function()
		state:setUniformFloat("HValue", hval)
		hval = hval + 0.005
		if hval > 1.0 then hval = 0.0 end
	end, 0.03)	
	]]--
	audioCtrl:playSound(audioData.buttonClick, false)
	
	LayerManager.showFloat(luaFile.exitGameBoardView, {modal=true})
end

function GameLayer:continueBtnClick()
	cocosMake.setGameSpeed(1)
	audioCtrl:resumeMusic()
	
	self.continueBtn:setVisible(false)
	self.pauseBtn:setVisible(true)
	
	self.touchMaskPanel:setSwallowTouches(false)
	self.touchMaskPanel:setVisible(false)
	
	AdManager:hideAd()
end
function GameLayer:pauseBtnClick()
	cocosMake.setGameSpeed(0)
	audioCtrl:pauseMusic()
	
	self.continueBtn:setVisible(true)
	self.pauseBtn:setVisible(false)
	
	self.touchMaskPanel:setSwallowTouches(true)
	self.touchMaskPanel:setVisible(true)
	
	AdManager:showAd()
end

function GameLayer:showCenserFire()
	if not self.censerFireAnim then
		self.censerPanel:setTouchEnabled(false)
		
		local rotatelist = {0, 0, 0}
		local spriteFrame  = cc.SpriteFrameCache:getInstance() 
		local anim = {}
		spriteFrame:addSpriteFrames("censer/censer_firework.plist")
		for i=1, 3 do
			local animation =cc.Animation:create()
			local scnt = 12
			local sp = 0.1
            for j=1,scnt do
                local frameName =string.format("censer/censer_firework/%04d.png",j)
                local s = cocosMake.newSprite(frameName, 0, 0)
				s:setRotation(rotatelist[i])
				s:setVisible(false)
				s:setScale(0.5)
				
				local sequence = transition.sequence({
					cc.DelayTime:create((j-1)*sp),
                    cc.Show:create(),
					cc.DelayTime:create(sp),
					cc.Hide:create(),
					cc.DelayTime:create(math.max(0,(scnt-j))*sp),
                })
				s:runAction(cc.RepeatForever:create(sequence))
		
				self["censer_fire"..i]:addChild(s)
            end  
   
			anim[i] = self["censer_fire"..i]
		end
	end
	
end

function GameLayer:qiandao_btnClick(event)
	audioCtrl:playSound(audioData.buttonClick, false)
	
	local function signCallback()
	
	end
	LayerManager.showFloat(luaFile.signBoardView, {modal=true, signCallback=signCallback})
end

function GameLayer:createWoodenFishAnim()
	
	local def = "0"
	if UserData.usedTool == "1" or UserData.usedTool == "2" then
		def = UserData.usedTool
	end
	def = UserData.usedTool--改成只有一种木鱼
	
	local animateNode = new_class(luaFile.AnimationSprite, {
		startFrameIndex = 1,                             -- 开始帧索引
		isReversed = false,                              -- 是否反转
		plistFileName = "woodenFish/"..def.."/woodenFish.plist", -- plist文件
		pngFileName = "woodenFish/"..def.."/woodenFish.png",     -- png文件
		pattern = "woodenFish/",                      -- 帧名称模式串
		frameNum = 4,                                   -- 帧数
		rate = 0.05,                                     -- 
		stay = true,                                    -- 是否停留（是否从cache中移除纹理）
		indexFormat = 4,                                 -- 整数位数
	})
	return animateNode
end


function GameLayer:startClickWoodenFish()
	self.woodenFishClickCount:setVisible(true)
	self.woodenFishClickCount:setString("0")
	self.woodenFishClickCount.cnt = 0

	
	local def = "0"
	if UserData.usedTool == "1" or UserData.usedTool == "2" then
		def = UserData.usedTool
	end
	def = UserData.usedTool--改成只有一种木鱼
	local btn_normal = cocosMake.newSprite("woodenFish/"..def.."/".."m_01.png")
	local btn_touch = cocosMake.newSprite("woodenFish/"..def.."/".."m_02.png")
	btn_normal:setVisible(true)
	btn_touch:setVisible(false)
	
	self.woodenFishPanel:onTouch(function(event)
		if event.name == "began" then
			btn_normal:setVisible(false)
			btn_touch:setVisible(true)
			local soundfile = audioData.woodenFish
			--if songData[UserData.selectSongs].B then soundfile = audioData.woodenFishB end
			audioCtrl:playSound(soundfile, false)
			
			self.woodenFishClickCount.cnt = self.woodenFishClickCount.cnt + 1
			self.woodenFishClickCount:setString(self.woodenFishClickCount.cnt)
			self.woodenFishClickCount:setScale(0)
			self.woodenFishClickCount:runAction(cc.EaseExponentialOut:create(cc.ScaleTo:create(0.3, 1)))
			self.musicPlayerCtrl:clickEvent()
			self:playClickCountNumberEff()
			
		elseif event.name == "ended" then
			btn_normal:setVisible(true)
			btn_touch:setVisible(false)
		end
	end)
	self.woodenFishPanel:setTouchEnabled(true)
	
	
	self.woodenFishPanel:addChild(btn_normal)
	self.woodenFishPanel:addChild(btn_touch)
	local fsize = self.woodenFishPanel:getContentSize()
	btn_normal:setPosition(cc.p(fsize.width/2.0+30, 230))
	btn_touch:setPosition(cc.p(fsize.width/2.0+30, 230))
	self.bottomMenuPanel:setVisible(false)
	
	
	audioCtrl:stopMusic()
	
	--播放经文
	--startPos, endPos, speed, containWidget
	self.musicPlayerCtrl:setParam(cc.p(720, 250), cc.p(0, 250), 150, self)
	local musicData = UserData:getSelectSongInfo()
	self.musicPlayerCtrl:playMusic(musicData.songId, musicData.songTime, 
		musicData.rhythm, musicData.foju)
		
	--更换佛祖图像
	UserData:setBuddhas(musicData.buddhaId)
	self:setBuddhasImage(UserData:getBuddhas())
	
		
	--[[audioCtrl:playMusic(songData[UserData.selectSongs].file, false)
	if songData[UserData.selectSongs].count > 1 then
		local songCount = 1
		local sch = schedule(self, function()
			audioCtrl:playMusic(songData[UserData.selectSongs].file, false)
			songCount = songCount + 1
			if songCount >= songData[UserData.selectSongs].count then
				self:stopAction(sch)
			end
		end, songData[UserData.selectSongs].time)
	end
	
	
	local function songFinishCallback()
		self.woodenFishPanel:removeAllChildren()
		self.woodenFishPanel:setTouchEnabled(false)
		self.woodenFishPanel:setVisible(false)		
		self.woodenFishClickCount:setVisible(false)
		
		local res = 0
		local clickCnt = tonumber(self.woodenFishClickCount:getString())
		if clickCnt > songData[UserData.selectSongs].touchMax then res = 1 end
		if clickCnt < songData[UserData.selectSongs].touchMin then res = -1 end
		if res == 0 then 
			UserData:songToday() self:huiwenAnim(8, function() 
				self.bottomMenuPanel:setVisible(true)
				LayerManager.showFloat(luaFile.sutraOverBoardView, {modal=true,result=res})
			end)
		else
			self.bottomMenuPanel:setVisible(true)
			LayerManager.showFloat(luaFile.sutraOverBoardView, {modal=true,result=res})
		end
		audioCtrl:playMusic(audioData.background, true)
		
		self.continueBtn:setVisible(false)
		self.pauseBtn:setVisible(false)
	end
	performWithDelay(self, songFinishCallback, songData[UserData.selectSongs].time * songData[UserData.selectSongs].count)--]]
end



function GameLayer:jingwen_btnClick(event)
	audioCtrl:playSound(audioData.buttonClick, false)
	LayerManager.showFloat(luaFile.sutraBoardView, {modal=true})
end

function GameLayer:jingwenAnim(overTime)
	local txtNum = 8
	local moveX = 10
	local degeX = 720/(txtNum+1)
	local movetime = 1.3
	local moveDelayInFront = 0
	if txtNum*movetime <= overTime then
		moveDelayInFront = overTime - (txtNum*movetime)
		moveDelayInFront = moveDelayInFront/txtNum
	else
		movetime = overTime/txtNum
	end
	for i=1, txtNum do
		local sprpath = string.format("res/sanboyiwen/%02d.png", i)
		local txt = cocosMake.newSprite(sprpath)
		txt:setPosition(degeX*i, 800)
		txt:setOpacity(0)
		self:addChild(txt)
		
		local function callBackFunc()
			local actionMove = cc.MoveBy:create(movetime, cc.p(moveX, 0))
			local actionFade = cc.FadeOut:create(movetime)
			local actionSpawn = cc.Spawn:create(actionMove, actionFade)
			txt:runAction(cc.Sequence:create(actionSpawn, cc.RemoveSelf:create()))
		end
		
		local actionMove = cc.MoveBy:create(movetime, cc.p(moveX, 0))
		local actionFade = cc.FadeIn:create(movetime)
		local actionSpawn = cc.Spawn:create(actionMove, actionFade)
		local delay1 = cc.DelayTime:create((i-1)*movetime + (i-1)*moveDelayInFront)
		txt:runAction(cc.Sequence:create(delay1, actionSpawn))
		
		local delay2 = cc.DelayTime:create(overTime)
		txt:runAction(cc.Sequence:create(delay2, cc.CallFunc:create(callBackFunc)))
	end
end

function GameLayer:clickWoodenFinishSuccessEvent()
	self.clickSuccessIcon:setVisible(true)
end

function GameLayer:huiwenAnim(overTime, animCallback)
	local mtime = 1.3
	for i=1, 4 do
		local sprpath = string.format("res/songOver/%02d.png", i)
		local txt = cocosMake.newSprite(sprpath)
		txt:setPosition(522-(i*(68)), 697)
		txt:setOpacity(0)
		txt:setGlobalZOrder(1)
		self:addChild(txt)
				
		local function callBackFunc()
			local actionMove = cc.MoveBy:create(mtime, cc.p(10, 0))
			local actionFade = cc.FadeOut:create(mtime)
			local actionSpawn = cc.Spawn:create(actionMove, actionFade)
			txt:runAction(cc.Sequence:create(actionSpawn, cc.RemoveSelf:create()))
		end
		
		local actionMove = cc.MoveBy:create(mtime, cc.p(10, 0))
		local actionFade = cc.FadeIn:create(mtime)
		local actionSpawn = cc.Spawn:create(actionMove, actionFade)
		local delay1 = cc.DelayTime:create((i-1)*mtime*1.6)
		txt:runAction(cc.Sequence:create(delay1, actionSpawn))
		
		local delay2 = cc.DelayTime:create(overTime)
		txt:runAction(cc.Sequence:create(delay2, cc.CallFunc:create(callBackFunc)))
	end
	self:runAction(cc.Sequence:create(cc.DelayTime:create(overTime + mtime), cc.CallFunc:create(animCallback)))
end

function GameLayer:songjing_btnClick(event)
	if UserData.selectSongs > 0 and UserData.selectSongs <= UserData.localSongCount then
		self.bottomMenuPanel:setVisible(false)
		
		self.woodenFishPanel:removeAllChildren()
		self.woodenFishPanel:setVisible(true)
		self.woodenFishPanel:setTouchEnabled(true)
		
		performWithDelay(self, function()
					self:startClickWoodenFish()
					self:startClickWoodenFishEffect()
					self.continueBtn:setVisible(false)
					self.pauseBtn:setVisible(true)
				end, 0)--28
		audioCtrl:playMusic(audioData.startSong, true)
		
		--self:jingwenAnim(28)
		
	else
		audioCtrl:playSound(audioData.error, false)
		TipViewEx:showTip(TipViewEx.tipType.songTip)
	end
end

function GameLayer:startClickWoodenFishEffect()
	self.clickWoodenFishEffect = performWithDelay(self, function()
		local musicData = UserData:loadMusicRhythmData()
		local eff = musicData[UserData.selectSongs].clickEffect
		
		if eff == "hb" then
			local animateNode = new_class(luaFile.AnimationSprite, {
				startFrameIndex = 1,                             -- 开始帧索引
				isReversed = false,                              -- 是否反转
				plistFileName = "res/woodenFish/hb.plist", -- plist文件
				pngFileName = "res/woodenFish/hb.png",     -- png文件
				pattern = "hb/",                      -- 帧名称模式串
				frameNum = 11,                                   -- 帧数
				rate = 0.10,                                     -- 
				stay = true,                                    -- 是否停留（是否从cache中移除纹理）
				indexFormat = 4,                                 -- 整数位数
			})
			self:addChild(animateNode)
			animateNode:playOnce(true, 0)
			animateNode:setPosition(math.random(100, 620), math.random(980, 1180))			
			animateNode:runAction(cc.MoveBy:create(math.random(1.5, 2), cc.p(math.random(0, 200)-100, -math.random(200, 380))))
			
		elseif eff == "ym" then
			local ymSpr = cocosMake.newSprite("res/woodenFish/ym.png")
			self:addChild(ymSpr)
			ymSpr:setPosition(math.random(100, 620), math.random(980, 1180))	
				
			local moveTime = math.random(2.5, 4)
			ymSpr:runAction(cc.MoveBy:create(moveTime, cc.p(math.random(0, 200)-100, -math.random(200, 380))))
			
			local action_list2 = {}
			action_list2[#action_list2 + 1] = cc.FadeIn:create(0.3)
			action_list2[#action_list2 + 1] = cc.DelayTime:create(moveTime-0.5-0.3)
			action_list2[#action_list2 + 1] = cc.FadeOut:create(0.5)
			action_list2[#action_list2 + 1] = cc.CallFunc:create(function () ymSpr:removeFromParent() end)
			ymSpr:setOpacity(0)
			ymSpr:runAction(cc.Sequence:create(unpack(action_list2)))
		end
		
		self:startClickWoodenFishEffect()
	end, math.random(200, 1000)/100)
end

function GameLayer:stopClickWoodenFishEffect()
	if self.clickWoodenFishEffect then
		self:removeAction(self.clickWoodenFishEffect)
		self.clickWoodenFishEffect = nil
	end
end

function GameLayer:return_key()
	self.floatView = nil
    --回调方法
    local function onrelease(code, event)
        if code == cc.KeyCode.KEY_BACK then
            if self.floatView then 
				LayerManager.closeFloat(self.floatView) 
				self.floatView = nil
			else
				LayerManager.showFloat(luaFile.exitGameBoardView, {modal=true})
			end
        elseif code == cc.KeyCode.KEY_HOME then
        end
    end
    --监听手机返回键
    local listener = cc.EventListenerKeyboard:create()
    listener:registerScriptHandler(onrelease, cc.Handler.EVENT_KEYBOARD_RELEASED)
    --lua中得回调，分清谁绑定，监听谁，事件类型是什么
    local eventDispatcher =self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener,self)
	
	
	GameController:addEventListener(GlobalEvent.SIGN_VIEW_SHOW,function(event)
		self.floatView = event.data and event.data.view or nil
    end)
	GameController:addEventListener(GlobalEvent.SUTRA_VIEW_SHOW,function(event)
		self.floatView = event.data and event.data.view or nil
    end)
	GameController:addEventListener(GlobalEvent.SUTRAOVER_VIEW_SHOW,function(event)
		self.floatView = event.data and event.data.view or nil
    end)
	GameController:addEventListener(GlobalEvent.EXITGAME_VIEW_SHOW,function(event)
		self.floatView = event.data and event.data.view or nil
    end)
	GameController:addEventListener(GlobalEvent.RANK_VIEW_SHOW,function(event)
		self.floatView = event.data and event.data.view or nil
    end)
	GameController:addEventListener(GlobalEvent.TASK_VIEW_SHOW,function(event)
		self.floatView = event.data and event.data.view or nil
    end)
	GameController:addEventListener(GlobalEvent.TOOL_VIEW_SHOW,function(event)
		self.floatView = event.data and event.data.view or nil
    end)
	GameController:addEventListener(GlobalEvent.JINGTU_VIEW_SHOW,function(event)
		self.floatView = event.data and event.data.view or nil
    end)
	
	GameController:addEventListener(GlobalEvent.CLICK_WOODENFINISH_SUCCESS, handler(self, self.clickWoodenFinishSuccessEvent))	
end


	
return GameLayer
