#include "SocketManager.h"
#include "ODSocket.h"
#include "TcpMessageBuilder.h"
#include "MessageQueue.h"
#include <string>
#include "cocos2d.h"
#include "NetDefine.h"
#include "NetEvent.h"
#include "NetpackHelper.h"

#ifdef WIN32
#define ioctl ioctlsocket

typedef S32 socklen_t;

#endif // WIN32


using namespace std;
USING_NS_CC;



#ifndef MAXPACKETSIZE
#define MAXPACKETSIZE 8196
#endif



enum SocketState
{
	InvalidState,
	Connected,
	ConnectionPending,
	Listening,
	NameLookupRequired
};

struct Socket
{
	Socket()
	{
		fd = InvalidSocket;
		state = InvalidState;
		remoteAddr[0] = 0;
		remotePort = -1;
	}

	NetSocket fd;
	int state;
	char remoteAddr[256];
	int remotePort;
	TcpMessageBuilder mBuilder;
};

#if defined(WIN32)
static const char* strerror_wsa(int code)
{
	switch (code)
	{
#define E( name ) case name: return #name;
		E(WSANOTINITIALISED);
		E(WSAENETDOWN);
		E(WSAEADDRINUSE);
		E(WSAEINPROGRESS);
		E(WSAEALREADY);
		E(WSAEADDRNOTAVAIL);
		E(WSAEAFNOSUPPORT);
		E(WSAEFAULT);
		E(WSAEINVAL);
		E(WSAEISCONN);
		E(WSAENETUNREACH);
		E(WSAEHOSTUNREACH);
		E(WSAENOBUFS);
		E(WSAENOTSOCK);
		E(WSAETIMEDOUT);
		E(WSAEWOULDBLOCK);
		E(WSAEACCES);
#undef E
default:
	return "Unknown";
	}
}
#endif

//SocketManagerController* SocketManagerController::mInstance = NULL;

SocketManagerController::SocketManagerController()
{
	mReconnected = false;
	mStartThread = false;
	mlistener = NULL;
	mPort = 0;
	mbConnected = false;
}

//SocketManagerController* SocketManagerController::getInstance()
//{
//	if (mInstance == NULL)
//		mInstance = new SocketManagerController();
//	return mInstance;
//}
void SocketManagerController::InitSocketThread()
{
	if (mStartThread)
		return;
	mStartThread = true;
	pthread_create(&m_netThread, NULL, SocketManager::RunThread, SocketManager::getInstance());
}
void SocketManagerController::StopSocketThread()
{
		int status = 0;
		SockMgr->setRun(false);
		Sleep(100);
		status = pthread_kill(m_netThread, 0);
		
		if(status == ESRCH){
	        ////CCLOG("\nthe thread netThread has exit...\n");
		}
		else if(status == EINVAL)
		{
	        ////CCLOG("\nSend signal to thread netThread fail.\n");
		}
		else
		{
			////CCLOG("\nthe thread netThread is still alive.\n");
		}

		if (mlistener != NULL)
			mlistener->release();
		mlistener = NULL;

		
}

