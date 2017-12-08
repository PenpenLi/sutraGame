#ifndef __SOCKET_LISTENER_H__
#define __SOCKET_LISTENER_H__
#include "pthread.h"
#include <string>
#include "cocos2d.h"

using namespace std;
USING_NS_CC;
class SocketListener;

class SocketListenerDelegate
{
public:
    virtual ~SocketListenerDelegate() {}
    virtual void onSocketEvent(SocketListener* socketListener,int code,const char* data) = 0;
};

class SocketListener:public Ref
{
public:
	SocketListener();
	virtual ~SocketListener();
	virtual void onOpen();
	virtual void onReconnectOpen();
	virtual void onReceiveNewData(string data);
	virtual void onReceiveNewData(char* data,int length);
	virtual void onReceiveHeartBeat();
	virtual void onError(int errorCode);
	virtual void onReconnectError(int errorCode);
	virtual void onClose();
	void callbackLua(int code,string data);
	void callbackLua(int code,char* data,int length);
    void registerScriptHandler(int funcID);
	int getScriptHandler();
	void setSocketListenerDelegate(SocketListenerDelegate* socketDelegate);
	void dispatchResponseCallbacks(float delta);
private:
	pthread_t m_testThread;
	int funcID;
	SocketListenerDelegate* socketDelegate;
};

#endif