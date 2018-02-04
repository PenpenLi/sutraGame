
local sutraBoardView = class("sutraBoardView", cocosMake.DialogBase)

--cocos studio生成的csb
sutraBoardView.ui_resource_file = {"sutraBoardNode"}


					
sutraBoardView.ui_binding_file = {
	closeBtn        = {event = "click", method = "closeBtnClick"},
	preBtn        = {event = "click", method = "preBtnClick"},
	nextBtn        = {event = "click", method = "nextBtnClick"},
	sureBtn        = {event = "click", method = "sureBtnClick"},
}

function sutraBoardView:onCreate(param)
	
	local musicInfo = UserData:loadMusicRhythmData()
	self.selectCallback = param.selectCallback
	self.musicInfo = musicInfo
	
	local kuaiban, manban = {}, {}
	for i=1, #musicInfo do
		local ban = (i%2) == 1 and kuaiban or manban
		ban[#ban+1] = musicInfo[i]
		
		if musicInfo[i].id == UserData.selectSongId then
			self.lastSelectName = musicInfo[i].songName
		end
	end
	
	self.pages_kuaiban={}
	self.pages_manban={}
	
	for k,v in pairs(kuaiban) do
		local page_k = math.ceil(k/5)
		if not self.pages_kuaiban[page_k] then self.pages_kuaiban[page_k] = {} end
		table.insert(self.pages_kuaiban[page_k], v.songName)
	end
	for k,v in pairs(manban) do
		local page_k = math.ceil(k/5)
		if not self.pages_manban[page_k] then self.pages_manban[page_k] = {} end
		table.insert(self.pages_manban[page_k], v.songName)
	end
	
	self.currPage = 1
	
	self:dispatchEvent({name = GlobalEvent.SUTRA_VIEW_SHOW, data={view=self}})
	 
	self:updatePage()
	 
	 AdManager:showAd()
end

function sutraBoardView:updatePage(param)
	local function selectedEvent(sender,eventType)
		local tag = sender:getTag()		
		for i=1,10 do
		if tag == self["CheckBox_"..i]:getTag() then
			self.lastSelectName = self["CheckBox_"..i].songName
			self:updateCheckboxState()
			break
		end
	end
		--self:selectSutra(tonumber(tag)-1000)
	end
	
	for i=1,10 do
		self["Text_"..i]:setString("")
		self["CheckBox_"..i]:setTag(0)
		self["CheckBox_"..i]:setVisible(false)
		self["CheckBox_"..i].songName = nil
	end

	
	if self.pages_kuaiban[self.currPage] then
		for i=1, 5 do
			local songName = self.pages_kuaiban[self.currPage][i] or ""
			self["Text_"..i]:setColor(cc.c3b(0, 0, 0))
			self["Text_"..i]:setString(songName)
			if songName ~= "" then
				self["CheckBox_"..i]:addEventListenerCheckBox(selectedEvent)
				self["CheckBox_"..i]:setTag(i + (self.currPage-1)*10)
				self["CheckBox_"..i]:setVisible(true)
				self["CheckBox_"..i].songName = songName
			end
		end
	end
	if self.pages_manban[self.currPage] then
		for i=1, 5 do
			local is = i+5
			local songName = self.pages_manban[self.currPage][i] or ""
			self["Text_"..is]:setColor(cc.c3b(0, 0, 0))
			self["Text_"..is]:setString(songName)
			if songName ~= "" then
				self["CheckBox_"..is]:addEventListenerCheckBox(selectedEvent)
				self["CheckBox_"..is]:setTag(i + 5 + (self.currPage-1)*10)
				self["CheckBox_"..is]:setVisible(true)
				self["CheckBox_"..is].songName = songName
			end
		end
	end
	
	self:updateCheckboxState()
end

function sutraBoardView:updateCheckboxState(param)
	for i=1, 10 do
		if self["CheckBox_"..i] then
			self["CheckBox_"..i]:setSelectedState(self["CheckBox_"..i].songName == self.lastSelectName)
		end
	end
end

function sutraBoardView:selectSutra( tag )
	
end

function sutraBoardView:onClose( ... )
	AdManager:hideAd()
	self:dispatchEvent({name = GlobalEvent.SUTRA_VIEW_SHOW, data={view=nil}})
end

function sutraBoardView:bgTouch()
end

function sutraBoardView:closeBtnClick(event)
	audioCtrl:playSound(audioData.buttonClick, false)
	
	LayerManager.closeFloat(self)
end
function sutraBoardView:preBtnClick(event)
	audioCtrl:playSound(audioData.buttonClick, false)
	
	if (self.currPage-1) >= 1 then
		self.currPage=self.currPage-1
		self:updatePage()
	end
	
end
function sutraBoardView:nextBtnClick(event)
	audioCtrl:playSound(audioData.buttonClick, false)
	
	
	if (self.currPage+1) <= math.max(#self.pages_kuaiban, #self.pages_manban) then
		self.currPage=self.currPage+1
		self:updatePage()
	end
	
	--LayerManager.closeFloat(self)
end
function sutraBoardView:sureBtnClick(event)
	audioCtrl:playSound(audioData.buttonClick, false)
	
	
	local key
	local musicInfo = UserData:loadMusicRhythmData()
	for k,v in pairs(musicInfo) do
		if v.songName == self.lastSelectName then
			UserData.selectSongId = v.id
			key = k
			break
		end
	end
	if not key then
		TipViewEx:showTip("改佛曲不存在，请重新选择")
		return
	end
	
	--ccexp.AudioEngine:preload("res/audio/song/" .. musicInfo[UserData.selectSongId].songId .. ".mp3")
	audioCtrl:preloadMusic("res/audio/song/" .. musicInfo[key].songId .. ".mp3")
	if self.selectCallback then self.selectCallback(key) end
	
	LayerManager.closeFloat(self)
end



return sutraBoardView