void SocketManagerController::connectionNotifyEvent(Net::ConnectionState state)
{
	if (mlistener == NULL)
		return;
	if (state == Net::Connected)
	{
		if (mReconnected)
			mlistener->onReconnectOpen();
		else
			mlistener->onOpen();
		SetConnected(true);
	}
	else if (state == Net::ConnectFailed || state == Net::DNSFailed)
	{
		mlistener->onError(SOCKET_ERROR_CONNECT_FAILED);
	}
	else if (state == Net::Disconnected)
	{
		mlistener->onError(SOCKET_ERROR_CONNECT_FAILED);
		SetConnected(false);
	}
	else if (state == Net::ReconnectedFailed)
	{
		mlistener->onReconnectError(SOCKET_ERROR_RECONNECT_FAILED);
		SetConnected(false);
	}


}
void SocketManagerController::PushEvent(NetEvent* pEvent)
{
	m_ToGameThreadQueue.push(pEvent);
}
void SocketManagerController::PushError(int nError)
{
	ErrorNotifyEvent* pEvent = new ErrorNotifyEvent();
	pEvent->nEventError = nError;
	PushEvent(pEvent);
}
void SocketManagerController::ProcessError(int nError)
{
	if (mlistener == NULL)
		return;
	mlistener->onError(nError);
}
void SocketManagerController::PushConnectEvent(int nError)
{
	ConnectNotifyEvent* pEvent = new ConnectNotifyEvent();
	pEvent->nEventError = nError;
	PushEvent(pEvent);
}
void SocketManagerController::Send(const char* data, const size_t& len)
{
	if (data == NULL)
		return;
	SendNetEvent* pEvent = new SendNetEvent();
	pEvent->message = data;
	pEvent->len = len;
	SocketManager::getInstance()->PushEvent(pEvent);
}
void SocketManagerController::InitNet(string ip, unsigned short nPort, string domain, SocketListener* listoner)
{
	if (listoner == NULL)
		return;
	InitNetEvent* pEvent = new InitNetEvent();
	pEvent->ip = ip;
	pEvent->domain = domain;
	pEvent->port = nPort;
	
	if (mlistener != listoner)
	{
		mlistener = listoner;
		listoner->retain();
	}
	mReconnected = false;
	m_ToGameThreadQueue.Clear();
	SockMgr->PushEvent(pEvent);
	InitSocketThread();

	Director::getInstance()->addCGameRunClass(this);
	
	
}
void SocketManagerController::process()
{
	NetEvent* pEvent = m_ToGameThreadQueue.pop();
	while (pEvent)
	{
		pEvent->Process();
		delete pEvent;
		pEvent = m_ToGameThreadQueue.pop();
	}
	if (mlistener != NULL)
		mlistener->dispatchResponseCallbacks(0);
}
void SocketManagerController::shutdown()
{
	StopSocketThread();
}
void SocketManagerController::Close()
{
	if (mlistener != NULL)
		return;
	mlistener->onClose();
}

void SocketManagerController::SetConnected(bool bFlag)
{
	mbConnected = bFlag;
}
bool SocketManagerController::IsConnect()
{
	return mbConnected;
}


RawData::RawData()
{
	mData = 0;
	mSize = 0;
}
RawData::~RawData()
{
	if (mData != NULL)
		delete[] mData;
	mData = NULL;
	mSize = 0;
}
void RawData::alloc(int nSize)
{
	mData = new char[nSize];
	mSize = nSize;
}



bool netSocketWaitForWritable(NetSocket fd, int timeoutMs)
{
	fd_set writefds;
	timeval timeout;

	FD_ZERO(&writefds);
	FD_SET(fd, &writefds);

	timeout.tv_sec = timeoutMs / 1000;
	timeout.tv_usec = (timeoutMs % 1000) * 1000;

	if (select(fd + 1, NULL, &writefds, NULL, &timeout) > 0)
		return true;

	return false;
}

bool SocketManager::mInit = false;
SocketManager::SocketManager()
{
	mCurrSocket = new Socket();
	StartUp();
	mRun = true;

}
void SocketManager::setRun(bool bRun)
{
	mRun = bRun;
}
SocketManager::~SocketManager()
{
	closeConnectTo();
	if (mCurrSocket != NULL)
		delete mCurrSocket;
	mCurrSocket = NULL;
	Shutdown();
}
void* SocketManager::RunThread(void* data)
{
	SocketManager* sockManager = (SocketManager*)data;
	if (data == NULL)
		return 0;
	while (sockManager->IsRun())
	{
		sockManager->Run();
		Sleep(15);
	}
	return 0;
}
void SocketManager::StartUp()
{
	if (!mInit)
	{
#ifdef WIN32
		WSADATA wsaData;
		WORD version = MAKEWORD(2, 0);
		int ret = WSAStartup(version, &wsaData);//win sock start up
		if (ret)
			return;
#endif
		mInit = true;
	}
}
void SocketManager::Shutdown()
{
#ifdef WIN32
	WSACleanup();
#endif
	return;
}

