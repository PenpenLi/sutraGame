
local signBoardView = class("signBoardView", cocosMake.DialogBase)

--cocos studio生成的csb
signBoardView.ui_resource_file = {"signBoardNode"}


					
signBoardView.ui_binding_file = {
	closeBtn        = {event = "click", method = "touchPanelClick"},
	jingtuBtn        = {event = "click", method = "jingtuBtnClick"},
	rankBtn        = {event = "click", method = "rankBtnClick"},
	lotusBtn        = {event = "click", method = "lotusBtnClick"},
	
}

function signBoardView:onCreate(param)
	local selectSong = UserData:getSelectSongInfo()
	local score = 0
	if selectSong and selectSong.score then score = selectSong.score end
	self.fohaoMonthNum:setString(score)
	local ndy = self.signBoardNode:getPositionY()
	self.signBoardNode:setPositionY(ndy+100)
	
	self.signSuccessCallback = param.signCallback
	self:dispatchEvent({name = GlobalEvent.SIGN_VIEW_SHOW, data={view=self}})
	
	local first_wday = UserData.monthWeekDay[1].wday
	local cnt = 1
	local showSignIndex = true
	for j=1, 5 do
		local ivalue = j == 1 and first_wday or 1
		for i=ivalue, 7 do
			if cnt > 31 or not UserData.monthWeekDay[cnt] then
				break
			end
			local dayspr = self["day" .. j .. i ]
			dayspr:setVisible(true)
			dayspr:setString(cnt)
			dayspr.cnt=cnt
			if cnt == UserData.today.day then
				if UserData.todayCanSign then
					local qiandaoIcon = cocosMake.newSprite("res/signBoard/q_ok.png", 29, 5)
					
					dayspr:addChild(qiandaoIcon)
					dayspr:setTouchEnabled(true)
					dayspr:onClicked(function() 
						--更新数据
						UserData:signToday(  )
						
						TipViewEx:showTip(TipViewEx.tipType.signSuccess)
						
						dayspr:removeFromParent()
						dayspr:addChild(cocosMake.newSprite("res/signBoard/" .. (UserData.monthWeekDay[dayspr.cnt].sign and "q_on" or "q_off") .. ".png", 40+(dayspr.cnt>9 and 0 or -6), 20))
						dayspr:setTouchEnabled(false)
						self:signOn()
					end)
				else
					dayspr:addChild(cocosMake.newSprite("res/signBoard/" .. (UserData.monthWeekDay[dayspr.cnt].sign and "q_on" or "q_off") .. ".png", 40+(dayspr.cnt>9 and 0 or -6), 20))
				end
				showSignIndex = false
			elseif showSignIndex then
				dayspr:addChild(cocosMake.newSprite("res/signBoard/" .. (UserData.monthWeekDay[dayspr.cnt].sign and "q_on" or "q_off") .. ".png", 50+(dayspr.cnt>9 and 0 or -16), 20))
			end
			cnt = cnt + 1
		end
	end
	
	AdManager:showAd()
	
	self:setJingtuButtonTipsVisible(true)
	self:setLotusButtonTipsVisible(true)
	
	--是否更新了相关数据，按钮特效提示
	self:setJingtuButtonTipsVisible(CacheUtil:getCustomCacheVal("jingtu_buttonTips", "boolean", false))
	self:setLotusButtonTipsVisible(CacheUtil:getCustomCacheVal("lotus_buttonTips", "boolean", false))
	
	return true
end


function signBoardView:onClose( ... )
	AdManager:loadAd()
	AdManager:hideAd()
	self:dispatchEvent({name = GlobalEvent.SIGN_VIEW_SHOW, data={view=nil}})
end

function signBoardView:signOn()
	if self.signSuccessCallback then
		self.signSuccessCallback()
	end
    ccexp.AudioEngine:setVolume(ccexp.AudioEngine:play2d(audioData.signDay, false), 70)
	LayerManager.closeFloat(self)
end

function signBoardView:touchPanelClick(event)
	ccexp.AudioEngine:setVolume(ccexp.AudioEngine:play2d(audioData.buttonClick, false), 70)
	LayerManager.closeFloat(self)
end

function signBoardView:jingtuBtnClick(event)
	ccexp.AudioEngine:setVolume(ccexp.AudioEngine:play2d(audioData.buttonClick, false), 70)
	
	local songData = UserData:loadMusicRhythmData()
	local buddhas = string.lower(UserData:getBuddhas())
	for k,v in pairs(songData) do
		if  v.buddhaId == buddhas then
			CacheUtil:setCustomCacheVal("jingtu_buttonTips", false)
			LayerManager.showFloat(luaFile.jingtuView, {modal=true, jingtu=v.jingtuId})
			break
		end
	end
	
	
	
end

function signBoardView:rankBtnClick(event)
	ccexp.AudioEngine:setVolume(ccexp.AudioEngine:play2d(audioData.buttonClick, false), 70)
	
	--LayerManager.closeFloat(self)
	
	LayerManager.showFloat(luaFile.rankView, {offClose=true, modal=true})
end

function signBoardView:lotusBtnClick(event)
	ccexp.AudioEngine:setVolume(ccexp.AudioEngine:play2d(audioData.buttonClick, false), 70)
	
	--LayerManager.closeFloat(self)
	CacheUtil:setCustomCacheVal("lotus_buttonTips", false)
	LayerManager.showFloat(luaFile.lotusView, {modal=true})
end

function signBoardView:setJingtuButtonTipsVisible(b)
	if b and not self.jingtuTipsAnimNode then
		self.jingtuTipsAnimNode=WidgetHelp:createButtonEffSprite({scale=1.6, x=60, y=50})
		self.jingtuBtn:addChild(self.jingtuTipsAnimNode)
	end
	if self.jingtuTipsAnimNode then self.jingtuTipsAnimNode:setVisible(b) end
end


function signBoardView:setLotusButtonTipsVisible(b)
	if b and not self.lotusTipsAnimNode then
		self.lotusTipsAnimNode=WidgetHelp:createButtonEffSprite({scale=1.6, x=80, y=50})
		self.lotusBtn:addChild(self.lotusTipsAnimNode)
	end
	if self.lotusTipsAnimNode then self.lotusTipsAnimNode:setVisible(b) end
end

return signBoardView
