#include "CGame.h"
//#include "ImageAsyncLoader.h"
//#include "lua_cocos2dx_extensions_manual.h"
#include "CCLuaEngine.h"
#include "CCLuaStack.h"
#include <string.h>

#include "net/SocketListener.h"
#include "net/SocketManager.h"

#include "net/NetpackHelper.h"

//#include "Sqlite3/sqlite3.h"

#include "network/HttpClient.h"
#include "network/HttpRequest.h"

#include "net/HttpManager.h"
#include "SDKUtils.h"
#include "net/NetEvent.h"



#if (CC_TARGET_PLATFORM == CC_PLATFORM_MAC)
#include "MacAddress/MacAddress.h"
#include "MacAddress/md5.h"
#elif (CC_TARGET_PLATFORM == CC_PLATFORM_WIN32)
#include "../proj.win32/MacAddress.h"
#include "MacAddress/md5.h"
//#include <jni.h>
#include "platform/android/jni/JniHelper.h"
#elif (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
#include "AndroidUtils.h"
#include "MacAddress/md5.h"
#include <jni.h>
#include "platform/android/jni/JniHelper.h"

#elif (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
#include "../proj.ios_mac/ios/BFIOSUtils.h"
#include "MacAddress/MacAddress.h"
#endif

using namespace cocos2d;

using namespace cocos2d::network;

class LuaSocketListenerDelegate: public SocketListenerDelegate
{
public:
    ~LuaSocketListenerDelegate(){}
    
    void onSocketEvent(SocketListener* socketListener,int code,const char* data)
    {
        if (NULL != socketListener)
        {
            int nHandler = socketListener->getScriptHandler();
            if (0 != nHandler)
            {
                
				LuaEngine* pEngine = (LuaEngine*)ScriptEngineManager::getInstance()->getScriptEngine();
				LuaStack* luaStack= pEngine->getLuaStack();
				luaStack->pushInt(code);
				luaStack->pushString(data);
				luaStack->executeFunctionByHandler(nHandler, 2);
            }
        }
    }
};

//��ʼ��socket
void CGame::NetInitRaw(std::string ip,unsigned int port,std::string domain,int funcID)
{
	CCLOG("NetInitRaw:ip:%s port %d funcID:%d",ip.c_str(),port,funcID);

	static SocketListener *mSocketListener = NULL;
	if (mSocketListener == NULL)
	{
		mSocketListener = new SocketListener();
		LuaSocketListenerDelegate *mLuaSocketListenerDelegate = new LuaSocketListenerDelegate();
		mSocketListener->registerScriptHandler(funcID);
		mSocketListener->setSocketListenerDelegate(mLuaSocketListenerDelegate);
	}


	SockController->InitNet(ip, port, domain, mSocketListener);

	//SocketManager::getInstance()->Init(ip.c_str(), port, domain.c_str(), mSocketListener);
}

void CGame::NetDisconnect()
{
	DisconnectNetEvent* pEvent = new DisconnectNetEvent();
	SockMgr->PushEvent(pEvent);
}

//socket����
void CGame::NetReconnectRaw()
{
	ReconnectNetEvent* pEvent = new ReconnectNetEvent();
	pEvent->bNeedIP = false;

	SockMgr->PushEvent(pEvent);
	//SockMgr->reconnect();
}

void CGame::NetReconnectWithIP(std::string ip,unsigned int port)
{
	ReconnectNetEvent* pEvent = new ReconnectNetEvent();
	pEvent->ip = ip;
	pEvent->nPort = port;
	pEvent->bNeedIP = true;
	SockMgr->PushEvent(pEvent);
	SockController->mReconnected = true;
	//SockMgr->reconnect(ip, port);
}

void CGame::NetReqRaw(const char* value, int sz)
{
	//CCLOG("CGame::NetReqRaw:	length=%ld  %s",strlen(value),value);

	//    rapidjson::Document doc;
	//    doc.Parse<0>(value);
	//    
	//    if (doc.HasParseError()) {
	//        CCLOG("����JSON����");
	//    }else if(doc.IsObject()){
	//        const rapidjson::Value &n = doc["name"];
	//        
	//        CCLOG("�Ƕ���,%s",n.GetString());
	//        
	//    }

	//ȥ��\0�ַ�����̬�����ڴ棬�ײ����ڴ���Ƭ
	const size_t max_len = 4096;
	char *pBuf = new char[max_len];
	size_t bufLen = 0;
	size_t vs = sz;
	//if (vs>2 && value[0] == '"' && value[vs-1] == '"')
	if(false)
	{
		for(int i=1;i<vs-1;++i)
		{
			if (value[i] == '\\' && value[i+1] == '0' && value[i+2] == '0' && value[i+3] == '0')
			{
				pBuf[bufLen++] = 0;
				i+=3;
			}
			else
			{
				pBuf[bufLen++] = value[i];
			}
		}
		
	}
	else
	{
		memcpy(pBuf, value, vs);
		bufLen = vs;
	}
	SockController->Send(pBuf, bufLen);
	// SocketManager::getInstance()->sendByteBuf(NetpackHelper::converToByteBuf(value));



	//    rapidjson::document

	//    SocketManager::addMessageToSendQueue(value);
}

