
#include "AndroidUtils.h"

#if(CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
#include "platform/android/jni/JniHelper.h"
#endif
#include "cocos2d.h"
USING_NS_CC;

const char * AndroidUtils::getDeviceID()
{
	JniMethodInfo mInfo;
    bool isHave = JniHelper::getStaticMethodInfo(mInfo,"org/cocos2dx/lua/AppActivity","getDeviceID", "()Ljava/lang/String;");

    // CCLOG("isHave:%d",isHave);
	
    jobject jobj;
    if (isHave) {
    	jobj = mInfo.env->CallStaticObjectMethod(mInfo.classID, mInfo.methodID);
    	jstring string = (jstring)jobj;
    	jboolean isCopy = true;
    	const char *deviceID = mInfo.env->GetStringUTFChars(string,&isCopy);
        // CCLOG("c++ ID:%s",deviceID);
    	return deviceID;
    }
    /**
	**/
    return "";
}

const char * AndroidUtils::getDeviceModel()
{
    JniMethodInfo mInfo;
    bool isHave = JniHelper::getStaticMethodInfo(mInfo,"org/cocos2dx/lua/AppActivity","getDeviceModel", "()Ljava/lang/String;");
    
//    CCLOG("isHave:%d",isHave);
    
    jobject jobj;
    if (isHave) {
        jobj = mInfo.env->CallStaticObjectMethod(mInfo.classID, mInfo.methodID);
        jstring string = (jstring)jobj;
        jboolean isCopy = true;
        const char *deviceID = mInfo.env->GetStringUTFChars(string,&isCopy);
        return deviceID;
    }
    return "";
}

const char * AndroidUtils::getDeviceSdk()
{
    JniMethodInfo mInfo;
    bool isHave = JniHelper::getStaticMethodInfo(mInfo,"org/cocos2dx/lua/AppActivity","getDeviceSdk", "()Ljava/lang/String;");
    
//    CCLOG("isHave:%d",isHave);
    
    jobject jobj;
    if (isHave) {
        jobj = mInfo.env->CallStaticObjectMethod(mInfo.classID, mInfo.methodID);
        jstring string = (jstring)jobj;
        jboolean isCopy = true;
        const char *deviceID = mInfo.env->GetStringUTFChars(string,&isCopy);
        return deviceID;
    }
    return "";
}

const char * AndroidUtils::getDeviceOsVersion()
{
    JniMethodInfo mInfo;
    bool isHave = JniHelper::getStaticMethodInfo(mInfo,"org/cocos2dx/lua/AppActivity","getDeviceOsVersion", "()Ljava/lang/String;");
    
//    CCLOG("isHave:%d",isHave);
    
    jobject jobj;
    if (isHave) {
        jobj = mInfo.env->CallStaticObjectMethod(mInfo.classID, mInfo.methodID);
        jstring string = (jstring)jobj;
        jboolean isCopy = true;
        const char *deviceID = mInfo.env->GetStringUTFChars(string,&isCopy);
        return deviceID;
    }
    return "";
}

const char * AndroidUtils::getPackageVersion()
{
    JniMethodInfo mInfo;
    bool isHave = JniHelper::getStaticMethodInfo(mInfo,"org/cocos2dx/lua/AppActivity","getPackageVersion", "()Ljava/lang/String;");
    
//    CCLOG("isHave:%d",isHave);
    
    jobject jobj;
    if (isHave) {
        jobj = mInfo.env->CallStaticObjectMethod(mInfo.classID, mInfo.methodID);
        jstring string = (jstring)jobj;
        jboolean isCopy = true;
        const char *deviceID = mInfo.env->GetStringUTFChars(string,&isCopy);
        return deviceID;
    }
    return "";
}

const char * AndroidUtils::getSystemMacAddress()
{
    bool isExit = FileUtils::getInstance()->isFileExist("/sys/class/net/wlan0/address");
    __String *macAddr = NULL;
    if (isExit){
        macAddr = __String::createWithContentsOfFile("/sys/class/net/wlan0/address");
    } else {
        macAddr = __String::createWithContentsOfFile("/sys/class/net/eth0/address");
    }
    
    return macAddr->getCString();
}

// ƒø¬º,Œƒº˛√˚
void AndroidUtils::copyDB(const char *packFilePath ,const char * docFilePath)
{
    
    JniMethodInfo mInfo;
    bool isHave = JniHelper::getStaticMethodInfo(mInfo,"org/cocos2dx/lua/AppActivity","copyDBFile", "(Ljava/lang/String;Ljava/lang/String;)V");
    
    //    CCLOG("isHave:%d",isHave);
    
    
    if (isHave) {
        jstring js1 = mInfo.env->NewStringUTF(packFilePath);
		jstring js2 = mInfo.env->NewStringUTF(docFilePath);
        mInfo.env->CallStaticVoidMethod(mInfo.classID, mInfo.methodID,js1,js2);
    }
/**

	**/
	CCLOG("copyDB");
}

void AndroidUtils::sdk_init()
{
	JniMethodInfo mInfo;
    bool isHave = JniHelper::getStaticMethodInfo(mInfo,"org/cocos2dx/lua/AppActivity","initSDK", "()V");
	
    if (isHave) {        
        mInfo.env->CallStaticVoidMethod(mInfo.classID, mInfo.methodID);
    }
}

void AndroidUtils::sdk_dologin()
{
	JniMethodInfo mInfo;
    bool isHave = JniHelper::getStaticMethodInfo(mInfo,"org/cocos2dx/lua/AppActivity","doLogin", "()V");
	
    if (isHave) {        
        mInfo.env->CallStaticVoidMethod(mInfo.classID, mInfo.methodID);
    }
}

void AndroidUtils::sdk_dopay(const char *payinfo)
{
	JniMethodInfo mInfo;
    bool isHave = JniHelper::getStaticMethodInfo(mInfo,"org/cocos2dx/lua/AppActivity","doPay", "(Ljava/lang/String;)V");
		
    if (isHave) {     
		jstring js1 = mInfo.env->NewStringUTF(payinfo);
        mInfo.env->CallStaticVoidMethod(mInfo.classID, mInfo.methodID,js1);
    }
}

//打开网页跳转
void AndroidUtils::openWebView(const char *uri)
{
    JniMethodInfo mInfo;
    bool isHave = JniHelper::getStaticMethodInfo(mInfo,"org/cocos2dx/lua/AppActivity","openWebView", "(Ljava/lang/String;)V");
        
    if (isHave) {     
        jstring js1 = mInfo.env->NewStringUTF(uri);
        mInfo.env->CallStaticVoidMethod(mInfo.classID, mInfo.methodID,js1);
    }
}