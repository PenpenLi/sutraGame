#include "admobUnit.h"


@interface admobUnit()
-(instancetype)init;//将init方法私有

@property(nonatomic, strong) GADBannerView* bannerView;
@property (atomic) bool isLoadedIndex;
@end;

static admobUnit* _instance =nil;//静态变量
static RootViewController* mainView = nil;


@implementation admobUnit

+(admobUnit*)getInstance{
    if(_instance ==nil){
        _instance = [[admobUnit alloc]init];
    }
    return _instance;
}

-(instancetype)init{
    
    self.isLoadedIndex = false;
    return self;
}



-(void)initSDK{
    //ca-app-pub-3455499373106199~7157501533 正式
    //ca-app-pub-3940256099942544~1458002511 测式
    [GADMobileAds configureWithApplicationID:@"ca-app-pub-3940256099942544~1458002511"];
}


- (NSString*) luaLoadAd:(NSDictionary*)dict
{
    return @"";
}

- (NSString*) luaShowAd:(NSDictionary*)dict
{
    return @"";
}

- (NSString*) luaHideAd:(NSDictionary*)dict
{
    return @"";
}

- (NSString*) luaStateAd:(NSDictionary*)dict
{
    return @"";
}

- (void)viewDidLoad:(RootViewController*)view
{
    mainView = view;
    
    self.bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    
    [self addBannerViewToView:self.bannerView];
    
    //ca-app-pub-3455499373106199/9292710281 正式
    //ca-app-pub-3940256099942544/2934735716 测试
    self.bannerView.adUnitID = @"ca-app-pub-3940256099942544/2934735716";
    self.bannerView.rootViewController = view;
    
    [self.bannerView loadRequest:[GADRequest request]];
    
    self.bannerView.delegate = self;
}

- (void)addBannerViewToView:(UIView *)bannerView {
    bannerView.translatesAutoresizingMaskIntoConstraints = NO;
    [mainView.view addSubview:bannerView];
    [mainView.view addConstraints:@[
                                [NSLayoutConstraint constraintWithItem:bannerView
                                                             attribute:NSLayoutAttributeBottom
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:mainView.bottomLayoutGuide
                                                             attribute:NSLayoutAttributeTop
                                                            multiplier:1
                                                              constant:0],
                                [NSLayoutConstraint constraintWithItem:bannerView
                                                             attribute:NSLayoutAttributeCenterX
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:mainView.view
                                                             attribute:NSLayoutAttributeCenterX
                                                            multiplier:1
                                                              constant:0]
                                ]];
}

/// Tells the delegate an ad request loaded an ad.
- (void)adViewDidReceiveAd:(GADBannerView *)adView {
    NSLog(@"adViewDidReceiveAd");
    //[self addBannerViewToView:self.bannerView];
}

/// Tells the delegate an ad request failed.
- (void)adView:(GADBannerView *)adView
didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"adView:didFailToReceiveAdWithError: %@", [error localizedDescription]);
    
}

/// Tells the delegate that a full-screen view will be presented in response
/// to the user clicking on an ad.
- (void)adViewWillPresentScreen:(GADBannerView *)adView {
    NSLog(@"adViewWillPresentScreen");
}

/// Tells the delegate that the full-screen view will be dismissed.
- (void)adViewWillDismissScreen:(GADBannerView *)adView {
    NSLog(@"adViewWillDismissScreen");
}

/// Tells the delegate that the full-screen view has been dismissed.
- (void)adViewDidDismissScreen:(GADBannerView *)adView {
    NSLog(@"adViewDidDismissScreen");
}

/// Tells the delegate that a user click will open another app (such as
/// the App Store), backgrounding the current app.
- (void)adViewWillLeaveApplication:(GADBannerView *)adView {
    NSLog(@"adViewWillLeaveApplication");
}

- (bool) isLoaded
{
    return self.isLoadedIndex;
}
@end


