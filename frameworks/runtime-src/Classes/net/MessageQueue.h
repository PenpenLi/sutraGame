#ifndef __MESSAGE_QUEUE_H__
#define __MESSAGE_QUEUE_H__

#define MESSAGE_TYPE_NOT_INIT (0)				//未初始化的包
#define MESSAGE_TYPE_SOCKET_OPEN  (1)			//socket连接成功
#define MESSAGE_TYPE_RECEIVE_NEW_MESSAGE (2)	//接收到的数据包
#define MESSAGE_TYPE_SOCKET_ERROR (3)			//socket异常
#define MESSAGE_TYPE_SOCKET_CLOSE (4)			//socket关闭
#define MESSAGE_TYPE_SEND_NEW_MESSAGE (5)		//待发送的数据包
#define MESSAGE_TYPE_SOCKET_RECONNECT_OPEN  (6)	//socket重连成功
#define MESSAGE_TYPE_SOCKET_RECONNECT_ERROR (7) //socket重连失败
#define MESSAGE_TYPE_RECEIVE_HEART_BEAT (100)	//接收到的心跳包
#define MESSAGE_TYPE_SEND_HEART_BEAT (101)		//待发送的心跳包

#include <queue> 
#include <string>

#include "cocos2d.h"
#include "CCLuaEngine.h"



typedef struct _message{
	int code;
	const char* message;
	size_t len;
	bool free;
	_message():free(false){};
	//cocos2d::LuaValueDict dict;
}Message;

class MessageQueue
{
public:
	void push(Message message);
	Message pop();
	MessageQueue();
	~MessageQueue();
public:
	std::queue<Message> messageQueue;
	
};

class AsyncMessageQueue
{
public:
	void push(Message message);
	Message pop();
	AsyncMessageQueue();
	~AsyncMessageQueue();
public:
	std::mutex m_Mutex;
	std::queue<Message> messageQueue;

};

class NetEvent;
class AsyncNetEvent
{
public:
	~AsyncNetEvent();
	void Clear();
	
	void push(NetEvent* pEvent);
	NetEvent* pop();
private:

	std::mutex m_Mutex;
	std::queue<NetEvent*> messageQueue;
};

#endif