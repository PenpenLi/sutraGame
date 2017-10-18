local networkTipsLayer = class("networkTipsLayer", cocosMake.viewBase)

--[[
networkTipsLayer.ui_resource_file = {Resources.csb.LoginLayerUI}--cocos studio生成的csb

networkTipsLayer.ui_binding_file = {
loginPanel={name="LoginLayerUI.loginPanel"},
login_zhanghaoInput={name="LoginLayerUI.loginPanel.zhanghao_input"},
login_mimaInput={name="LoginLayerUI.loginPanel.mima_input"},
Image_2={name="LoginLayerUI.loginPanel.Image_2"},
Button_login={name="LoginLayerUI.loginPanel.Button_login",event="touch",method="loginLoginClick"},
}
--]]


function networkTipsLayer:onCreate(param)
	self:setVisible(false)
	print("networkTipsLayer:onCreate")
    self.networkConnectListener = NetworkManager:addEventListener(GlobalEvent.NETWORK, function(event)  self:networkConnectEventCallback(event) end)
end

--处理network连接事件
function networkTipsLayer:networkConnectEventCallback( event )
    if event.data.msgtype == Constant.Network.CODE_ONOPEN then
		print("networkTipsLayer网络事件：CODE_ONOPEN")
		
		
	elseif event.data.msgtype == Constant.Network.CODE_ONERROR then
		print("networkTipsLayer网络事件：CODE_ONERROR")
		
	elseif event.data.msgtype == Constant.Network.CODE_ONCLOSE then
		print("networkTipsLayer网络事件：CODE_ONCLOSE")
		
	elseif event.data.msgtype == Constant.Network.CODE_RECONNECT then
		print("networkTipsLayer网络事件：CODE_RECONNECT")
		
	elseif event.data.msgtype == Constant.Network.CODE_RECONNECTERROR then
		print("networkTipsLayer网络事件：CODE_RECONNECTERROR")
	end
end

function networkTipsLayer:onClose()
	if self.networkConnectListener then
		NetworkManager:removeEventListener(self.networkConnectListener)
		self.networkConnectListener = nil
	end
end


return networkTipsLayer