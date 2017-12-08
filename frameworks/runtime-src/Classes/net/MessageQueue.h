#ifndef __MESSAGE_QUEUE_H__
#define __MESSAGE_QUEUE_H__

#define MESSAGE_TYPE_NOT_INIT (0)				//δ��ʼ���İ�
#define MESSAGE_TYPE_SOCKET_OPEN  (1)			//socket���ӳɹ�
#define MESSAGE_TYPE_RECEIVE_NEW_MESSAGE (2)	//���յ������ݰ�
#define MESSAGE_TYPE_SOCKET_ERROR (3)			//socket�쳣
#define MESSAGE_TYPE_SOCKET_CLOSE (4)			//socket�ر�
#define MESSAGE_TYPE_SEND_NEW_MESSAGE (5)		//�����͵����ݰ�
#define MESSAGE_TYPE_SOCKET_RECONNECT_OPEN  (6)	//socket�����ɹ�
#define MESSAGE_TYPE_SOCKET_RECONNECT_ERROR (7) //socket����ʧ��
#define MESSAGE_TYPE_RECEIVE_HEART_BEAT (100)	//���յ���������
#define MESSAGE_TYPE_SEND_HEART_BEAT (101)		//�����͵�������

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