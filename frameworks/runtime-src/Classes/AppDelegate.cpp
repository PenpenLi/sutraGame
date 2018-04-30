#include "AppDelegate.h"
#include "scripting/lua-bindings/manual/CCLuaEngine.h"
#include "audio/include/SimpleAudioEngine.h"
#include "cocos/scripting/lua-bindings/manual/lua_module_register.h"
#include "cocos2d.h"


using namespace CocosDenshion;

USING_NS_CC;
using namespace std;

AppDelegate::AppDelegate()
{
}

AppDelegate::~AppDelegate()
{
    SimpleAudioEngine::end();

#if (COCOS2D_DEBUG > 0) && (CC_CODE_IDE_DEBUG_SUPPORT > 0)
    // NOTE:Please don't remove this call if you want to debug with Cocos Code IDE
    RuntimeEngine::getInstance()->end();
#endif

}

// if you want a different context, modify the value of glContextAttrs
// it will affect all platforms
void AppDelegate::initGLContextAttrs()
{
    // set OpenGL context attributes: red,green,blue,alpha,depth,stencil
    GLContextAttrs glContextAttrs = {8, 8, 8, 8, 24, 8};

    GLView::setGLContextAttrs(glContextAttrs);
}

// if you want to use the package manager to install more packages, 
// don't modify or remove this function
static int register_all_packages()
{
    return 0; //flag for packages manager
}

bool AppDelegate::applicationDidFinishLaunching()
{
	CCLOG("AppDelegate::applicationDidFinishLaunching");
    // set default FPS
    Director::getInstance()->setAnimationInterval(1.0 / 60.0f);

    // register lua module
    auto engine = LuaEngine::getInstance();
    ScriptEngineManager::getInstance()->setScriptEngine(engine);
    lua_State* L = engine->getLuaStack()->getLuaState();
	lua_module_register(L);

    register_all_packages();

    LuaStack* stack = engine->getLuaStack();
    stack->setXXTEAKeyAndSign("yiyou2018", strlen("yiyou2018"), "yyTEA", strlen("yyTEA"));

    //register custom function
    //LuaStack* stack = engine->getLuaStack();
    //register_custom_function(stack->getLuaState());

    
#if (CC_TARGET_PLATFORM == CC_PLATFORM_WIN32)
	AllocConsole();
	HWND _hwndConsole = GetConsoleWindow();
	if (_hwndConsole != NULL)
	{
		ShowWindow(_hwndConsole, SW_SHOW);
		BringWindowToTop(_hwndConsole);
		freopen("CONOUT$", "wt", stdout);
		freopen("CONOUT$", "wt", stderr);

		HMENU hmenu = GetSystemMenu(_hwndConsole, FALSE);
		if (hmenu != NULL)
		{
			DeleteMenu(hmenu, SC_CLOSE, MF_BYCOMMAND);
		}
	}
#endif

	engine->addSearchPath("src");
	if (engine->executeScriptFile("src/main.lua"))
	{
		return false;
	}

    return true;
}

// This function will be called when the app is inactive. Note, when receiving a phone call it is invoked.
void AppDelegate::applicationDidEnterBackground()
{
    Director::getInstance()->stopAnimation();

    //SimpleAudioEngine::getInstance()->pauseBackgroundMusic();
    
    auto dispatcher = Director::getInstance()->getEventDispatcher();
    if (dispatcher) {
        dispatcher->dispatchCustomEvent("APP_ENTER_BACKGROUND_EVENT");
    }
}

// this function will be called when the app is active again
void AppDelegate::applicationWillEnterForeground()
{
    Director::getInstance()->startAnimation();

    //SimpleAudioEngine::getInstance()->resumeBackgroundMusic();
    
    auto dispatcher = Director::getInstance()->getEventDispatcher();
    if (dispatcher) {
        dispatcher->dispatchCustomEvent("APP_ENTER_FOREGROUND_EVENT");
    }
}