Socket* SocketManager::addPolledSocket(NetSocket& fd, S32 state,const char* remoteAddr, S32 port)
{
	if (mCurrSocket == NULL)
		return NULL;
	closeConnectTo();
	mCurrSocket->fd = fd;
	mCurrSocket->state = state;
	if (remoteAddr)
	{
		int nSize = sizeof(mCurrSocket->remoteAddr);
		memset(mCurrSocket->remoteAddr, 0, nSize);
		int nLen = 128 > nSize ? nSize : 128;
		strncpy(mCurrSocket->remoteAddr, remoteAddr, nLen);
	}
	if (port != -1)
		mCurrSocket->remotePort = port;
	return mCurrSocket;
}

void SocketManager::reconnect(std::string ip, unsigned short port)
{


	//CCLOG("SocketManager::reconnect");

	if (mCurrSocket == NULL)
		mCurrSocket = new Socket();

	mCurrSocket->mBuilder.Close();

	NetSocket resSocket = openConnectTo(ip.c_str(), port);
	if (resSocket)
	{
		mCurrSocket->remotePort = port;
		mCurrSocket->fd = resSocket;

		int nSize = sizeof(mCurrSocket->remoteAddr);
		memset(mCurrSocket->remoteAddr, 0, nSize);
		strcpy(mCurrSocket->remoteAddr, ip.c_str());

		//CCLOG("SocketManager::reconnect -> succ ip=%s port=%d\n", ip.c_str(), port);

	}
	else
	{
		//CCLOG("SocketManager::reconnect -> failed ip=%s port=%d\n", ip.c_str(), port);
		SockController->PushConnectEvent(Net::ReconnectedFailed);

	}
}

bool SocketManager::reconnect()
{
	if (mCurrSocket == NULL)
	{
		//CCLOG("SocketManager::reconnect -> failed ip or port is null\n");
		return false;
	}
	reconnect(mCurrSocket->remoteAddr, mCurrSocket->remotePort);
	return true;
}

void SocketManager::disconnect()
{
		//CCLOG("SocketManager::disconnect");
	
		//mlistener->onClose();
		closeConnectTo();
}

bool SocketManager::Init(const char* pIp, unsigned short pPort, const char* domain)
{
	//创建并初始化socket
	if (mCurrSocket == NULL)
		return false;
	mCurrSocket->mBuilder.Close();

	

	string strIp(pIp);
	unsigned short port = pPort;

	if (strIp.empty())
	{
		//根据域名获取ip

		struct hostent *hp;
		struct in_addr in;
		//CCLOG("domainName=%s\n", domain);
		hp = gethostbyname(domain);
		if (!hp)
		{
			//CCLOG("SocketManager::init -> domain parse failed\n");

			SockController->PushError(SOCKET_ERROR_DOMAIN_PARSE_FAILED);

			//pListener->onError(SOCKET_ERROR_DOMAIN_PARSE_FAILED);
			return false;
		}

		memcpy(&in.s_addr, hp->h_addr, 4);
		strIp = inet_ntoa(in);

		//CCLOG("ip=%s port=%d\n", strIp.c_str(), port);
	}
	

	mCurrSocket->remotePort = port;

	NetSocket resSocket = openConnectTo(strIp.c_str(), port);

	mCurrSocket->remotePort = port;
	mCurrSocket->fd = resSocket;

	int nSize = sizeof(mCurrSocket->remoteAddr);
	memset(mCurrSocket->remoteAddr, 0, nSize);
	strcpy(mCurrSocket->remoteAddr, strIp.c_str());


	if (resSocket == InvalidSocket)
	{
		//CCLOG("SocketManager::init -> failed ip=%s port=%d\n", strIp.c_str(), port);
		SockController->PushError(SOCKET_ERROR_CONNECT_FAILED);
		//pListener->onError(SOCKET_ERROR_CONNECT_FAILED);
		return false;
	}
	return true;
}


