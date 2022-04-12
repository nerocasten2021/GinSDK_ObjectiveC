//
//  AppsflyerManager.h
//  GameSDK
//
//  Created by Nero-Macbook on 11/10/21.
//

#import <Foundation/Foundation.h>
#import <AppsFlyerLib/AppsFlyerLib.h>

@interface AppsflyerManager : NSObject {
    
}

+ (AppsflyerManager *) sharedInstance;
- (void) initAppsFlyer;
- (void) startAppsflyer;
- (void) startAppsflyerWithInterval;
- (void) setCustomerUserID:(NSString *)customerUserID;
- (void) trackingLaunchOnAF;
- (void) trackingUninstallOnAF:(NSData *)deviceToken;
- (void) trackingEventOnAF:(NSString *)eventName withValues:(NSDictionary*)values;
//call from game client
- (void) trackingTurialCompletedEventOnAF;
- (void) trackingLevelArchiveEventOnAF:(NSString *)level;
- (void) trackingArchiveUnlockEventOnAF:(NSString *)level;
- (void) trackingSpentCreditEventOnAF:(NSString *)level;
- (void) trackingStartTrialEventOnAF;
@end
