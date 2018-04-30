#include "lua_CGame_auto.hpp"
#include "CGame.h"
#include "tolua_fix.h"
#include "LuaBasicConversions.h"


int lua_CGame_CGame_isConnected(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"CGame",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_CGame_CGame_isConnected'", nullptr);
            return 0;
        }
        bool ret = CGame::isConnected();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CGame:isConnected",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_CGame_CGame_isConnected'.",&tolua_err);
#endif
    return 0;
}
int lua_CGame_CGame_getSystemMacAddress(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"CGame",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_CGame_CGame_getSystemMacAddress'", nullptr);
            return 0;
        }
        const char* ret = CGame::getSystemMacAddress();
        tolua_pushstring(tolua_S,(const char*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CGame:getSystemMacAddress",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_CGame_CGame_getSystemMacAddress'.",&tolua_err);
#endif
    return 0;
}
int lua_CGame_CGame_getOSName(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"CGame",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_CGame_CGame_getOSName'", nullptr);
            return 0;
        }
        const char* ret = CGame::getOSName();
        tolua_pushstring(tolua_S,(const char*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CGame:getOSName",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_CGame_CGame_getOSName'.",&tolua_err);
#endif
    return 0;
}
int lua_CGame_CGame_getAppVersion(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"CGame",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_CGame_CGame_getAppVersion'", nullptr);
            return 0;
        }
        const char* ret = CGame::getAppVersion();
        tolua_pushstring(tolua_S,(const char*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CGame:getAppVersion",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_CGame_CGame_getAppVersion'.",&tolua_err);
#endif
    return 0;
}
int lua_CGame_CGame_HttpSetReadTimeOut(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"CGame",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 1)
    {
        int arg0;
        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "CGame:HttpSetReadTimeOut");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_CGame_CGame_HttpSetReadTimeOut'", nullptr);
            return 0;
        }
        CGame::HttpSetReadTimeOut(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CGame:HttpSetReadTimeOut",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_CGame_CGame_HttpSetReadTimeOut'.",&tolua_err);
#endif
    return 0;
}
int lua_CGame_CGame_initDataBase(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"CGame",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 2)
    {
        const char* arg0;
        const char* arg1;
        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "CGame:initDataBase"); arg0 = arg0_tmp.c_str();
        std::string arg1_tmp; ok &= luaval_to_std_string(tolua_S, 3, &arg1_tmp, "CGame:initDataBase"); arg1 = arg1_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_CGame_CGame_initDataBase'", nullptr);
            return 0;
        }
        CGame::initDataBase(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CGame:initDataBase",argc, 2);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_CGame_CGame_initDataBase'.",&tolua_err);
#endif
    return 0;
}
int lua_CGame_CGame_OpenWeb(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"CGame",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 1)
    {
        const char* arg0;
        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "CGame:OpenWeb"); arg0 = arg0_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_CGame_CGame_OpenWeb'", nullptr);
            return 0;
        }
        CGame::OpenWeb(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CGame:OpenWeb",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_CGame_CGame_OpenWeb'.",&tolua_err);
#endif
    return 0;
}
int lua_CGame_CGame_NetReconnectRaw(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"CGame",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_CGame_CGame_NetReconnectRaw'", nullptr);
            return 0;
        }
        CGame::NetReconnectRaw();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CGame:NetReconnectRaw",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_CGame_CGame_NetReconnectRaw'.",&tolua_err);
#endif
    return 0;
}
int lua_CGame_CGame_SDKDoPay(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"CGame",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 1)
    {
        std::string arg0;
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "CGame:SDKDoPay");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_CGame_CGame_SDKDoPay'", nullptr);
            return 0;
        }
        CGame::SDKDoPay(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CGame:SDKDoPay",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_CGame_CGame_SDKDoPay'.",&tolua_err);
#endif
    return 0;
}
int lua_CGame_CGame_NetDisconnect(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"CGame",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_CGame_CGame_NetDisconnect'", nullptr);
            return 0;
        }
        CGame::NetDisconnect();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CGame:NetDisconnect",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_CGame_CGame_NetDisconnect'.",&tolua_err);
#endif
    return 0;
}
int lua_CGame_CGame_SDKDoLogin(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"CGame",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_CGame_CGame_SDKDoLogin'", nullptr);
            return 0;
        }
        CGame::SDKDoLogin();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CGame:SDKDoLogin",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_CGame_CGame_SDKDoLogin'.",&tolua_err);
