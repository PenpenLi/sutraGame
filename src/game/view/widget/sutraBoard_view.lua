
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
	self.ziyoufahui_songlist = {}
	self.muyuyinddao_songlist = {}
	for i=1, #songData do
		if songData[i].type == 1 then
			table.insert(self.ziyoufahui_songlist, songData[i])
		
		elseif songData[i].type == 2 then
			table.insert(self.muyuyinddao_songlist, songData[i])
		end
	end
	
	
	local itemCnt = math.max(#self.ziyoufahui_songlist, #self.muyuyinddao_songlist)
	self.pages={}
	for i=1, itemCnt do
		local idx = math.max(1, math.ceil((i-1)/5))
		if not self.pages[idx] then self.pages[idx] = {A={}, B={}} end
		if self.ziyoufahui_songlist[i] then table.insert(self.pages[idx].A, self.ziyoufahui_songlist[i]) end
		if self.muyuyinddao_songlist[i] then table.insert(self.pages[idx].B, self.muyuyinddao_songlist[i]) end
	end
	self.currPage = 1
	
	
	
	 self.select = UserData.selectSongs
	 log("-------------B.self.select", self.select)
	 
	 self:dispatchEvent({name = GlobalEvent.SUTRA_VIEW_SHOW, data={view=self}})
	 
	 self:updatePage()
end

function sutraBoardView:updatePage(param)
	local function selectedEvent(sender,eventType)
		local tag = sender:getTag()
		log("-------------A.self.select", tag)
		self.select = tag
		self:updateCheckboxState()
		--self:selectSutra(tonumber(tag)-1000)
	end
	
	for i=1,10 do
		self["Text_"..i]:setString("")
		self["CheckBox_"..i]:setTag(0)
		self["CheckBox_"..i]:setVisible(false)
	end
	
	for i=1, #self.pages[self.currPage].A do
		self["Text_"..i]:setColor(cc.c3b(0, 0, 0))
		self["Text_"..i]:setString(self.pages[self.currPage].A[i].name)
		self["CheckBox_"..i]:addEventListenerCheckBox(selectedEvent)
		self["CheckBox_"..i]:setTag(self.pages[self.currPage].A[i].id)
		self["CheckBox_"..i]:setVisible(true)
	end	
	for i=1, #self.pages[self.currPage].B do
		local j=i+5
		self["Text_"..j]:setColor(cc.c3b(0, 0, 0))
		self["Text_"..j]:setString(self.pages[self.currPage].B[i].name)
		
		self["CheckBox_"..j]:addEventListenerCheckBox(selectedEvent)
		self["CheckBox_"..j]:setTag(self.pages[self.currPage].B[i].id)
		self["CheckBox_"..j]:setVisible(true)
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
	LayerManager.closeFloat(self)
end



return sutraBoardView
