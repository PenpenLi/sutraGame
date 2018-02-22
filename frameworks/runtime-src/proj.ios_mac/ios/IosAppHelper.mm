#include "IosAppHelper.h"
#include "IOSUtility.h"
#include "SSKeychain.h"
#include "cocos2d.h"
#include "scripting/lua-bindings/manual/platform/ios/CCLuaObjcBridge.h"
#include "adManager.h"



IosAppHelper* IosAppHelper::instance()
{
    static IosAppHelper* st_instance = NULL;
    if (st_instance == NULL)
    {
        st_instance = new IosAppHelper();
    }
    return st_instance;
}

IosAppHelper::IosAppHelper()
{
    
}


const char* IosAppHelper::GetImsiIni()
{
    NSString *strApplicationUUID = [SSKeychain passwordForService:@"gdy_offline" account:@"incoding"];
    if (strApplicationUUID == nil)
    {
        if ( [[UIDevice currentDevice].systemVersion floatValue] < 6.0)
        {
            srand((unsigned int)time(0));
            int iValue = rand()%1000000000;
            strApplicationUUID  = [NSString stringWithFormat:@"%d",iValue];
            [SSKeychain setPassword:strApplicationUUID forService:@"niuniu" account:@"incoding"];
        }
        else
        {
            strApplicationUUID  = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
            [SSKeychain setPassword:strApplicationUUID forService:@"gdy_offline" account:@"incoding"];
        }
    }
    
    return [strApplicationUUID UTF8String];
}

void IosAppHelper::initSDK()
{
    [[adManager getInstance] initSDK];
}
