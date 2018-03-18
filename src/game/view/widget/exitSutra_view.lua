
local exitSutraView = class("exitSutraView", cocosMake.DialogBase)

--cocos studio生成的csb
exitSutraView.ui_resource_file = {"exitSutraNode"}


					
exitSutraView.ui_binding_file = {
	closeBtn        = {event = "click", method = "closeBtnClick"},
	noBtn			= {event = "click", method = "noBtnClick"},
	yesBtn	        = {event = "click", method = "yesBtnClick"},
}


function exitSutraView:onCreate(param)
	
	self.player = param.player
	self.player:pause()
	
	AdManager:showAd()
end

function exitSutraView:appEnterForeground()
	LayerManager.closeFloat(self)
end

function exitSutraView:onClose( ... )
	self.player.exitSutraShowing = false
	AdManager:loadAd()
	AdManager:hideAd()
end

function exitSutraView:bgTouch()
end

function exitSutraView:closeBtnClick(event)
	self.player:resume()
	LayerManager.closeFloat(self)
end

function exitSutraView:noBtnClick(event)
	self.player:resume()
	LayerManager.closeFloat(self)
end

function exitSutraView:yesBtnClick(event)
	self.player:stop()

	self:dispatchEvent({name = GlobalEvent.EXITSUTRA_NOTIFY, data={}})
	
	LayerManager.showFloat(luaFile.sutraOverBoardView, {modal=true,id=self.player:getMusicId(), result=self.player:isSuccessed(), fojuScore = self.player:getFojuScore()})
	self.player:clear()
	LayerManager.closeFloat(self)	
end




return exitSutraView
