#include "SocketManager.h"
#include <string>
#include "NetEvent.h"

using namespace std;

//本messagequeu非线程安全
Message MessageQueue::pop()
{ 	
	Message message;
	message.code = MESSAGE_TYPE_NOT_INIT;
	message.message = "";
	message.len = 0;
	if(this->messageQueue.size()>0)
	{
		message = this->messageQueue.front();
		this->messageQueue.pop();		
	}
	
	return message;
}

void MessageQueue::push(Message m)
{ 
	this->messageQueue.push(m);	
}

MessageQueue::~MessageQueue()
{
}

MessageQueue::MessageQueue()
{

}

void AsyncMessageQueue::push(Message message)
{
	m_Mutex.lock();
	this->messageQueue.push(message);
	m_Mutex.unlock();
}
Message AsyncMessageQueue::pop()
{
	Message message;
	message.code = MESSAGE_TYPE_NOT_INIT;
	message.message = "";
	message.len = 0;
	m_Mutex.lock();
	if (this->messageQueue.size() > 0)
	{
		message = this->messageQueue.front();
		this->messageQueue.pop();
	}
	m_Mutex.unlock();

	return message;
}
AsyncMessageQueue::AsyncMessageQueue()
{

}
AsyncMessageQueue::~AsyncMessageQueue()
{

}

AsyncNetEvent::~AsyncNetEvent()
{
	NetEvent* pEvent = 0;
	while (messageQueue.size()>0)
	{
		pEvent = this->messageQueue.front();
		this->messageQueue.pop();
		delete pEvent;
	}
}
void AsyncNetEvent::Clear()
{
	m_Mutex.lock();
	NetEvent* pEvent = 0;
	while (messageQueue.size() > 0)
	{

		pEvent = this->messageQueue.front();
		this->messageQueue.pop();
		delete pEvent;
	}
	m_Mutex.unlock();
}
void AsyncNetEvent::push(NetEvent* pEvent)
{
	if (pEvent == NULL)
		return;
	m_Mutex.lock();
	messageQueue.push(pEvent);
	m_Mutex.unlock();
	
}
NetEvent* AsyncNetEvent::pop()
{

	NetEvent* pEvent = 0;
	m_Mutex.lock();
	if (this->messageQueue.size() > 0)
	{
		pEvent = this->messageQueue.front();
		this->messageQueue.pop();
	}
	m_Mutex.unlock();
	return pEvent;
}