void SocketManager::Run()
{

	ProcessEvent();
	int  optval;
	socklen_t optlen = sizeof(int);
	int bytesRead;
	Net::Error err;
	bool removeSock = false;
	NetSocket incoming = InvalidSocket;
	int out_h_length = 0;

	////CCLOG("\n SocketManager::Run \n");

	 


		removeSock = false;
		switch (mCurrSocket->state)
		{
		case ::InvalidState:

			//CCLOG("\nError, InvalidState socket in polled sockets  list\n");
			break;
		case ::ConnectionPending:
			// see if it is now connected
//#ifdef TORQUE_OS_XENON
//			// WSASetLastError has no return value, however part of the SO_ERROR behavior
//			// is to clear the last error, so this needs to be done here.
//			if ((optval = _getLastErrorAndClear()) == -1)
//#else
			if (getsockopt(mCurrSocket->fd, SOL_SOCKET, SO_ERROR,
				(char*)&optval, &optlen) == -1)
//#endif
			{
				//CCLOG("Error getting socket options: %s", strerror(errno));
				SockController->PushConnectEvent(Net::ConnectFailed);
				removeSock = true;
			}
			else
			{
				if (optval == EINPROGRESS)
					// still connecting...
					break;

				if (optval == 0)
				{
					// poll for writable status to be sure we're connected.
					bool ready = netSocketWaitForWritable(mCurrSocket->fd, 0);
					if (!ready)
						break;

					mCurrSocket->state = ::Connected;
					SockController->PushConnectEvent(Net::Connected);
				}
				else
				{
					// some kind of error
					//CCLOG("\nError connecting: %s\n", strerror(errno));
					SockController->PushConnectEvent(Net::ConnectFailed);
					mCurrSocket->state = Net::ConnectFailed;
					removeSock = true;
				}
			}
			break;
		case ::Connected:

			// try to get some data
			bytesRead = 0;

			
			static unsigned char recvBuff[MAXPACKETSIZE];
			recvBuff[0] = 0;
			err = recv(mCurrSocket->fd, recvBuff, MAXPACKETSIZE-1, &bytesRead);

			
			if (err == Net::NoError)
			{
				if (bytesRead > 0)
				{
					RawData readBuff;
					readBuff.alloc(MAXPACKETSIZE);
					memcpy(readBuff.mData, recvBuff, bytesRead);
					// got some data, post it
					readBuff.mSize = bytesRead;
					notifyEvent(mCurrSocket, readBuff);
				}
				else
				{
					// ack! this shouldn't happen
					//if (bytesRead < 0)
						//CCLOG("\nUnexpected error on socket: %s\n", strerror(errno));

					// zero bytes read means EOF
					SockController->PushConnectEvent(Net::Disconnected);

					removeSock = true;
					mCurrSocket->state = Net::Disconnected;

				}
			}
			else if (err != Net::NoError && err != Net::WouldBlock)
			{
				//CCLOG("\nError reading from socket: %s\n", strerror(errno));
				SockController->PushConnectEvent(Net::Disconnected);
				removeSock = true;
				mCurrSocket->state = Net::Disconnected;
			}
			break;
		case ::NameLookupRequired:
//			// is the lookup complete?
//			if (!gNetAsync.checkLookup(
//				currentSock->fd, out_h_addr, &out_h_length,
//				sizeof(out_h_addr)))
//				break;
//
//			unsigned int  newState;
//			if (out_h_length == -1)
//			{
//				//CCLOG("\nDNS lookup failed: %s\n", currentSock->remoteAddr);
//				newState = Net::DNSFailed;
//				removeSock = true;
//			}
//			else
//			{
//				// try to connect
//				memcpy(&(ipAddr.sin_addr.s_addr), out_h_addr, out_h_length);
//				ipAddr.sin_port = currentSock->remotePort;
//				ipAddr.sin_family = AF_INET;
//				if (::connect(currentSock->fd, (struct sockaddr *)&ipAddr,
//					sizeof(ipAddr)) == -1)
//				{
//					int errorCode;
//#if defined(WIN32)
//					errorCode = WSAGetLastError();
//					if (errorCode == WSAEINPROGRESS || errorCode == WSAEWOULDBLOCK)
//#else
//					errorCode = errno;
//					if (errno == EINPROGRESS)
//#endif
//					{
//						newState = Net::DNSResolved;
//						currentSock->state = ::ConnectionPending;
//					}
//					else
//					{
//						const char* errorString;
//#ifdef WIN32
//						errorString = strerror_wsa(errorCode);
//#else
//						errorString = strerror(errorCode);
//#endif
//						//CCLOG("\nError connecting to %s: %s (%i)\n",
//							currentSock->remoteAddr, errorString, errorCode);
//						newState = Net::ConnectFailed;
//						removeSock = true;
//					}
//				}
//				else
//				{
//					newState = Net::Connected;
//					currentSock->state = Net::Connected;
//				}
//			}
//
//			connectionNotifyEvent(currentSock->fd, (Net::ConnectionState)newState);
			break;
			/*	case ::Listening:
					NetAddress incomingAddy;

					incoming = Net::accept(currentSock->fd, &incomingAddy);
					if (incoming != InvalidSocket)
					{
					setBlocking(incoming, false);
					addPolledSocket(incoming, Connected);
					Net::smConnectionAccept.trigger(currentSock->fd, incoming, incomingAddy);
					}
					break;*/
		}

		// only increment index if we're not removing the connection,  since
		// the removal will shift the indices down by one
		if (removeSock)
		{
			closeConnectTo();
		}

}

