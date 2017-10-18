
local rankView = class("rankView", cocosMake.DialogBase)

--cocos studio生成的csb
rankView.ui_resource_file = {"rankNode"}


					
rankView.ui_binding_file = {
	closeBtn        = {event = "click", method = "closeBtnClick"},
}

function rankView:onCreate(param)
	self.songCount:setString(UserData.songCount)
	self.incenseCount:setString(UserData.incenseCount)
	self.signCount:setString(UserData.signCount)
	
	
	self:dispatchEvent({name = GlobalEvent.RANK_VIEW_SHOW, data={view=self}})
end


function rankView:onClose( ... )
	self:dispatchEvent({name = GlobalEvent.RANK_VIEW_SHOW, data={view=nil}})
end

function rankView:bgTouch()
end

function rankView:closeBtnClick(event)
	audioCtrl:playSound(audioData.buttonClick, false)
	
	LayerManager.closeFloat(self)
end




return rankView
