
local exitSutraView = class("exitSutraView", cocosMake.DialogBase)

--cocos studio生成的csb
exitSutraView.ui_resource_file = {"exitSutraNode"}


					
exitSutraView.ui_binding_file = {
	closeBtn        = {event = "click", method = "closeBtnClick"},
	noBtn			= {event = "click", method = "noBtnClick"},
	yesBtn	        = {event = "click", method = "yesBtnClick"},
}


function exitSutraView:onCreate(param)
	
	self.onClickCallback = param.onClickCallback or function() end
end



function exitSutraView:onClose( ... )
	
end

function exitSutraView:bgTouch()
end

function exitSutraView:closeBtnClick(event)
	self.onClickCallback("no")
	LayerManager.closeFloat(self)
end

function exitSutraView:noBtnClick(event)
	self.onClickCallback("no")
	LayerManager.closeFloat(self)
end

function exitSutraView:yesBtnClick(event)
	self.onClickCallback("yes")
	LayerManager.closeFloat(self)	
end




return exitSutraView
