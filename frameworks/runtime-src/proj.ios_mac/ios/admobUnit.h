
#ifndef __admobUnit_H__
#define __admobUnit_H__

#import "ADSDKUnitProto.h"
#import "RootViewController.h"
#import <GoogleMobileAds/GoogleMobileAds.h>



@interface admobUnit : NSObject<ADSDKUnitProto, GADBannerViewDelegate>

+(admobUnit*)getInstance;

-(void)initSDK;

- (NSString*) luaLoadAd:(NSDictionary*)dict;

- (NSString*) luaShowAd:(NSDictionary*)dict;

- (NSString*) luaHideAd:(NSDictionary*)dict;

- (NSString*) luaStateAd:(NSDictionary*)dict;

- (void)viewDidLoad:(RootViewController*)view ;

- (bool) isLoaded;
@end



#endif
