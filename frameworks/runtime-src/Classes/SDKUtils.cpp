//
//  SDKUtils.cpp
//  WorldWarII
//
//  Created by KevinChen on 14/11/4.
//
//

#include "SDKUtils.h"

#include "CCLuaEngine.h"

USING_NS_CC;

static SDKUtils *g_sdkutils = nullptr;

typedef enum _callbackcode {
	InitFinish = 1,
	LoginSuccess = 2,
	LoginFail = 3,
	LogoutSuccess = 4,
	SoundCallback = 5
}CALLBACKCODE;

SDKUtils *SDKUtils::getInstance()
{
    if (g_sdkutils == nullptr) {
        g_sdkutils = new SDKUtils();
    }
    
    return g_sdkutils;
}

void SDKUtils::destroyInstance()
{
    CC_SAFE_DELETE(g_sdkutils);
}

SDKUtils::SDKUtils():m_init_finish_funcid(0),m_login_fail_funcid(0),m_login_success_funcid(0)
{

}

SDKUtils::~SDKUtils()
{
	g_sdkutils = nullptr;
}

void SDKUtils::initSDK()
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_WIN32 || CC_TARGET_PLATFORM == CC_PLATFORM_MAC)

#elif (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)

#elif (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
	
#endif
}


void SDKUtils::setCallbackFuncID(int init_finish_funcid,int login_success_funcid,int login_fail_funcid)
{
	m_init_finish_funcid = init_finish_funcid;
	m_login_fail_funcid = login_fail_funcid;
	m_login_success_funcid = login_success_funcid;

#if (CC_TARGET_PLATFORM == CC_PLATFORM_WIN32 || CC_TARGET_PLATFORM == CC_PLATFORM_MAC)
	
#elif (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)

#elif (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
	
#endif
}

void SDKUtils::initFinishCallback(std::string msg,std::string partnerID)
{
	if (m_init_finish_funcid == 0){
		log("m_init_finish_funcid is null!!!");
	}else{
		LuaEngine* pEngine = (LuaEngine*)ScriptEngineManager::getInstance()->getScriptEngine();
		LuaStack* luaStack= pEngine->getLuaStack();
		luaStack->pushInt(CALLBACKCODE::InitFinish);
		luaStack->pushString(msg.c_str());
		luaStack->pushString(partnerID.c_str());
		luaStack->executeFunctionByHandler(m_init_finish_funcid, 3);
	}
}

void SDKUtils::loginSuccessCallback(std::string token,std::string partnerID)
{
	if (m_init_finish_funcid == 0){
		log("m_init_finish_funcid is null!!!");
	}else{
		LuaEngine* pEngine = (LuaEngine*)ScriptEngineManager::getInstance()->getScriptEngine();
		LuaStack* luaStack= pEngine->getLuaStack();
		luaStack->pushInt(CALLBACKCODE::LoginSuccess);
		luaStack->pushString(token.c_str());
		luaStack->pushString(partnerID.c_str());
		luaStack->executeFunctionByHandler(m_init_finish_funcid, 3);
	}
}

void SDKUtils::loginFailCallback(std::string msg,std::string partnerID)
{
	if (m_init_finish_funcid == 0){
		log("m_init_finish_funcid is null!!!");
	}else{
		LuaEngine* pEngine = (LuaEngine*)ScriptEngineManager::getInstance()->getScriptEngine();
		LuaStack* luaStack= pEngine->getLuaStack();
		luaStack->pushInt(CALLBACKCODE::LoginFail);
		luaStack->pushString(msg.c_str());
		luaStack->pushString(partnerID.c_str());
		luaStack->executeFunctionByHandler(m_init_finish_funcid, 3);
	}
}

void SDKUtils::logoutSuccessCallback()
{
	if (m_init_finish_funcid == 0){
		log("m_init_finish_funcid is null!!!");
	}else{
		LuaEngine* pEngine = (LuaEngine*)ScriptEngineManager::getInstance()->getScriptEngine();
		LuaStack* luaStack= pEngine->getLuaStack();
		luaStack->pushInt(CALLBACKCODE::LogoutSuccess);
		luaStack->executeFunctionByHandler(m_init_finish_funcid, 1);
	}
}

void SDKUtils::soundCallback(std::string msg)
{
	if (m_init_finish_funcid == 0){
		log("m_init_finish_funcid is null!!!");
	}else{
		LuaEngine* pEngine = (LuaEngine*)ScriptEngineManager::getInstance()->getScriptEngine();
		LuaStack* luaStack= pEngine->getLuaStack();
		luaStack->pushInt(CALLBACKCODE::SoundCallback);
		luaStack->executeFunctionByHandler(m_init_finish_funcid, 1);
	}
}