void SocketManager::closeConnectTo()
{

	if (mCurrSocket == NULL)
		return;

	if (mCurrSocket->fd!=InvalidSocket)
		closeSocket(mCurrSocket->fd);
	mCurrSocket->fd = InvalidSocket;
	mCurrSocket->mBuilder.Close();
}

Net::Error SocketManager::closeSocket(NetSocket sock)
{
	if (sock != InvalidSocket)
	{
		if (!closesocket(sock))
			return Net::Error::NoError;
		else
			return getLastError();
	}
	else
		return Net::Error::NotASocket;
}

Net::Error SocketManager::getLastError()
{
#if defined(WIN32)
	int  err = WSAGetLastError();
	switch (err)
	{
	case 0:
		return Net::NoError;
	case WSAEWOULDBLOCK:
		return Net::WouldBlock;
	default:
		return Net::UnknownError;
	}
#else
	int err = errno;
	if (err == EAGAIN || err == EINPROGRESS || err==EALREADY || err==EINTR || err==EISCONN)
		return Net::WouldBlock;
	if (err == 0)
		return Net::NoError;
	return Net::UnknownError;
#endif
}


void SocketManager::notifyEvent(Socket* sock, RawData& data)
{
	if (sock == NULL)
		return;
	const size_t max_st_size = 4096;
	char *stTData = new char[max_st_size];
	memcpy(stTData, data.mData, data.mSize);
	stTData[data.mSize] = 0;

	Message m;
	m.code = MESSAGE_TYPE_RECEIVE_NEW_MESSAGE;
	m.len = data.mSize;
	m.message = stTData;
	m.free = true;
	//m.message = "newmsg";
	//m.dict = NetpackHelper::bufToLuaValue(message->data, message->length);
	SockMgr->addMessageToReceiveQueue(m);//将消息放到待处理队列

// 	TcpMessage* message = sock->mBuilder.buildMessage();
// 	while (message)
// 	{
// 		if (message->length == 0)
// 		{
// 			Message m;
// 			m.code = MESSAGE_TYPE_RECEIVE_HEART_BEAT;
// 			m.message = "heart beat";
// 			SockMgr->addMessageToReceiveQueue(m);//将消息放到待处理队列
// 		}
// 		else
// 		{
// 
// 			Message m;
// 			m.code = MESSAGE_TYPE_RECEIVE_NEW_MESSAGE;
// 			m.message = message->data;
// 			//m.message = "newmsg";
// 			//m.dict = NetpackHelper::bufToLuaValue(message->data, message->length);
// 			SockMgr->addMessageToReceiveQueue(m);//将消息放到待处理队列
// 
// 			//if (mlistener!=NULL)
// 				//mlistener->onReceiveNewData(message->data, message->length);
// 		}
// 		delete message;
// 		message = NULL;
// 		message = sock->mBuilder.buildMessage();
// 
 }


