//
//  adManager.h
//  DoudizhuClient
//
//  Created by zonst on 2018/2/19.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RootViewController.h"





@interface adManager : NSObject

+(adManager*)getInstance;//返回实例的方法，当共享变量为nil是，开辟一个新的空间给共享变量，当共享变量不为空时，返回该共享变量
-(void)initSDK;

- (NSString*) luaLoadAd:(NSDictionary*)dict;

- (NSString*) luaShowAd:(NSDictionary*)dict;

- (NSString*) luaHideAd:(NSDictionary*)dict;

- (NSString*) luaStateAd:(NSDictionary*)dict;

-(void)viewDidLoad: (RootViewController*)view ;
- (void)dealloc;
@end

