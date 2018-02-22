#import <Foundation/Foundation.h>


@interface IOSUtility : NSObject

+ (NSString*) getDeviceClientId:(NSDictionary*)dict;

+ (NSString*) luaLoadAd:(NSDictionary*)dict;

+ (NSString*) luaShowAd:(NSDictionary*)dict;

+ (NSString*) luaHideAd:(NSDictionary*)dict;

+ (NSString*) luaStateAd:(NSDictionary*)dict;


@end
