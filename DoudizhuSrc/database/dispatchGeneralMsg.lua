dispatchGeneralMsg = {}
function dispatchGeneralMsg.dealConnect(data)
	Notifier.postNotifty("Notifty_MsgFloatUI_floatMsg",{msg = TxtCache.ConnectMsg[data.retcode]})
    Notifier.postNotifty("Notifty_Connect_State",{retcode = data.retcode})
end

function dispatchGeneralMsg:registerResponse()
    EventHelper:addListener(Constant.Network.CONNECT_EVENT,dispatchGeneralMsg.dealConnect)
end