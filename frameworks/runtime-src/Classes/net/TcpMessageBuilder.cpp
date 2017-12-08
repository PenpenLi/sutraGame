#include "TcpMessageBuilder.h"
#include <string>
#include "cocos2d.h"

#include "./ByteBuffer.h"
#include "./NetDefine.h"

#include "./NetpackHelper.h"

#define  ADD_BUFF_LEN			1024

USING_NS_CC;

bool TcpMessageBuilder::putData(char* data, int dataLen)
{
//	int tcpMessageLen = 0;
	//TODO 判断缓冲区是否被填满，是则扩容
	if (!ResizeBuff(dataLen))
		return false;
	//if( (this->m_currentLen + dataLen) > m_bufLen )
	//{
		//printf("消息太长，超过缓存区大小");
		//TODO 扩容
	//}

	//将新接收的数据写入缓存区
//	for(int i=0;i<dataLen;i++)
//	{
		//缓冲区为循环使用，故需 %this->m_bufLen
//		this->m_buf[ (this->m_startPosition + this->m_currentLen)%this->m_bufLen] = data[i];
//		this->m_currentLen++;
//	}
	memcpy(m_buf + m_currentLen, data, dataLen);
	m_currentLen = m_currentLen + dataLen;
	return true;
}

TcpMessage* TcpMessageBuilder::buildMessage()
{

	if( this->m_currentLen < TCP_MESSAGE_HEAD_LEN )
	{
		return NULL;
	}
	//static int inNum = 0;

//	int tcpMessageDataLen = ((this->m_buf[this->m_startPosition+3] << 24) & 0xff000000);
 //   tcpMessageDataLen |= ((this->m_buf[this->m_startPosition+2] << 16) & 0xff0000);
//    tcpMessageDataLen |= ((this->m_buf[this->m_startPosition+1] << 8) & 0xff00);
 //   tcpMessageDataLen |= this->m_buf[this->m_startPosition] & 0xff ;

		m_startPosition = 0;
		int  tcpMessageDataLen = 0;
		/*	int tcpMessageDataLen = ((this->m_buf[m_startPosition+3] << 24) & 0xff000000);
			tcpMessageDataLen |= ((this->m_buf[m_startPosition + 2] << 16) & 0xff0000);
			tcpMessageDataLen |= ((this->m_buf[m_startPosition + 1] << 8) & 0xff00);
			tcpMessageDataLen |= this->m_buf[m_startPosition + 0] & 0xff;*/

		memcpy(&tcpMessageDataLen, m_buf, 4);

	
    /*
     int tcpMessageDataLen = this->m_buf[this->m_startPosition+3] & 0xff ;
     tcpMessageDataLen |= ((this->m_buf[this->m_startPosition+2] << 8) & 0xff00);
     tcpMessageDataLen |= ((this->m_buf[this->m_startPosition+1] << 16) & 0xff0000);
     tcpMessageDataLen |= ((this->m_buf[this->m_startPosition] << 24) & 0xff000000);
     */
	 
		
	if(tcpMessageDataLen==0)//如果是空消息。空消息则是心跳包
	{
		m_startPosition += TCP_MESSAGE_HEAD_LEN;
		this->m_currentLen -= TCP_MESSAGE_HEAD_LEN;
		return new TcpMessage(0,NULL);
	}
	else
	{
        //CCLOG("包长度为:%d,实际长度为%d",tcpMessageDataLen,this->m_currentLen);
		if(this->m_currentLen - TCP_MESSAGE_HEAD_LEN >= tcpMessageDataLen)//如果缓冲区中有一条完整的消息
		{
            char* messageBody = new char[tcpMessageDataLen+1];
			if (messageBody == 0)
				return NULL;

			messageBody[tcpMessageDataLen] = '\0';

			memcpy(messageBody, m_buf + m_startPosition + TCP_MESSAGE_HEAD_LEN, tcpMessageDataLen);

			//for(int i=0;i<tcpMessageDataLen;i++)
			//{
				//messageBody[i] = m_buf[ (this->m_startPosition + i + TCP_MESSAGE_HEAD_LEN) % this->m_bufLen];
			//}
            
			//m_startPosition += (TCP_MESSAGE_HEAD_LEN + tcpMessageDataLen);
			//this->m_currentLen -= (TCP_MESSAGE_HEAD_LEN + tcpMessageDataLen);
            
            //CCLOG("有完整消息,实际长度为%ld",strlen(m_buf));
            
			/*
            std::string jsonstring = NetpackHelper::bufToJsonString(messageBody,tcpMessageDataLen);
			const char *strtr = jsonstring.c_str();
            
            delete[] messageBody;
            messageBody = NULL;
            
//            CCLOG("消息转换为json:%s,%ld",jsonstring,strlen(jsonstring));
//            return new TcpMessage(strlen(jsonstring),jsonstring);
                        
			int datal = jsonstring.length();
            char *msg = new char[datal+1];
            strcpy(msg, strtr);
            
            return new TcpMessage(datal,msg);			
			*/

			//LuaValueDict dict = NetpackHelper::bufToLuaValue(messageBody,tcpMessageDataLen);

			TcpMessage *msg = new TcpMessage(tcpMessageDataLen,messageBody); 

			
			
			m_startPosition += (TCP_MESSAGE_HEAD_LEN + tcpMessageDataLen);
			if (m_startPosition >= m_currentLen)
			{
				m_startPosition = 0;
				m_currentLen = 0;
			}
			else
			{
				memcpy(m_buf, m_buf + m_startPosition, m_currentLen - m_startPosition);
				//printf("num=%d,data=%s\n", inNum,m_buf + 4);
				m_currentLen = m_currentLen - m_startPosition;
				m_startPosition = 0;
				//inNum++;
				
			}

			return msg;
		}
	}
	return NULL;
}


TcpMessageBuilder::TcpMessageBuilder()
{
	this->m_bufLen = ADD_BUFF_LEN;
	this->m_buf = new char[m_bufLen];
	memset(m_buf, 0, ADD_BUFF_LEN);
	this->m_startPosition = 0;
	this->m_currentLen = 0;
}

TcpMessageBuilder::~TcpMessageBuilder()
{
	delete m_buf;
	m_buf = NULL;
}
bool TcpMessageBuilder::ResizeBuff(int nLen)
{
	int nReadLen = nLen + m_currentLen;
	if (nReadLen >= MAX_BUF_LEN)
	{
		memset(m_buf, 0, m_currentLen);
		return false;
	}
	else if (nReadLen <= m_bufLen)
	{
		return true;
	}
	else if (nReadLen>m_bufLen)
	{
		if ((nReadLen + ADD_BUFF_LEN) > MAX_BUF_LEN)
		{
			memset(m_buf, 0, m_bufLen);
			m_currentLen = 0;
			return false;
		}
		char* data = new char[nReadLen + ADD_BUFF_LEN];
		if (data == 0)
			return false;

		memset(data, 0, nReadLen + ADD_BUFF_LEN);
		memcpy(data, m_buf, m_currentLen);

		delete[] m_buf;
		m_buf = data;

		m_bufLen = nReadLen + ADD_BUFF_LEN;
		return true;
	}
	return false;
}

void TcpMessageBuilder::Close()
{
	if (m_buf != NULL)
	{

		delete[] m_buf;
	}
	m_buf = NULL;
	m_startPosition = 0;
	m_currentLen = 0;
	m_bufLen = 0;
}