#endif
    return 0;
}
int lua_CGame_CGame_SDKInit(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"CGame",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 3)
    {
        int arg0;
        int arg1;
        int arg2;
        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "CGame:SDKInit");
        ok &= luaval_to_int32(tolua_S, 3,(int *)&arg1, "CGame:SDKInit");
        ok &= luaval_to_int32(tolua_S, 4,(int *)&arg2, "CGame:SDKInit");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_CGame_CGame_SDKInit'", nullptr);
            return 0;
        }
        CGame::SDKInit(arg0, arg1, arg2);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CGame:SDKInit",argc, 3);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_CGame_CGame_SDKInit'.",&tolua_err);
#endif
    return 0;
}
int lua_CGame_CGame_SDKDoStart(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"CGame",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_CGame_CGame_SDKDoStart'", nullptr);
            return 0;
        }
        CGame::SDKDoStart();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CGame:SDKDoStart",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_CGame_CGame_SDKDoStart'.",&tolua_err);
#endif
    return 0;
}
int lua_CGame_CGame_getOSVersion(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"CGame",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_CGame_CGame_getOSVersion'", nullptr);
            return 0;
        }
        const char* ret = CGame::getOSVersion();
        tolua_pushstring(tolua_S,(const char*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CGame:getOSVersion",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_CGame_CGame_getOSVersion'.",&tolua_err);
#endif
    return 0;
}
int lua_CGame_CGame_getDeviceModel(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"CGame",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_CGame_CGame_getDeviceModel'", nullptr);
            return 0;
        }
        const char* ret = CGame::getDeviceModel();
        tolua_pushstring(tolua_S,(const char*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CGame:getDeviceModel",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_CGame_CGame_getDeviceModel'.",&tolua_err);
#endif
    return 0;
}
int lua_CGame_CGame_NetInitRaw(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"CGame",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 4)
    {
        std::string arg0;
        unsigned int arg1;
        std::string arg2;
        int arg3;
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "CGame:NetInitRaw");
        ok &= luaval_to_uint32(tolua_S, 3,&arg1, "CGame:NetInitRaw");
        ok &= luaval_to_std_string(tolua_S, 4,&arg2, "CGame:NetInitRaw");
		ok &= toluafix_isfunction(tolua_S, 5, "LUA_FUNCTION", 0, &tolua_err);
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_CGame_CGame_NetInitRaw'", nullptr);
            return 0;
        }
		arg3 = toluafix_ref_function(tolua_S, 5, 0);
        CGame::NetInitRaw(arg0, arg1, arg2, arg3);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CGame:NetInitRaw",argc, 4);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_CGame_CGame_NetInitRaw'.",&tolua_err);
#endif
    return 0;
}
int lua_CGame_CGame_NetReqRaw(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"CGame",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 2)
    {
        const char* arg0;
		int arg1 = 0;
		//ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "CGame:NetReqRaw"); 
		ok &= luaval_to_std_pchar(tolua_S, 2, &arg0, "CGame:NetReqRaw");
		ok &= luaval_to_int32(tolua_S, 3, (int *)&arg1, "CGame:NetReqRaw");
		
		//arg0 = arg0_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_CGame_CGame_NetReqRaw'", nullptr);
            return 0;
        }
        CGame::NetReqRaw(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CGame:NetReqRaw",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_CGame_CGame_NetReqRaw'.",&tolua_err);
#endif
    return 0;
}
int lua_CGame_CGame_NetReconnectWithIP(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"CGame",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 2)
    {
        std::string arg0;
        unsigned int arg1;
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "CGame:NetReconnectWithIP");
        ok &= luaval_to_uint32(tolua_S, 3,&arg1, "CGame:NetReconnectWithIP");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_CGame_CGame_NetReconnectWithIP'", nullptr);
            return 0;
        }
        CGame::NetReconnectWithIP(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CGame:NetReconnectWithIP",argc, 2);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_CGame_CGame_NetReconnectWithIP'.",&tolua_err);
