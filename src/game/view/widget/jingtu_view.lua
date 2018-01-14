
local jingtuView = class("jingtuView", cocosMake.DialogBase)

--cocos studio生成的csb
jingtuView.ui_resource_file = {"jingtuNode"}


					
jingtuView.ui_binding_file = {
closeBtn        = {event = "click", method = "touchPanelClick"},
}


function jingtuView:onCreate(param)
	local jingtu = param.jingtu or "jlsj"
	local openBlockNum = math.random(0, 12)
	log("openBlockNum", openBlockNum)
	
	local jingtuNode = cc.CSLoader:createNode("jingtuNode_" .. jingtu .. ".csb")
	if jingtuNode then
		self:addChild(jingtuNode)
		jingtuNode:setPosition(display.center)
		self.jingtuNode = jingtuNode
		 WidgetHelp:dealChildren(self)
	end
	
	self:dispatchEvent({name = GlobalEvent.JINGTU_VIEW_SHOW, data={view=self}})
	
	for i=1, openBlockNum do		
		local action_list1 = {}
		action_list1[#action_list1 + 1] = cc.DelayTime:create((i-1)*2)
		action_list1[#action_list1 + 1] = cc.FadeIn:create(1)
		local action1 = cc.RepeatForever:create(cc.Sequence:create(unpack(action_list1)))
		self["block"..i]:setVisible(true)
		self["block"..i]:setOpacity(0)
		self["block"..i]:runAction(action1)
	end
end


function jingtuView:onClose( ... )
	
	self:dispatchEvent({name = GlobalEvent.JINGTU_VIEW_SHOW, data={view=nil}})
end

function jingtuView:touchPanelClick(event)
	audioCtrl:playSound(audioData.buttonClick, false)
	
	LayerManager.closeFloat(self)
end


return jingtuView
