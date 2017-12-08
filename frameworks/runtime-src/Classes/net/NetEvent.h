#ifndef NET_EVENT_INCLUDE_H_
#define NET_EVENT_INCLUDE_H_
#include <string>

class NetEvent
{
public:
	NetEvent(){}
	virtual ~NetEvent(){}
	virtual void Process() = 0;
};


class ReconnectNetEvent :public NetEvent
{
public:
	bool bNeedIP;
	std::string ip;
	unsigned short nPort;
    ReconnectNetEvent(){};
    ~ReconnectNetEvent(){};
	virtual void Process();
};
class ConnectNotifyEvent :public NetEvent
{
public:
	int nEventError;
	virtual void Process();
};
class ErrorNotifyEvent :public NetEvent
{
public:
	int nEventError;
	virtual void Process();

};
class SendNetEvent :public NetEvent
{
public:
	
	const char* message;
	size_t len;
	virtual void Process();
};
class InitNetEvent :public NetEvent
{
public:
	std::string ip;
	unsigned short port;
	std::string domain;
	void Process();
};
class DisconnectNetEvent :public NetEvent
{
public:
	virtual void Process();
};


#endif