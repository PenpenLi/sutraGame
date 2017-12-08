#ifndef __TCP_MESSAGE_BUILDER_H__
#define __TCP_MESSAGE_BUILDER_H__

#include <string>


#define TCP_MESSAGE_HEAD_LEN	(4)				//消息头长度
#define BUF_LEN					(819200)		//缓冲区的长度
#define MAX_BUF_LEN				(819200)		//缓冲区的最大长度

class TcpMessage
{
public:
	int length;
	char* data;
	TcpMessage(int length,char* data){
		this->length = length;
		this->data = data;
	}
	~TcpMessage(){
		if(data){
            //printf("delectTcp\n");
			delete[] data;
			data = NULL;
		}
	}
};


class TcpMessageBuilder
{
public:
	//向缓冲区写入数据。如果缓冲的数据，超过缓冲区的最大长度，则返回false，否则为true
	bool putData(char* data, int len);
	TcpMessage* buildMessage();
	TcpMessageBuilder();
	~TcpMessageBuilder();

	bool ResizeBuff(int nLen);
	void Close();

private:
	int m_bufLen;
	//数据缓冲区，此缓冲区首尾相连，循环使用。当缓冲区容量不够里，自动扩容
	char* m_buf;

	//缓冲区中有效数据区域的起始位置
	int m_startPosition;

	//缓冲区中，有效数据区域的长度
	int m_currentLen;

	//增加缓冲区
	bool increaseBuf();

	//缩小缓冲区
	bool decreaseBuf();
};


#endif