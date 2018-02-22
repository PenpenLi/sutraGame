#include "inmobiUnit.h"


@interface inmobiUnit()
-(instancetype)init;//将init方法私有

@property (atomic) bool isLoadedIndex;
@property (atomic) bool wantShow;
@end;

static inmobiUnit* _instance =nil;//静态变量



@implementation inmobiUnit

+(inmobiUnit*)getInstance{
    if(_instance ==nil){
        _instance = [[inmobiUnit alloc]init];
    }
    return _instance;
}

-(instancetype)init{
    self.isLoadedIndex = false;
    self.wantShow = false;
    
    self.banner = nil;
    return self;
}


-(void)initSDK{
    //d6033153bb3d4982a35b8c349c354f68 正式
    //ca-app-pub-3940256099942544~1458002511 测式
    
    //init inmobi sdk with your account id
    [IMSdk initWithAccountID:@"d6033153bb3d4982a35b8c349c354f68"];
}


- (NSString*) luaLoadAd:(NSDictionary*)dict
{
    if(self.banner != nil )
    {
        [self.banner load];
        self.isLoadedIndex = false;
    }
    
    return @"";
}

- (NSString*) luaShowAd:(NSDictionary*)dict
{
    if (self.banner != nil)
    {
        self.banner.hidden = false;
    }
    self.wantShow = true;
    return @"";
}

- (NSString*) luaHideAd:(NSDictionary*)dict
{
    self.banner.hidden = true;
    self.wantShow = false;
    return @"";
}

- (NSString*) luaStateAd:(NSDictionary*)dict
{
    return @"";
}

- (void)viewDidLoad:(RootViewController*)view
{
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    CGFloat h = [UIScreen mainScreen].bounds.size.height;
    //1517285427275 正式
    self.banner = [[IMBanner alloc]initWithFrame:CGRectMake(0, h-50, 320, 50) placementId:1517285427275];
    self.banner.delegate = self;
    
    [view.view addSubview: self.banner];
    
    [self.banner shouldAutoRefresh:YES];
    [self.banner setRefreshInterval:60];
    
    
    /*switch(random() % 5)
    {
        case 0:{self.banner.transitionAnimation = UIViewAnimationTransitionNone;}break;
        case 1:{self.banner.transitionAnimation = UIViewAnimationTransitionFlipFromLeft;}break;
        case 2:{self.banner.transitionAnimation = UIViewAnimationTransitionFlipFromRight;}break;
        case 3:{self.banner.transitionAnimation = UIViewAnimationTransitionCurlUp;}break;
        case 4:{self.banner.transitionAnimation = UIViewAnimationTransitionCurlDown;}break;
    }*/
    self.banner.transitionAnimation = UIViewAnimationTransitionNone;
    self.banner.hidden = true;
    
    [self luaLoadAd: [NSDictionary alloc] ];
}

- (void)dealloc
{
    self.banner.delegate = nil;
}

/*Indicates that the banner has received an ad. */
- (void)bannerDidFinishLoading:(IMBanner *)banner {
    NSLog(@"bannerDidFinishLoading");
    self.isLoadedIndex = true;
    
    self.banner.hidden = !self.wantShow;
    
}
/* Indicates that the banner has failed to receive an ad */
- (void)banner:(IMBanner *)banner didFailToLoadWithError:(IMRequestStatus *)error {
    NSLog(@"banner failed to load ad");
    NSLog(@"Error : %@", error.description);
    
    [NSTimer scheduledTimerWithTimeInterval:5.0
                                     target:self
                                   selector:@selector(luaLoadAd:)  userInfo:nil
                                    repeats:FALSE];
}
/* Indicates that the banner is going to present a screen. */
- (void)bannerWillPresentScreen:(IMBanner *)banner {
    NSLog(@"bannerWillPresentScreen");
}
/* Indicates that the banner has presented a screen. */
- (void)bannerDidPresentScreen:(IMBanner *)banner {
    NSLog(@"bannerDidPresentScreen");
}
/* Indicates that the banner is going to dismiss the presented screen. */
- (void)bannerWillDismissScreen:(IMBanner *)banner {
    NSLog(@"bannerWillDismissScreen");
}
/* Indicates that the banner has dismissed a screen. */
- (void)bannerDidDismissScreen:(IMBanner *)banner {
    NSLog(@"bannerDidDismissScreen");
}
/* Indicates that the user will leave the app. */
- (void)userWillLeaveApplicationFromBanner:(IMBanner *)banner {
    NSLog(@"userWillLeaveApplicationFromBanner");
}
/*  Indicates that the banner was interacted with. */
-(void)banner:(IMBanner *)banner didInteractWithParams:(NSDictionary *)params{
    NSLog(@"bannerdidInteractWithParams");
}
/*Indicates that the user has completed the action to be incentivised with .*/
-(void)banner:(IMBanner*)banner rewardActionCompletedWithRewards:(NSDictionary*)rewards{
    NSLog(@"rewardActionCompletedWithRewards");
}

- (bool) isLoaded
{
    //return self.isLoadedIndex;
    return false;
}


@end


