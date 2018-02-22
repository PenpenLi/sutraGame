#import "adManager.h"
#import "admobUnit.h"
#import "inmobiUnit.h"

@interface adManager()
-(instancetype)init;//将init方法私有
@end;

static adManager* _instance =nil;//静态变量




@implementation adManager

+(adManager*)getInstance{
    if(_instance ==nil){
        _instance = [[adManager alloc]init];
    }
    return _instance;
}

-(instancetype)init{
    srand((unsigned)time(0));
    
    return self;
}

-(id)copyWithZone:(NSZone*)zone{//重写copy方法，当执行copy函数时，返回该共享变量
    return _instance;
}

+(id)allocWithZone:(NSZone *)zone{//重写alloc方法
    @synchronized (self) {
        if(!_instance){
            _instance = [super allocWithZone:zone];
            return _instance;
        }
    }
    return _instance;
}


-(void)initSDK{
    [[admobUnit getInstance] initSDK];
    [[inmobiUnit getInstance]initSDK];
}

- (NSString*) luaLoadAd:(NSDictionary*)dict
{
    [[admobUnit getInstance] luaLoadAd:dict];
    [[inmobiUnit getInstance]luaLoadAd:dict];
    return @"";
}

- (NSString*) luaShowAd:(NSDictionary*)dict
{
    if ([[admobUnit getInstance] isLoaded])
        [[admobUnit getInstance] luaShowAd:dict];
    else if([[inmobiUnit getInstance]isLoaded])
        [[inmobiUnit getInstance]luaShowAd:dict];
    return @"";
}

- (NSString*) luaHideAd:(NSDictionary*)dict
{
    [[admobUnit getInstance] luaHideAd:dict];
    [[inmobiUnit getInstance]luaHideAd:dict];
    return @"";
}

- (NSString*) luaStateAd:(NSDictionary*)dict
{
    [[admobUnit getInstance] luaStateAd:dict];
    [[inmobiUnit getInstance]luaStateAd:dict];
    return @"";
}



 - (void)viewDidLoad: (RootViewController*)view {
     [[admobUnit getInstance] viewDidLoad: view];
     [[inmobiUnit getInstance]viewDidLoad:view];
 }

- (void)dealloc
{
    [[admobUnit getInstance]dealloc];
    [[inmobiUnit getInstance]dealloc];
}

@end
