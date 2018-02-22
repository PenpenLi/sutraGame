//
//  ADSDKUnit.h
//  DoudizhuClient-mobile
//
//  Created by zonst on 2018/2/21.
//

#import <Foundation/Foundation.h>
#import <ADSDKUnitProto.h>
#import "RootViewController.h"

@protocol ADSDKUnitProto <NSObject>
@required
    -(void)initSDK;

    - (NSString*) luaLoadAd:(NSDictionary*)dict;

    - (NSString*) luaShowAd:(NSDictionary*)dict;

    - (NSString*) luaHideAd:(NSDictionary*)dict;

    - (NSString*) luaStateAd:(NSDictionary*)dict;

@optional
- (void)viewDidLoad: (RootViewController*)view;
- (void)dealloc;
- (bool) isLoaded;
@end
