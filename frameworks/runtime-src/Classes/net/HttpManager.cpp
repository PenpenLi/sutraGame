//
//  HttpManager.cpp
//  WorldWarII
//
//  Created by KevinChen on 14/11/4.
//
//

#include "HttpManager.h"

#include "CCLuaEngine.h"

USING_NS_CC;

using namespace cocos2d::network;

static HttpManager *s_pHttpManager = nullptr; // pointer to singleton

HttpManager *HttpManager::getInstance()
{
    if (s_pHttpManager == nullptr) {
        s_pHttpManager = new HttpManager();
    }
    
    return s_pHttpManager;
}

void HttpManager::destroyInstance()
{
    CC_SAFE_DELETE(s_pHttpManager);
}

HttpManager::HttpManager()
{
    HttpClient::getInstance()->setTimeoutForConnect(30);
    HttpClient::getInstance()->setTimeoutForRead(30);
}

HttpManager::~HttpManager()
{
    s_pHttpManager = nullptr;
}

void HttpManager::onHttpRequestCompleted(HttpClient *sender, HttpResponse *response)
{
    if (!response)
    {
        return;
    }
    
    // You can get original request type from: response->request->reqType
//    if (0 != strlen(response->getHttpRequest()->getTag()))
//    {
//        log("%s completed", response->getHttpRequest()->getTag());
//    }
    
    LuaEngine* pEngine = (LuaEngine*)ScriptEngineManager::getInstance()->getScriptEngine();
    LuaStack* luaStack= pEngine->getLuaStack();
    
    long statusCode = response->getResponseCode();
//    char statusString[64] = {};
//    sprintf(statusString, "HTTP Status Code: %ld, tag = %s", statusCode, response->getHttpRequest()->getTag());
//    log("response code: %ld", statusCode);
    
    if (!response->isSucceed())
    {
        int errorcode = statusCode;
        const char *errBuf = response->getErrorBuffer();
        if (strstr(errBuf,"timed out") > 0)
        {
            //请求超时
            errorcode = -2;
        }
        else if (strstr(errBuf, "Failed to connect") > 0)
        {
            //连接失败
            errorcode = -3;
        }
        
        log("response failed");
        log("error buffer: %s", response->getErrorBuffer());
        luaStack->pushInt(errorcode);
        luaStack->pushString("");
        luaStack->executeFunctionByHandler(atoi(response->getHttpRequest()->getTag()), 2);
        return;
    }

    // dump data
    std::vector<char> *buffer = response->getResponseData();
//    printf("response string:\n ");
//    for (unsigned int i = 0; i < buffer->size(); i++)
//    {
//        printf("%c", (*buffer)[i]);
//    }
//    printf("\n");
    
    std::string res;
    for (int i = 0;i<buffer->size();++i)
    {
        res+=(*buffer)[i];
    }
    res+="";
    
    
    luaStack->pushInt(statusCode);
    luaStack->pushString(res.c_str());
    luaStack->executeFunctionByHandler(atoi(response->getHttpRequest()->getTag()), 2);

    
//    char responseString[buffer->size()] = {};
    
}