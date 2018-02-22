#import "IOSUtility.h"

#import "adManager.h"
#include <IosAppHelper.h>

@implementation IOSUtility
{
}



+ (NSString*) getDeviceClientId:(NSDictionary *)dict
{
    const char* strDeviceID = IosAppHelper::instance()->GetImsiIni();
    if (strDeviceID == nullptr) {
        return @"";
    }
    NSString *txt = [NSString stringWithCString:strDeviceID encoding:NSUTF8StringEncoding];    
    NSLog(@"uuid=%@", txt);
    return txt;
}

+ (NSString*) luaLoadAd:(NSDictionary*)dict
{
   [[adManager getInstance] luaLoadAd:dict];
    return @"";
}

+ (NSString*) luaShowAd:(NSDictionary*)dict
{
    [[adManager getInstance] luaShowAd:dict];
    return @"";
}

+ (NSString*) luaHideAd:(NSDictionary*)dict
{
    [[adManager getInstance] luaHideAd:dict];
    return @"";
}

+ (NSString*) luaStateAd:(NSDictionary*)dict
{
    [[adManager getInstance] luaStateAd:dict];
    return @"";
}



@end
