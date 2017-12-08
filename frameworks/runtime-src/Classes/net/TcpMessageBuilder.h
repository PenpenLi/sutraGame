#ifndef __TCP_MESSAGE_BUILDER_H__
#define __TCP_MESSAGE_BUILDER_H__

#include <string>


#define TCP_MESSAGE_HEAD_LEN	(4)				//��Ϣͷ����
#define BUF_LEN					(819200)		//�������ĳ���
#define MAX_BUF_LEN				(819200)		//����������󳤶�

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
	//�򻺳���д�����ݡ������������ݣ���������������󳤶ȣ��򷵻�false������Ϊtrue
	bool putData(char* data, int len);
	TcpMessage* buildMessage();
	TcpMessageBuilder();
	~TcpMessageBuilder();

	bool ResizeBuff(int nLen);
	void Close();

private:
	int m_bufLen;
	//���ݻ��������˻�������β������ѭ��ʹ�á�������������������Զ�����
	char* m_buf;

	//����������Ч�����������ʼλ��
	int m_startPosition;

	//�������У���Ч��������ĳ���
	int m_currentLen;

	//���ӻ�����
	bool increaseBuf();

	//��С������
	bool decreaseBuf();
};


#endif