const char *CGame::getUUID()
{
    __String *uuid = __String::create("");
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    uuid = __String::create(BFIOSUtils::getUUID());
#elif (CC_TARGET_PLATFORM == CC_PLATFORM_MAC)
//    uuid = __String::create("abc");
    
    MD5 md5;
    md5.update(getMacAddress()->getCString());
    uuid = __String::create(md5.toString().c_str());
#elif (CC_TARGET_PLATFORM == CC_PLATFORM_WIN32)
	 /*GetMacByNetBIOS;*/
	std::string macaddress;
	if (GetMacByNetBIOS(macaddress))
	{
		MD5 md5;
		md5.update(macaddress.c_str());
		uuid = __String::create(md5.toString().c_str());
	}
#elif (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)	
   	MD5 md5;
	AndroidUtils androidUt ;
    md5.update(androidUt.getDeviceID());
    uuid = __String::create(md5.toString().c_str()); 
#endif

    return uuid->getCString();
}

void CGame::initDataBase(const char* dbfilePath,const char *dbFileName)
{
	//std::string packFilePath = fu->fullPathForFilename(dbFileName);
	//std::string docFilePath = fu->getWritablePath();
	
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    BFIOSUtils::copyFileToDocument(dbfilePath,dbFileName);
#elif (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
	FileUtils *fu = FileUtils::getInstance();
	string packFilePath = fu->fullPathForFilename(dbFileName);
	string docFilePath = fu->getWritablePath();
	//  packC = assets/res/dzl.db 
	const char * packC = packFilePath.data();	
	const char *docC = docFilePath.data();
	char cat[100]={0};
	strcat(cat,docC);
	strcat(cat,dbfilePath);
	strcat(cat,"/");
	CCLOG("initDataBase  %s   %s  %s",dbfilePath,dbFileName,cat);
	AndroidUtils androidUt ;
	// Ŀ¼,�ļ���
	androidUt.copyDB(cat,dbFileName);
	
#endif
}

bool CGame::isConnected()
{
	return SocketManager::getInstance()->isConnected();
}

void CGame::HttpReqGet(std::string address, int callbackfunc,int timeout)
{
    log("request:%s",address.c_str());
    
    char buf[10];
    sprintf(buf, "%d", callbackfunc);
    string callbackTag = buf;
    
    auto *hm = HttpManager::getInstance();
    
    HttpClient *hc = HttpClient::getInstance();
//    hc->setTimeoutForConnect(2);
//    hc->setTimeoutForRead(2);
    
    HttpRequest *req = new HttpRequest();
    req->setUrl(address.c_str());
    req->setRequestType(HttpRequest::Type::POST);
	//�ַ�����ȡ
	size_t iPos = address.find("?");
	std::string s3 = address.substr(iPos+1, address.length()-iPos-1);
	

    req->setResponseCallback(CC_CALLBACK_2(HttpManager::onHttpRequestCompleted, hm));
	const char* postData =s3.c_str();  
	req->setRequestData(postData, strlen(postData));  

    req->setTag(callbackTag.c_str());
    
    hc->send(req);
    
    req->release();
}

void CGame::HttpSetReadTimeOut(int timeout)
{
    HttpClient::getInstance()->setTimeoutForRead(timeout);
}

void CGame::HttpSetConnectTimeOut(int timeout)
{
    HttpClient::getInstance()->setTimeoutForConnect(timeout);
}

void CGame::SDKInit(int init_finish_funcid,int login_success_funcid,int login_fail_funcid)

{
	
	//LuaEngine* pEngine = (LuaEngine*)ScriptEngineManager::getInstance()->getScriptEngine();
	//LuaStack* luaStack= pEngine->getLuaStack();
	//luaStack->pushInt(3);
	//luaStack->pushString("hello");
	//luaStack->executeFunctionByHandler(init_finish_funcid, 2);

	auto *sdk = SDKUtils::getInstance();
	sdk->setCallbackFuncID(init_finish_funcid,login_success_funcid,login_fail_funcid);

#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)

#elif (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
	
#endif
}

