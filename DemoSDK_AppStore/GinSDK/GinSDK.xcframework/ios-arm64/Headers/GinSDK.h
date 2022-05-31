//
//  GinSDK.h
//  GinSDK
//
//  Created by Nero-Macbook on 3/26/22.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LoginDelegate.h"
#import "AppleIAP.h"

#import "IdAppTracking.h"
#import "FacebookManager.h"
#import "AppsflyerManager.h"
#import "FirebaseManager.h"
#import "AppleIAP.h"

@interface GinSDK : NSObject

+ (GinSDK *) sharedInstance;
+ (AppsflyerManager *) AppsFlyer;
+ (FirebaseManager *) Firebase;
+ (IdAppTracking *) ServerIdTracking;
+ (FacebookManager *) Facebook;
+ (AppleIAP *) AppleIAP;


- (void) initSdk:(void(^)(NSString *)) initStatus;
- (void)showSignInView:(UIViewController *)viewParent andResultDelegate:(id<LoginDelegate>) loginResultDelegate;
- (void) IDSignOut:(id<LogoutDelegate>) logoutDelegate;
//IAP
- (void) showIAP:(IAPDataRequest *) iapData andMainView:(UIViewController *) mainView andIAPDelegate:(id) iAPDelegate;
//tracking
- (void)applicationDidBecomeActive:(UIApplication *)application;
- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options;
- (BOOL)applicationDelegate:(id)appDelegate andApplication:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
@end
