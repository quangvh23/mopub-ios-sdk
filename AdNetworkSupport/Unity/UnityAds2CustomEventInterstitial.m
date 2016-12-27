//
//  UnityAds2CustomEventInterstitial.m
//  Sonic 1
//
//  Created by Quang Vinh Ha on 11/15/16.
//  Copyright © 2016 Christian Whitehead. All rights reserved.
//

#import "UnityAds2CustomEventInterstitial.h"
#import <UnityAds/UnityAds.h>

@interface UnityAds2CustomEventInterstitial () <UnityAdsDelegate>
@property (nonatomic, strong) NSString* zoneId ;
@end

@implementation UnityAds2CustomEventInterstitial 
- (void)requestInterstitialWithCustomEventInfo:(NSDictionary *)info {
    NSString *gameId = [info objectForKey:@"gameId"];
    self.zoneId = [info objectForKey:@"zoneId"];
    [UnityAds initialize:gameId delegate:self];
}
- (void)showInterstitialFromRootViewController:(UIViewController *)rootViewController {
    [UnityAds show:rootViewController placementId:self.zoneId];
}

#pragma mark - UnityAdsDelegate
- (void) unityAdsReady:(NSString *)placementId{
    NSLog(@"UADS Ready");
    [self.delegate interstitialCustomEvent:self didLoadAd:placementId];
}
- (void)unityAdsDidStart:(NSString *)placementId{
    [self.delegate interstitialCustomEventDidAppear:self];
}
- (void)unityAdsDidError:(UnityAdsError)error withMessage:(NSString *)message{
    NSLog(@"UnityAds ERROR: %ld - %@",(long)error, message);
    [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:nil];
}
- (void)unityAdsDidFinish:(NSString *)placementId withFinishState:(UnityAdsFinishState)state{
    NSString *stateString = @"UNKNOWN";
    switch (state) {
        case kUnityAdsFinishStateError:
            stateString = @"ERROR";
            break;
        case kUnityAdsFinishStateSkipped:
            stateString = @"SKIPPED";
            break;
        case kUnityAdsFinishStateCompleted:
            stateString = @"COMPLETED";
            break;
        default:
            break;
    }
    NSLog(@"UnityAds FINISH: %@ - %@", stateString, self.zoneId);
}
@end