void CGame::SDKDoStart()
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_WIN32 || CC_TARGET_PLATFORM == CC_PLATFORM_MAC)
	auto *sdk = SDKUtils::getInstance();
	sdk->initFinishCallback("0","0");
#elif (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    //auto *sdk = SDKUtils::getInstance();
    //sdk->initFinishCallback("0","0");
	BFIOSUtils::sdk_init();

#elif (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
	AndroidUtils androidUt;
	androidUt.sdk_init();
#endif
}

void CGame::SDKDoLogin()
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    BFIOSUtils::sdk_login();
#elif (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
	AndroidUtils androidUt;
	androidUt.sdk_dologin();
#endif
}

void CGame::SDKDoPay(std::string payinfo)
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    BFIOSUtils::sdk_dopay(payinfo);
#elif (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
	AndroidUtils androidUt;
	androidUt.sdk_dopay(payinfo.c_str());
#endif
}

void CGame::SDKDoUserInfo(std::string userinfojson)
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    BFIOSUtils::sdk_doUserInfo(userinfojson);
#elif (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    
#endif
}


void CGame::OpenWeb(const char *url)
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    BFIOSUtils::app_Update(url);
#elif (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    AndroidUtils::openWebView(url);
#elif (CC_TARGET_PLATFORM == CC_PLATFORM_WIN32)
   
#elif (CC_TARGET_PLATFORM == CC_PLATFORM_MAC )
    
#endif
}

const char *CGame::getAppVersion()
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    return BFIOSUtils::getAppVersion();
#elif (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    return AndroidUtils::getPackageVersion();
#elif (CC_TARGET_PLATFORM == CC_PLATFORM_WIN32)
    return "1.0";
#elif (CC_TARGET_PLATFORM == CC_PLATFORM_MAC )
    return "1.0";
#endif
}

const char *CGame::getDeviceModel()
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    return BFIOSUtils::getDeviceModel();
#elif (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    return AndroidUtils::getDeviceModel();
#elif (CC_TARGET_PLATFORM == CC_PLATFORM_WIN32)
    return "PC";
#elif (CC_TARGET_PLATFORM == CC_PLATFORM_MAC )
    return "Mac";
#endif
}

const char *CGame::getOSName()
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    return BFIOSUtils::getOSName();
#elif (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    return "Android";
#elif (CC_TARGET_PLATFORM == CC_PLATFORM_WIN32)
    return "Windows";
#elif (CC_TARGET_PLATFORM == CC_PLATFORM_MAC )
    return "OS_X";
#endif
}

const char *CGame::getOSVersion()
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    return BFIOSUtils::getOSVersion();
#elif (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    return AndroidUtils::getDeviceOsVersion();
#elif (CC_TARGET_PLATFORM == CC_PLATFORM_WIN32)
    return "1.0";
#elif (CC_TARGET_PLATFORM == CC_PLATFORM_MAC )
    return "1.0";
#endif
}

const char *CGame::getSystemMacAddress()
{
    __String *mac = __String::create("");
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    mac = __String::create("0");
#elif (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    mac = __String::create(AndroidUtils::getSystemMacAddress());
#elif (CC_TARGET_PLATFORM == CC_PLATFORM_WIN32)
    std::string macaddress;
    if (GetMacByNetBIOS(macaddress))
    {
        mac = __String::create(macaddress.c_str());
    }
#elif (CC_TARGET_PLATFORM == CC_PLATFORM_MAC )
    mac = __String::create(getMacAddress()->getCString());
#endif
    
    return mac->getCString();
}

void CGame::AppUpdate()
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
	
#elif (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
	
#elif (CC_TARGET_PLATFORM == CC_PLATFORM_WIN32)
	CCLOG("game:appUpdate win32");
#elif (CC_TARGET_PLATFORM == CC_PLATFORM_MAC )
	
#endif
}

void CGame::operateAd(int luaCallback, const char* opName, const char* opParam)
{
	AdLuaCallback = luaCallback;
//#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
	JniMethodInfo info;
	bool ret = JniHelper::getStaticMethodInfo(info, "org/cocos2dx/cpp/AppActivity", "openURL_facebookEval", "()V");
	jobject jobj;
	if (ret)
	{
		//log("call void getObj() succeed");
		info.env->CallStaticVoidMethod(info.classID, info.methodID);
	}
//#endif
}