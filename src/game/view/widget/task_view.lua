
local taskView = class("taskView", cocosMake.DialogBase)

--cocos studio生成的csb
taskView.ui_resource_file = {"taskNode"}


					
taskView.ui_binding_file = {
	closeBtn        = {event = "click", method = "closeBtnClick"},
	preBtn        = {event = "click", method = "preBtnClick"},
	nextBtn        = {event = "click", method = "nextBtnClick"},
}

function taskView:onCreate(param)
	if not UserData.todayCanSign then self.over1:setVisible(true) end
	if UserData.buddhasLightLevel > 0 then self.over2:setVisible(true) end
	if UserData.buddhasLightLevel > 1 then self.over3:setVisible(true) end
	if UserData.buddhasLightLevel > 2 then self.over4:setVisible(true) end
	--if UserData.buddhasLightLevel > 3 then self.over5:setVisible(true) end
	if not UserData.todayCanSong then self.over5:setVisible(true) end
	if UserData.toolList["1"] then self.over6:setVisible(true) end
	if UserData.toolList["2"] then self.over7:setVisible(true) end
	if UserData.toolList["3"] and UserData.toolList["3"] >= 108 then self.over8:setVisible(true) end
	
	if UserData.chenghaoLv > 0 then
		for i=1, UserData.chenghaoLv do
			local n = i + 8
			self["over"..n]:setVisible(true)
		end
	end
	
	
	self.preBtn:setVisible(false)
	self.nextBtn:setVisible(true)
	
	self.page1:setVisible(true)
	self.page2:setVisible(false)
	
	self:dispatchEvent({name = GlobalEvent.TASK_VIEW_SHOW, data={view=self}})
end


function taskView:onClose( ... )
	self:dispatchEvent({name = GlobalEvent.TASK_VIEW_SHOW, data={view=nil}})
end

function taskView:bgTouch()
end

function taskView:closeBtnClick(event)
	ccexp.AudioEngine:setVolume(ccexp.AudioEngine:play2d(audioData.buttonClick, false), 70)
	
	LayerManager.closeFloat(self)
end
function taskView:preBtnClick(event)
	self.preBtn:setVisible(false)
	self.nextBtn:setVisible(true)
	
	self.page1:setVisible(true)
	self.page2:setVisible(false)
end
function taskView:nextBtnClick(event)
	self.preBtn:setVisible(true)
	self.nextBtn:setVisible(false)
	
	self.page1:setVisible(false)
	self.page2:setVisible(true)
end




return taskView
