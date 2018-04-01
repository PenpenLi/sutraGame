
local jingtuView = class("jingtuView", cocosMake.DialogBase)

--cocos studio生成的csb
jingtuView.ui_resource_file = {"jingtuNode"}


					
jingtuView.ui_binding_file = {

}


function jingtuView:onCreate(param)
	local jingtu = param.jingtu or "jlsj"
	local openBlockNum = UserData:getJingtuOpenData(jingtu) or 0
	log("openBlockNum", openBlockNum, jingtu)
	
	local jingtuNode = cc.CSLoader:createNode("jingtuNode_" .. jingtu .. ".csb")
	if jingtuNode then
		self:addChild(jingtuNode)
		jingtuNode:setPosition(display.center)
		self.jingtuNode = jingtuNode
		 WidgetHelp:dealChildren(self)
		
		jingtuNode.touchPanel:onClicked(function ()
			self:touchPanelClick()
		end)
	end
	
	self:dispatchEvent({name = GlobalEvent.JINGTU_VIEW_SHOW, data={view=self}})
	
	for i=1, openBlockNum do		
		local action_list1 = {}
		action_list1[#action_list1 + 1] = cc.DelayTime:create((i-1)*2)
		action_list1[#action_list1 + 1] = cc.FadeIn:create(1)
		--local action1 = cc.RepeatForever:create(cc.Sequence:create(unpack(action_list1)))
		self["block"..i]:setVisible(true)
		--self["block"..i]:setOpacity(0)
		--self["block"..i]:runAction(action1)
	end
	
	self.touchPanel:setTouchEnabled(true)
	self.touchPanel:onClicked(function ()
		self:touchPanelClick()
	end)
	
end


function jingtuView:onClose( ... )
	
	self:dispatchEvent({name = GlobalEvent.JINGTU_VIEW_SHOW, data={view=nil}})
end

function jingtuView:touchPanelClick(event)
	ccexp.AudioEngine:setVolume(ccexp.AudioEngine:play2d(audioData.buttonClick, false), 70)
	
	LayerManager.closeFloat(self)
end


return jingtuView
