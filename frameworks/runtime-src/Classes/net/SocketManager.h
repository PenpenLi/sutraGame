#ifndef __SOCKET_MANAGER_EX_H__
#define __SOCKET_MANAGER_EX_H__
#include <string>
#include "Singleton.h"
#include "SocketListener.h"
#include "ODSocket.h"
#include "pthread.h"
#include "MessageQueue.h"
#include "signal.h"
#include "stdio.h"
#include "ByteBuffer.h"
#include "GameRunClassManager.h"

#define SOCKET_RECV_BUF_LEN (1024)		//socket数据接收缓存大小
#define SOCKET_ERROR_CONNECT_FAILED (1) //socket连接失败
#define SOCKET_ERROR_RECONNECT_FAILED (3) //socket重连失败
#define SOCKET_ERROR_DOMAIN_PARSE_FAILED (2) //域名解析错误，无法获得服务器ip

#define HEART_BEAT_INTERVAL (1000*60*1)		//心跳时间间隔

USING_NS_CC;

namespace Net
{
	enum Error
	{
		NoError,
		WrongProtocolType,
		InvalidPacketProtocol,
		WouldBlock,
		NotASocket,
		UnknownError
	};

	enum ConnectionState {
		DNSResolved,
		DNSFailed,
		Connected,
		ConnectFailed,
		Disconnected,
		ReconnectedFailed,
	};

	enum Protocol
	{
		UDPProtocol,
		TCPProtocol
	};
};

typedef int  NetSocket;
const NetSocket InvalidSocket = -1;

struct NetAddress
{
	int type;        ///< Type of address (IPAddress currently)

	/// Acceptable NetAddress types.
	enum
	{
		IPAddress,
	};

	unsigned char netNum[4];    ///< For IP:  sin_addr<br>
	unsigned char nodeNum[6];   ///< For IP:  Not used.<br>
	unsigned short  port;       ///< For IP:  sin_port<br>
};


class RawData
{
public:
	RawData();
	~RawData();

	void alloc(int nSize);
	char* mData;
	int  mSize;
};
typedef unsigned int		U32;
typedef unsigned short		U16;
typedef unsigned char		U8;
typedef int					S32;
struct Socket;

class SocketManagerController :public GameClass::GameRunClass,public Singleton<SocketManagerController>
{
public:
	SocketManagerController();

	void InitSocketThread();
	void StopSocketThread();


	void connectionNotifyEvent( Net::ConnectionState state);
	void PushEvent(NetEvent* pEvent);

	void PushError(int nError);
	void ProcessError(int nError);
	void PushConnectEvent(int nError);
	void Send(const char* data, const size_t& len);

	void InitNet(string ip, unsigned short nPort, string domain, SocketListener* listoner);

	virtual void process();
	virtual void shutdown();
	void Close();
	void SetConnected(bool bFlag);
	bool IsConnect();

	/*static SocketManagerController* getInstance();*/

	string mIp;
	U16    mPort;

	pthread_t m_netThread;
	SocketListener* mlistener;

	AsyncNetEvent m_ToGameThreadQueue;
	bool mReconnected;
	bool mStartThread;
	//static SocketManagerController* mInstance;
	bool mbConnected;
};

#define SockController  SocketManagerController::getInstance()
class SocketManager :public Singleton<SocketManager>
{
public:
	SocketManager();
	virtual ~SocketManager();


	
	//只有以下三个函数支持同步，可跨线程调用
	void addMessageToReceiveQueue(Message m);
	Message getAndRemoveMessageFromReceiveQueue();
	void ProcessEvent();
	void PushEvent(NetEvent* pEvent);

	
	static void* RunThread(void* data);
	void Run();

	void StartUp();
	void Shutdown();


	

	void closeConnectTo();
	Net::Error closeSocket(NetSocket sock);
	Net::Error getLastError();

	void notifyEvent(Socket* sock, RawData& data);
	Net::Error recv(NetSocket socket, U8 *buffer, int bufferSize, int  *bytesRead);
	NetSocket openConnectTo(const char *addressString, U16 );

	Socket* addPolledSocket(NetSocket& fd, S32 state, const char* remoteAddr = NULL, S32 port = -1);

	NetSocket openSocket();
	Net::Error setBlocking(NetSocket socket, bool blockingIO);


	Net::Error send(NetSocket socket, const U8 *buffer, S32 bufferSize);
	Net::Error sendByteBuf(ByteBuffer buf);
	Net::Error sendByteBuf(const char* buf, const size_t& len);

	void reconnect(std::string ip, unsigned short port);
	bool reconnect();//socket重连

	void disconnect();

	bool Init(const char* pIp, unsigned short pPort, const char* domain);


	bool isConnected();


	bool IsRun();
	void setRun(bool bRun);
	


private:


	AsyncMessageQueue mRespQueue;

	AsyncNetEvent m_ToNetThreadQueue;
	
	Socket* mCurrSocket;
	static bool mInit;

	
	bool mRun;



};

#define  SockMgr			SocketManager::getInstance()

#endif