#endif
    return 0;
}
int lua_CGame_CGame_SDKDoUserInfo(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"CGame",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 1)
    {
        std::string arg0;
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "CGame:SDKDoUserInfo");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_CGame_CGame_SDKDoUserInfo'", nullptr);
            return 0;
        }
        CGame::SDKDoUserInfo(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CGame:SDKDoUserInfo",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_CGame_CGame_SDKDoUserInfo'.",&tolua_err);
#endif
    return 0;
}
int lua_CGame_CGame_HttpReqGet(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"CGame",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 2)
    {
        std::string arg0;
        int arg1;
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "CGame:HttpReqGet");
        ok &= luaval_to_int32(tolua_S, 3,(int *)&arg1, "CGame:HttpReqGet");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_CGame_CGame_HttpReqGet'", nullptr);
            return 0;
        }
        CGame::HttpReqGet(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    if (argc == 3)
    {
        std::string arg0;
        int arg1;
        int arg2;
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "CGame:HttpReqGet");
        ok &= luaval_to_int32(tolua_S, 3,(int *)&arg1, "CGame:HttpReqGet");
        ok &= luaval_to_int32(tolua_S, 4,(int *)&arg2, "CGame:HttpReqGet");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_CGame_CGame_HttpReqGet'", nullptr);
            return 0;
        }
        CGame::HttpReqGet(arg0, arg1, arg2);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CGame:HttpReqGet",argc, 2);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_CGame_CGame_HttpReqGet'.",&tolua_err);
#endif
    return 0;
}
int lua_CGame_CGame_AppUpdate(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"CGame",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_CGame_CGame_AppUpdate'", nullptr);
            return 0;
        }
        CGame::AppUpdate();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CGame:AppUpdate",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_CGame_CGame_AppUpdate'.",&tolua_err);
#endif
    return 0;
}
int lua_CGame_CGame_getUUID(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"CGame",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_CGame_CGame_getUUID'", nullptr);
            return 0;
        }
        const char* ret = CGame::getUUID();
        tolua_pushstring(tolua_S,(const char*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CGame:getUUID",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_CGame_CGame_getUUID'.",&tolua_err);
#endif
    return 0;
}
int lua_CGame_CGame_hello(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"CGame",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_CGame_CGame_hello'", nullptr);
            return 0;
        }
        CGame::hello();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CGame:hello",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_CGame_CGame_hello'.",&tolua_err);
#endif
    return 0;
}
int lua_CGame_CGame_HttpSetConnectTimeOut(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"CGame",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 1)
    {
        int arg0;
        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "CGame:HttpSetConnectTimeOut");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_CGame_CGame_HttpSetConnectTimeOut'", nullptr);
            return 0;
        }
        CGame::HttpSetConnectTimeOut(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CGame:HttpSetConnectTimeOut",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_CGame_CGame_HttpSetConnectTimeOut'.",&tolua_err);
#endif
    return 0;
}
static int lua_CGame_CGame_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (CGame)");
    return 0;
}

int lua_cocos2dx_CGame_CGame_bitOperate(lua_State* tolua_S)
{
	int argc = 0;
	bool ok = true;
	tolua_Error tolua_err;
#if COCOS2D_DEBUG >= 1

#endif

#if COCOS2D_DEBUG >= 1
	if (!tolua_isusertable(tolua_S, 1, "CGame", 0, &tolua_err)) goto tolua_lerror;
#endif

	argc = lua_gettop(tolua_S) - 1;

	if (argc == 3)
	{
		int arg0;
		int arg1;
		int arg2;
		ok &= luaval_to_int32(tolua_S, 2, (int *)&arg0, "CGame:bitOperate");
		ok &= luaval_to_int32(tolua_S, 3, (int *)&arg1, "CGame:bitOperate");
		ok &= luaval_to_int32(tolua_S, 4, (int *)&arg2, "CGame:bitOperate");
		if (!ok)
		{
			tolua_error(tolua_S, "invalid arguments in function 'lua_cocos2dx_CGame_CGame_bitOperate'", nullptr);
			return 0;
		}
		unsigned int res = CGame::bitOperate(arg0, arg1, arg2);
		//lua_settop(tolua_S, 1);
		tolua_pushnumber(tolua_S, (lua_Number)res);

		return 1;
	}
	luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CGame:bitOperate", argc, 3);
	return 0;
#if COCOS2D_DEBUG >= 1
	tolua_lerror:
				tolua_error(tolua_S, "#ferror in function 'lua_cocos2dx_CGame_CGame_bitOperate'.", &tolua_err);
#endif
				return 0;
}

