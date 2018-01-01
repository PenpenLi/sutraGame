
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
	
	self.pages={}
	
	for k,v in pairs(musicInfo) do
		local page_k = math.ceil(k/10)
		if not self.pages[page_k] then self.pages[page_k] = {} end
		table.insert(self.pages[page_k], v.songName)
	end
	
	self.currPage = 1
	
	 self.select = UserData.selectSongs or 1
	 
	 self:dispatchEvent({name = GlobalEvent.SUTRA_VIEW_SHOW, data={view=self}})
	 
	 self:updatePage()
	 
	 AdManager:showAd()
end

function sutraBoardView:updatePage(param)
	local function selectedEvent(sender,eventType)
		local tag = sender:getTag()
		self.select = tag
		self:updateCheckboxState()
		--self:selectSutra(tonumber(tag)-1000)
	end
	
	for i=1,10 do
		self["Text_"..i]:setString("")
		self["CheckBox_"..i]:setTag(0)
		self["CheckBox_"..i]:setVisible(false)
	end
	
	for i=1, #self.pages[self.currPage] do
		self["Text_"..i]:setColor(cc.c3b(0, 0, 0))
		self["Text_"..i]:setString(self.pages[self.currPage][i])
		self["CheckBox_"..i]:addEventListenerCheckBox(selectedEvent)
		self["CheckBox_"..i]:setTag(i + (self.currPage-1)*10)
		self["CheckBox_"..i]:setVisible(true)
	end
	
	self:updateCheckboxState()
end

function sutraBoardView:updateCheckboxState(param)
	for i=1, 10 do
		if self["CheckBox_"..i] then
			self["CheckBox_"..i]:setSelectedState(self["CheckBox_"..i]:getTag() == self.select)
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
	
	--LayerManager.closeFloat(self)
end
function sutraBoardView:nextBtnClick(event)
	audioCtrl:playSound(audioData.buttonClick, false)
	
	
	if (self.currPage+1) <= #self.pages then
		self.currPage=self.currPage+1
		self:updatePage()
	end
	
	--LayerManager.closeFloat(self)
end
function sutraBoardView:sureBtnClick(event)
	audioCtrl:playSound(audioData.buttonClick, false)
	log("self.select", self.select)
	UserData.selectSongs = self.select
	
	local musicInfo = UserData:loadMusicRhythmData()
	ccexp.AudioEngine:preload("res/audio/song/" .. musicInfo[self.select].songId .. ".mp3")
	
	LayerManager.closeFloat(self)
end



return sutraBoardView
