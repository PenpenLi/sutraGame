#include "NetEvent.h"
#include "SocketManager.h"
#include "NetpackHelper.h"
void ReconnectNetEvent::Process()
{
	
	if (!bNeedIP)
		SockMgr->reconnect();
	else
		SockMgr->reconnect(ip, nPort);
}
void ErrorNotifyEvent::Process()
{
	SockController->ProcessError(nEventError);
}

void ConnectNotifyEvent::Process()
{
	SockController->connectionNotifyEvent((Net::ConnectionState)nEventError);
}

void SendNetEvent::Process()
{
	//SockMgr->sendByteBuf(NetpackHelper::converToByteBuf((message.c_str())));
	SockMgr->sendByteBuf(message, len);
	delete message;
}

void InitNetEvent::Process()
{
	SockMgr->Init(ip.c_str(), port, domain.c_str());
}
void DisconnectNetEvent::Process()
{
	SockMgr->disconnect();
}