static int lua_cocos2dx_CGame_CGame_getMD5(lua_State* tolua_S)
{
	int argc = 0;
	bool ok = true;
	tolua_Error tolua_err;
#if COCOS2D_DEBUG >= 1

#endif

#if COCOS2D_DEBUG >= 1
	if (!tolua_isusertable(tolua_S, 1, "CGame", 0, &tolua_err)) goto tolua_lerror;
#endif

	argc = lua_gettop(tolua_S) - 1;

	if (argc == 1)
	{
		std::string arg0;
		ok &= luaval_to_std_string(tolua_S, 2, &arg0, "CGame:getMD5");
		if (!ok)
		{
			tolua_error(tolua_S, "invalid arguments in function 'lua_cocos2dx_CGame_CGame_getMD5'", nullptr);
			return 0;
		}

		char ret[80] = {};
		strcpy(ret, CGame::getMD5(arg0).c_str());
		tolua_pushstring(tolua_S, ret);
		return 1;
	}
	luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CGame:getMD5", argc, 1);
	return 0;
#if COCOS2D_DEBUG >= 1
	tolua_lerror:
				tolua_error(tolua_S, "#ferror in function 'lua_cocos2dx_CGame_CGame_getMD5'.", &tolua_err);
#endif
				return 0;
}


int lua_cocos2dx_CGame_CGame_HttpDownloadFile(lua_State* tolua_S)
{
	int argc = 0;
	bool ok = true;
	tolua_Error tolua_err;
#if COCOS2D_DEBUG >= 1

#endif

#if COCOS2D_DEBUG >= 1
	if (!tolua_isusertable(tolua_S, 1, "CGame", 0, &tolua_err)) goto tolua_lerror;
#endif

	argc = lua_gettop(tolua_S) - 1;

	if (argc == 3)
	{
		std::string arg0;
		std::string arg1;
		int arg2;
		ok &= luaval_to_std_string(tolua_S, 2, &arg0, "CGame:HttpDownloadFile");
		ok &= luaval_to_std_string(tolua_S, 3, &arg1, "CGame:HttpDownloadFile");
		//ok &= luaval_to_int32(tolua_S, 4,(int *)&arg2, "CGame:HttpReqGet");
		ok &= toluafix_isfunction(tolua_S, 4, "LUA_FUNCTION", 0, &tolua_err);
		arg2 = toluafix_ref_function(tolua_S, 4, 0);
		if (!ok)
		{
			tolua_error(tolua_S, "invalid arguments in function 'lua_cocos2dx_CGame_CGame_HttpDownloadFile'", nullptr);
			return 0;
		}
		CGame::HttpDownloadFile(arg0, arg1, arg2);
		lua_settop(tolua_S, 1);
		return 1;
	}
	luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CGame:HttpDownloadFile", argc, 3);
	return 0;
#if COCOS2D_DEBUG >= 1
	tolua_lerror:
				tolua_error(tolua_S, "#ferror in function 'lua_cocos2dx_CGame_CGame_HttpDownloadFile'.", &tolua_err);
#endif
				return 0;
}



int lua_cocos2dx_CGame_CGame_HttpDownloadImage(lua_State* tolua_S)
{
	int argc = 0;
	bool ok = true;
	tolua_Error tolua_err;
#if COCOS2D_DEBUG >= 1

#endif

#if COCOS2D_DEBUG >= 1
	if (!tolua_isusertable(tolua_S, 1, "CGame", 0, &tolua_err)) goto tolua_lerror;
#endif

	argc = lua_gettop(tolua_S) - 1;

	if (argc == 3)
	{
		std::string arg0;
		std::string arg1;
		int arg2;
		ok &= luaval_to_std_string(tolua_S, 2, &arg0, "CGame:HttpDownloadImage");
		ok &= luaval_to_std_string(tolua_S, 3, &arg1, "CGame:HttpDownloadImage");
		//ok &= luaval_to_int32(tolua_S, 4,(int *)&arg2, "CGame:HttpReqGet");
		ok &= toluafix_isfunction(tolua_S, 4, "LUA_FUNCTION", 0, &tolua_err);
		arg2 = toluafix_ref_function(tolua_S, 4, 0);
		if (!ok)
		{
			tolua_error(tolua_S, "invalid arguments in function 'lua_cocos2dx_CGame_CGame_HttpDownloadImage'", nullptr);
			return 0;
		}
		CGame::HttpDownloadImage(arg0, arg1, arg2);
		lua_settop(tolua_S, 1);
		return 1;
	}
	luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "CGame:HttpDownloadImage", argc, 3);
	return 0;
