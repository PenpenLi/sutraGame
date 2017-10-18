local tipsView = class("tipsView", cocosMake.Node)


function tipsView:ctor(param)
	self:setPosition(display.visibleRect.center)
    local bg = cocosMake.newSprite("ui/common/tipsbg.png", 0, 0)
	bg:setAnchorPoint(cc.p(0.5, 0.5))
	self:addChild(bg)
	
	local bgsize = bg:getContentSize()
	local label = cocosMake.newLabel(param.text, bgsize.width/2.0, bgsize.height/2.0, {size=30})
	bg:addChild(label)
    
	local t = 1.5
	local spawn = cc.Spawn:create(CCMoveTo:create(t, cc.p(0, 149)), CCFadeOut:create(t))
	local sequence = transition.sequence({
			CCDelayTime:create(1.0),
			spawn,
			cc.CallFunc:create(function() self:removeFromParent(true) end )
		})
   bg:runAction(sequence)
end

return tipsView

