#include "SocketListener.h"
#include "SocketManager.h"
#include <string>
#include <sstream>
#include <ctime>
using namespace std;
//#include "script_support/CCScriptSupport.h"
#include "CCLuaEngine.h"
#include "TcpMessageBuilder.h"

#include "./NetpackHelper.h"

USING_NS_CC;
using namespace std;
void SocketListener::onOpen()
{
	callbackLua(MESSAGE_TYPE_SOCKET_OPEN,"open");
}


void SocketListener::onReconnectOpen()
{
	callbackLua(MESSAGE_TYPE_SOCKET_RECONNECT_OPEN,"reconnectOpen");
}

void SocketListener::onReceiveHeartBeat()
{
	CCLOG("\n..............................................heart beat ----- recv\n");
	callbackLua(MESSAGE_TYPE_RECEIVE_HEART_BEAT,"heart beat");	
}

void SocketListener::onReceiveNewData(std::string data)
{
	//printf("\n[c++]%s\n\n",data.c_str());
	callbackLua(MESSAGE_TYPE_RECEIVE_NEW_MESSAGE,data);		
}

void SocketListener::onReceiveNewData(char* data,int length)
{
	callbackLua(MESSAGE_TYPE_RECEIVE_NEW_MESSAGE,data,length);
}

void SocketListener::onError(int errorCode)
{
	stringstream ss;
	ss << "onError code=" << errorCode;
	callbackLua(MESSAGE_TYPE_SOCKET_ERROR,ss.str());
}

void SocketListener::onReconnectError(int errorCode)
{
	stringstream ss;
	ss << "onReconnectError code=" << errorCode;
	callbackLua(MESSAGE_TYPE_SOCKET_RECONNECT_ERROR,ss.str());
}

void SocketListener::onClose()
{
	callbackLua(MESSAGE_TYPE_SOCKET_CLOSE,"onClose");
}

void SocketListener::callbackLua(int code,string data)
{	
	Message m;
	m.code = code;
	m.len = data.length();

	char *buf = new char[m.len];
	memcpy(buf, data.c_str(), m.len);
	m.message = buf;
	m.free = true;
	SockMgr->addMessageToReceiveQueue(m);//将消息放到待处理队列
}

void SocketListener::callbackLua(int code,char* data,int length)
{
	//LuaValueDict dict = ;

	Message m;
	m.code = code;
	m.message = data;
	m.len = length;
	//m.message = "newmsg";	
	//m.dict = NetpackHelper::bufToLuaValue(data,length);
	SockMgr->addMessageToReceiveQueue(m);//将消息放到待处理队列
	//LuaValueDict dict = NetpackHelper::bufToLuaValue(m.ms_char,length);
}


void SocketListener::dispatchResponseCallbacks(float delta)
{ 
	//SockController->Process();
	Message m = SockMgr->getAndRemoveMessageFromReceiveQueue();//Scheduler回调本方法，从待处理队列取出消息

	//CCLOG("dispatchResponseCallbacks get messg\n");
	
	if(m.len > 0 ){
		int code = m.code;
        
		if (code == MESSAGE_TYPE_RECEIVE_NEW_MESSAGE)
		{
			//LuaValueDict dict = NetpackHelper::bufToLuaValue(m.message.c_str(),m.length);
			LuaEngine* pEngine = (LuaEngine*)ScriptEngineManager::getInstance()->getScriptEngine();
			LuaStack* luaStack= pEngine->getLuaStack();
			luaStack->pushInt(code);		
			luaStack->pushString(m.message, m.len);
			//luaStack->pushLuaValueDict(m.dict);
			luaStack->executeFunctionByHandler(this->funcID, 2);
			if (m.free)delete m.message;
		}else{
			LuaEngine* pEngine = (LuaEngine*)ScriptEngineManager::getInstance()->getScriptEngine();
			LuaStack* luaStack= pEngine->getLuaStack();
			luaStack->pushInt(code);		
			luaStack->pushString(m.message, m.len);					
			luaStack->executeFunctionByHandler(this->funcID, 2);
			if (m.free)delete m.message;
		}
	}
}

void SocketListener::registerScriptHandler(int funcId)
{
	this->funcID = funcId;
}

int SocketListener::getScriptHandler()
{
	return this->funcID;
}

void SocketListener::setSocketListenerDelegate(SocketListenerDelegate* socketDelegate)
{
	this->socketDelegate = socketDelegate;
}

//构造时，开始定时器
//在界面每一次刷新时，调用dispatchResponseCallbacks方法，读取并处理消息
SocketListener::SocketListener(){
    //SEL_SCHEDULE selector, Ref *target, float interval, bool paused
   // Director::getInstance()->getScheduler()->schedule(schedule_selector(SocketListener::dispatchResponseCallbacks), this, 0, false); 
}

//销毁时，关闭定时器
SocketListener::~SocketListener(){
    Director::getInstance()->getScheduler()->unscheduleAllForTarget(this);


//	CCDirector::sharedDirector()->getScheduler()->unscheduleAllForTarget(this);
}

