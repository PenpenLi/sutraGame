
local rankView = class("rankView", cocosMake.DialogBase)

--cocos studio生成的csb
rankView.ui_resource_file = {"rankNode"}


					
rankView.ui_binding_file = {
}

function rankView:onCreate(param)
	self.songCount:setString(UserData:getSutraNum())
	self.incenseCount:setString(UserData:getCenserNum())
	self.signCount:setString(UserData:getSignNum())
	
	self.signNo:setString(UserData:getSignRank())
	self.incenseNo:setString(UserData:getCenserRank())
	self.songNo:setString(UserData:getSutraRank())
	self.rankNo:setString(UserData:getTotalRank())
	
	
	self:dispatchEvent({name = GlobalEvent.RANK_VIEW_SHOW, data={view=self}})
end


function rankView:onClose( ... )
	ccexp.AudioEngine:setVolume(ccexp.AudioEngine:play2d(audioData.buttonClick, false), 70)
	self:dispatchEvent({name = GlobalEvent.RANK_VIEW_SHOW, data={view=nil}})
end

function rankView:bgTouch()
end

function rankView:closeBtnClick(event)
	ccexp.AudioEngine:setVolume(ccexp.AudioEngine:play2d(audioData.buttonClick, false), 70)
	
	LayerManager.closeFloat(self)
end




return rankView
