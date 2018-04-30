#ifndef  _GAME_H_
#define  _GAME_H_

//#include "pay.h"
//#include "utils.h"
//#include "EncryptTxtReader.h"
//#include "CCLuaValue.h"
#include <string>

#include <spine/spine-cocos2dx.h>
using namespace spine;

using namespace std;

class CGame {
public:
    static void NetInitRaw(std::string ip,unsigned int port,std::string domain,int funcID);
	static void NetReconnectRaw();
	static void NetReconnectWithIP(std::string ip,unsigned int port);
	static void NetDisconnect();
	static void NetReqRaw(const char* value, int sz);
    static const char *getUUID();
    
    static void initDataBase(const char* dbfilePath,const char *dbFileName);

	static void hello(){};
    static bool isConnected();
    
    static void HttpReqGet(std::string address,int callbackfunc,int timeout = 30);
    
    static void HttpSetReadTimeOut(int timeout);
    static void HttpSetConnectTimeOut(int timeout);

	//SDK��ʼ��
	static void SDKInit(int init_finish_funcid,int login_success_funcid,int login_fail_funcid);

	//����SDK
	static void SDKDoStart();
	static void SDKDoLogin();
	static void SDKDoPay(std::string payinfo);

	static void SDKDoUserInfo(std::string userinfojson);

	static void OpenWeb(const char *url);
    
    static const char * getAppVersion();    //��ȡӦ�õİ汾   e.g. @"1.0"
    static const char * getDeviceModel();   //��ȡ�豸���ͺ�   e.g. @"iPhone", @"iPod touch"
    static const char * getOSName();        //��ȡ�豸ϵͳ���� e.g. @"iOS"
    static const char * getOSVersion();     //��ȡ�豸ϵͳ�汾 e.g. @"4.0"
    static const char * getSystemMacAddress();    //��ȡ�豸��Mac��ַ

	static void AppUpdate();

	static void operateAd(int luaCallback, const char* opName, const char* opParam);

	static unsigned int bitOperate(const int op, const int res, const int desc);

	static void HttpDownloadImage(const std::string &url, const std::string &fileName, const int &callBackFunc);
	static void HttpDownloadFile(const std::string &url, const std::string &fileName, const int &callBackFunc);

	static const std::string getMD5(std::string src);
};



//extern "C"
//{
//	void NetInitRaw(std::string ip,unsigned int port,std::string domain,int funcID);
//	void NetReconnectRaw();
//	void NetReqRaw(const char* value);
////	void NetHttpInitRaw(LUA_FUNCTION funcID);
////	void NetHttpReqRaw(string url,string data,string type,string tag);
////	extern void startPay(const char* orderUrl);
////	extern CCString* readEncryptTxt(const char* filePath);
////	void LoadImageAsync(const char* path,LUA_FUNCTION funcID);
//}

#endif