Net::Error SocketManager::recv(NetSocket socket, U8 *buffer, int bufferSize, int  *bytesRead)
{
	*bytesRead = ::recv(socket, (char*)buffer, bufferSize, 0);
	if (*bytesRead == -1)
		return getLastError();
	return Net::Error::NoError;
}


NetSocket SocketManager::openConnectTo(const char *addressString, U16 nPort)
{



	U16 port = htons(nPort);

	NetSocket sock = openSocket();
	setBlocking(sock, false);

	sockaddr_in ipAddr;
	memset(&ipAddr, 0, sizeof(ipAddr));
	ipAddr.sin_addr.s_addr = inet_addr(addressString);

	if (ipAddr.sin_addr.s_addr != INADDR_NONE)
	{
		ipAddr.sin_port = port;
		ipAddr.sin_family = AF_INET;
		if (::connect(sock, (struct sockaddr *)&ipAddr, sizeof(ipAddr)) == -1)
		{
			int err = getLastError();
			if (err != Net::WouldBlock)
			{
				////CCLOG("Error connecting %s: %s",addressString, strerror(err));
				::closesocket(sock);
				sock = InvalidSocket;
			}
		}
		if (sock != InvalidSocket)
		{
			// add this socket to our list of polled sockets
			addPolledSocket(sock, ConnectionPending);
		}
	}
	else
	{
		// need to do an asynchronous name lookup.  first, add the socket
		// to the polled list
		addPolledSocket(sock, NameLookupRequired, addressString, port);
		// queue the lookup
		//gNetAsync.queueLookup(remoteAddr, sock);
	}

	return sock;
}
NetSocket SocketManager::openSocket()
{
	NetSocket retSocket;
	retSocket = socket(AF_INET, SOCK_STREAM, 0);

	if (retSocket == InvalidSocket)
		return InvalidSocket;
	else
		return retSocket;
}


Net::Error SocketManager::setBlocking(NetSocket socket, bool blockingIO)
{
	unsigned long notblock = !blockingIO;
	S32 error = ioctl(socket, FIONBIO, &notblock);
	if (!error)
		return Net::Error::NoError;
	return getLastError();
}

Net::Error SocketManager::send(NetSocket socket, const U8 *buffer, S32 bufferSize)
{
	errno = 0;
	S32 bytesWritten = ::send(socket, (const char*)buffer, bufferSize, 0);
	if (bytesWritten == -1)
#if defined(WIN32)
		////CCLOG("\nCould not write to socket. Error: %s\n", strerror_wsa(WSAGetLastError()));
#else
		////CCLOG("\nCould not write to socket. Error: %s\n", strerror(errno));
#endif

	return getLastError();
}

Net::Error SocketManager::sendByteBuf(ByteBuffer buf)
{
	if (mCurrSocket == NULL)
		return Net::UnknownError;

	return send(mCurrSocket->fd,buf.contents(), buf.size());
}
Net::Error SocketManager::sendByteBuf(const char* buf, const size_t& len)
{
	if (mCurrSocket == NULL)
		return Net::UnknownError;

	return send(mCurrSocket->fd,(const U8*)buf, len);
}

bool SocketManager::isConnected()
{
	if (mCurrSocket == NULL || mCurrSocket->fd == InvalidSocket)
		return false;

	return mCurrSocket->state == Net::Connected;

}
void SocketManager::addMessageToReceiveQueue(Message m)
{
	mRespQueue.push(m);
}
Message SocketManager::getAndRemoveMessageFromReceiveQueue()
{
	Message m = mRespQueue.pop();
	return m;
}

bool SocketManager::IsRun()
{
	return mRun;
}

void SocketManager::ProcessEvent()
{
	NetEvent* pEvent = m_ToNetThreadQueue.pop();
	while (pEvent)
	{
		pEvent->Process();
		pEvent = m_ToNetThreadQueue.pop();
	}
}
void SocketManager::PushEvent(NetEvent* pEvent)
{
	m_ToNetThreadQueue.push(pEvent);
}