#if COCOS2D_DEBUG >= 1
	tolua_lerror:
				tolua_error(tolua_S, "#ferror in function 'lua_cocos2dx_CGame_CGame_HttpDownloadImage'.", &tolua_err);
#endif
				return 0;
}

int lua_register_CGame_CGame(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"CGame");
    tolua_cclass(tolua_S,"CGame","CGame","",nullptr);

    tolua_beginmodule(tolua_S,"CGame");
        tolua_function(tolua_S,"isConnected", lua_CGame_CGame_isConnected);
        tolua_function(tolua_S,"getSystemMacAddress", lua_CGame_CGame_getSystemMacAddress);
        tolua_function(tolua_S,"getOSName", lua_CGame_CGame_getOSName);
        tolua_function(tolua_S,"getAppVersion", lua_CGame_CGame_getAppVersion);
        tolua_function(tolua_S,"HttpSetReadTimeOut", lua_CGame_CGame_HttpSetReadTimeOut);
        tolua_function(tolua_S,"initDataBase", lua_CGame_CGame_initDataBase);
        tolua_function(tolua_S,"OpenWeb", lua_CGame_CGame_OpenWeb);
        tolua_function(tolua_S,"NetReconnectRaw", lua_CGame_CGame_NetReconnectRaw);
        tolua_function(tolua_S,"SDKDoPay", lua_CGame_CGame_SDKDoPay);
        tolua_function(tolua_S,"NetDisconnect", lua_CGame_CGame_NetDisconnect);
        tolua_function(tolua_S,"SDKDoLogin", lua_CGame_CGame_SDKDoLogin);
        tolua_function(tolua_S,"SDKInit", lua_CGame_CGame_SDKInit);
        tolua_function(tolua_S,"SDKDoStart", lua_CGame_CGame_SDKDoStart);
        tolua_function(tolua_S,"getOSVersion", lua_CGame_CGame_getOSVersion);
        tolua_function(tolua_S,"getDeviceModel", lua_CGame_CGame_getDeviceModel);
        tolua_function(tolua_S,"NetInitRaw", lua_CGame_CGame_NetInitRaw);
        tolua_function(tolua_S,"NetReqRaw", lua_CGame_CGame_NetReqRaw);
        tolua_function(tolua_S,"NetReconnectWithIP", lua_CGame_CGame_NetReconnectWithIP);
        tolua_function(tolua_S,"SDKDoUserInfo", lua_CGame_CGame_SDKDoUserInfo);
        tolua_function(tolua_S,"HttpReqGet", lua_CGame_CGame_HttpReqGet);
        tolua_function(tolua_S,"AppUpdate", lua_CGame_CGame_AppUpdate);
        tolua_function(tolua_S,"getUUID", lua_CGame_CGame_getUUID);
        tolua_function(tolua_S,"hello", lua_CGame_CGame_hello);
        tolua_function(tolua_S,"HttpSetConnectTimeOut", lua_CGame_CGame_HttpSetConnectTimeOut);
		tolua_function(tolua_S, "HttpDownloadImage", lua_cocos2dx_CGame_CGame_HttpDownloadImage);
		tolua_function(tolua_S, "HttpDownloadFile", lua_cocos2dx_CGame_CGame_HttpDownloadFile);
		tolua_function(tolua_S, "getMD5", lua_cocos2dx_CGame_CGame_getMD5);
		tolua_function(tolua_S, "bitOperate", lua_cocos2dx_CGame_CGame_bitOperate);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(CGame).name();
    g_luaType[typeName] = "CGame";
    g_typeCast["CGame"] = "CGame";
    return 1;
}
TOLUA_API int register_all_CGame(lua_State* tolua_S)
{
	tolua_open(tolua_S);
	
	tolua_module(tolua_S,nullptr,0);
	tolua_beginmodule(tolua_S,nullptr);

	lua_register_CGame_CGame(tolua_S);

	tolua_endmodule(tolua_S);
	return 1;
}

