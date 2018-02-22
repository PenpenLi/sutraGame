
#ifndef __inmobiUnit_H__
#define __inmobiUnit_H__

#import "ADSDKUnitProto.h"
#import <InMobiSDK/InMobiSDK.h>



@interface inmobiUnit : NSObject<ADSDKUnitProto, IMBannerDelegate>
@property(nonatomic, strong)IMBanner* banner;


+(inmobiUnit*)getInstance;

-(void)initSDK;

- (NSString*) luaLoadAd:(NSDictionary*)dict;

- (NSString*) luaShowAd:(NSDictionary*)dict;

- (NSString*) luaHideAd:(NSDictionary*)dict;

- (NSString*) luaStateAd:(NSDictionary*)dict;

- (bool) isLoaded;

- (void)viewDidLoad:(RootViewController*)view ;

- (void)dealloc;
@end



#endif
