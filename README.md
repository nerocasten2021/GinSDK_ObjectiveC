# IOS GinSDK

[![Platforms](https://img.shields.io/cocoapods/p/FBSDKCoreKit.svg)]()

**This guide shows you how to integrate your iOS app using the GinSDK for iOS. The GinSDK for iOS consists of the following component SDKs:**
  - The GinSDK Core
  - Third-party framework: 
      - GoogleSigin SDK, Firebase SDK, Facebook SDK, AppsFlyer SDK
      - Grpc Framework (GRPCClient, ProtoBuf, ProtoRPC, RxLibrary, ...)
  - Ios version support: 11+
  
### FEATURES:
  - Login: Authenticate people with their my server ID, Google and Facebook credentials.
  - Payment IAP: Pay to buy products from in-app
  - Track Events: Track events with third parties including Appsflyer and Firebase tracking
  - You will need some included keys: GameClientID, GameSDKSignature, GoogleAppID, FacebookAppID, FacebookClientToken and GoogleService-Info.plist file

# Try It Out

* Download [GinSDK latest and Third party](https://github.com/nerocasten2021/GinSDK_ObjectiveC/releases/)
* GoogleService-Info.plist: send via mail
* Install the following: App Tracking Transparency framework only available starting from Xcode 12 or later-The SDK supports iOS11+

# Integrate

- Embed GinSDK latest version and Third party framework into your project
- Some other libraries: 
  - AuthenticationServices.framework
  - MediaPlayer.framework
  - MobileCoreServices.framework
  - SystemConfiguration.framework
  - MessageUI.framework
  - Accelerate.framework
- Adding Capabilities: Sign-in with Apple, Push Notifications

### With Facebook IOS SDK version 13 or latest
  - Create a swift file (arbitrary name), confirm "Create Bridging Header" when prompt appear
  - Enable Modules (C and Objective-C) set to YES: Target --> Build Settings --> Enable Modules (C and Objective-C)

### GRPC Framework Embed
  ![image](https://user-images.githubusercontent.com/94542020/160530360-23295245-4eb7-4f0b-b04b-cbcfee270a7e.png)

# Configuration
- Insert -ObjC -lc++ -lz to “Other Linker Flags ”on Xcode Project: Main target -> build settings -> search "other linker flags"
- Configure Tracking Usage Description into .plist file (default: info.plist)*.
  Open with source and insert code: 
  ```xml
  <key>NSUserTrackingUsageDescription</key>
  <string>This identifier will be used to deliver personalized ads to you.</string>
  ```
- Configure GameClientID into .plist file (default: info.plist)*. IN the <string> tag, key GameClientID will be provided privately via email
```xml
<key>GameClientID</key>
<string>GameClientID</string>
```
- Configure GameSDKSignature into .plist file (default: info.plist)*. IN the <string> tag, key GameSDKSignature will be provided privately via email
```xml
<key>GameSDKSignature</key>
<string>GameSDKSignature</string>
```
### Configure GoogleSignIn in your project (default info.plist)
  ** Refer [Get started with Google Sign-In for iOS](https://developers.google.com/identity/sign-in/ios/start-integrating) **
  ```xml
   <key>GoogleAppID</key>
   <string>1234567890-abcdefg.apps.googleusercontent.com</string>
   <key>CFBundleURLTypes</key>
   <array>
    <dict>
       <key>CFBundleURLSchemes</key>
       <array>
          <string>com.googleusercontent.apps.1234567890-abcdefg</string>
       </array>
    </dict>
   </array>
  ```
  
### Configure FacebookSDK in your project (default info.plist)
** Refer [Facebook get started](https://developers.facebook.com/docs/ios/getting-started#step-2---configure-your-project) **
```xml
<key>FacebookAppID</key>
<string>FacebookAppID</string>
<key>FacebookClientToken</key>
<string>CLIENT-TOKEN</string>
<key>FacebookDisplayName</key>
<string>FacebookDisplayName</string>
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>fbFacebookAppID</string>
    </array>
  </dict>
</array>
<key>LSApplicationQueriesSchemes</key>
<array>
  <string>fbapi</string>
  <string>fbapi20130214</string>
  <string>fbapi20130410</string>
  <string>fbapi20130702</string>
  <string>fbapi20131010</string>
  <string>fbapi20131219</string>
  <string>fbapi20140410</string>
  <string>fbapi20140116</string>
  <string>fbapi20150313</string>
  <string>fbapi20150629</string>
  <string>fbapi20160328</string>
  <string>fbauth</string>
  <string>fb-messenger-share-api</string>
  <string>fbauth2</string>
  <string>fbshareextension</string>
</array>
```
* Replace APP-ID with FacebookApp ID
* In the key FacebookClientToken, replace CLIENT-TOKEN 
* In the key FacebookDisplayName, replaceAPP-NAME with the name of provided.

### Add services and SDK related resource library
1. The file Appdelegate.m configuration instructions are as follows:
```objectivec
#import "GinSDK.h"
#import <UserNotifications/UserNotifications.h>
@interfaceAppDelegate()<FIRMessagingDelegate, UNUserNotificationCenterDelegate>
@end
```
2. Add openURL
```objectivec
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    if (@available(iOS 9.0, *)) {
        BOOL handled = [[GinSDK sharedInstance] application:application openURL:url options:options];
        return handled;
    } else {
        return YES;
    }
}
```
3. Add didFinishLaunchingWithOption
```objectivec
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //your code
    
    //GinSDK
    [[GinSDK sharedInstance] applicationDelegate:self andApplication:application didFinishLaunchingWithOptions:launchOptions];
    [[GinSDK sharedInstance] initSdk:^(NSString *initStatus) {
        NSLog(@"initStatus = %@", initStatus);
        if ([initStatus isEqual:@"success"]) {
            NSLog(@"Gin init ok");
        } else {
            NSLog(@"Gin init failed");
        }
    }];
    return YES;
}
```
4. Add applicationDidBecomeActive
```objectivec
- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"applicationDidBecomeActive");
    [[GinSDK sharedInstance] applicationDidBecomeActive:application];
    application.applicationIconBadgeNumber = 0;
}
```
5. Add applicationWillTerminate
```objectivec
- (void)applicationWillTerminate:(UIApplication *)application {
    //reset owner billing had payment
    [[GinSDK AppleIAP] terminateIAP];
}
```
6. Registration FCM token and message
```objectivec
- (void)messaging:(FIRMessaging *)messaging didReceiveRegistrationToken:(NSString *)fcmToken {
    [[GinSDK Firebase] messaging:messaging didReceiveRegistrationToken:fcmToken];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"APNs Unable to register for remote notifications: %@", error);
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  [[GinSDK sharedInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
    NSLog(@"APNs device token retrieved: %@", deviceToken);
    [[GinSDK sharedInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application 
        didReceiveRemoteNotification:(NSDictionary *) userInfo {
    NSLog(@"APNs full message. %@", userInfo);
}
- (void)application:(UIApplication *)application 
      didReceiveRemoteNotification:(NSDictionary *) userInfo
          fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // Print full message.
    NSLog(@"APNs receive_message %@", userInfo);
    completionHandler(UIBackgroundFetchResultNewData);
}
// [START ios_10_message_handling]
// Receive displayed notifications for iOS 10 devices.
// Handle incoming notification messages while app is in the foreground.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler API_AVAILABLE(ios(10.0)){
    NSDictionary *userInfo = notification.request.content.userInfo;
    // Print full message.
    [[GinSDK Firebase] showInAppMessage:userInfo];
    // Change this to your preferred presentation option
    completionHandler(UNNotificationPresentationOptionBadge);
}

// Handle notification messages after display notification is tapped by the user.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void(^)(void))completionHandler {
  NSDictionary *userInfo = response.notification.request.content.userInfo;
    [[GinSDK Firebase] showInAppMessage:userInfo];
  completionHandler();
}
// [END ios_10_message_handling]
```

# API description and usage
## Initialize GinSDK
```objectivec
#import "GinSDK.h"
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[GinSDK sharedInstance] initSdk:^(NSString *initStatus) {
        NSLog(@"initStatus = %@", initStatus);
        if ([initStatus isEqual:@"success"]) {
            NSLog(@"Gin init ok");
        } else {
            NSLog(@"Gin init failed");
        }
    }];
    //...
}
```
## Initialize SDK delegate
```objectivec
//MainViewController.h
@interface MainViewController:UIViewController<UIActionSheetDelegate, SKProductsRequestDelegate, LoginDelegate, IAPDelegate> {
}
```
```objectivec
//MainViewController.m
#pragma Login Delegate
- (void)loginSuccess:(NSString *)userID andUserName:(NSString *)userName andAccessToken:(NSString *)access_token {
}
- (void)loginFail:(NSString *)message {
}
#pragma Logout Delegate
- (void) logoutSuccess{
}
#pragma IAP Delegate
- (void) IAPInitFailed:(NSString *)message andErrorCode:(NSString *)errorCode {
}
- (void) IAPPurchaseFailed:(NSString *)message andErrorCode:(NSString *)errorCode {
}
- (void) IAPCompleted:(NSString *)message{
}
```
## Show Login/Logout Interface
```objectivec
[[GinSDK sharedInstance] showSignInView:self andResultDelegate:self];
//showSignInView: use as main view controller
//andResultDelegate: use as Login Delegate
[[GinSDK sharedInstance] IDSignOut:self];
//use as Logout Delegate
```
## Using IAP
*** appleSecret default is empty (ex: @""), this will change when we send the request to you
  
```objectivec
IAPDataRequest *iapData = [[IAPDataRequest alloc] 
          initWithData:_userName 
          andOrderId:orderID 
          andOrderInfo:orderInfo 
          andServerID:server 
          andAmount:amount 
          andAppleProductID:productID 
          andAppleShareSecrect:appleSecret 
          andRoleID:character 
          andExtraInfo:extraInfo];
[[GinSDK sharedInstance] showIAP:(IAPDataRequest *)iapData andMainView:self andIAPDelegate:self];
//andMainView: use as main view controller
//andIAPDelegate: use as IAP Delegate
```

# API Tracking Events
1. Tracking AppOpen On GinSDK
```objectivec
[[GinSDK ServerIdTracking] idAppTrackingOpen:serverID roleID:roleID roleName:roleName];
```
2. Tracking with Appsflyer
```objectivec
//Custom event:Custom event parameters will be provided separately
[[GinSDK AppsFlyer] trackingEventOnAF:@"eventName" withValues:(NSDictionary *)values];
//tracking start trial
[[GinSDK AppsFlyer] trackingStartTrialEventOnAF];
//tracking Turial Completion
[[GinSDK AppsFlyer] trackingTurialCompletedEventOnAF];
//tracking Spent Credit
[[GinSDK AppsFlyer] trackingSpentCreditEventOnAF:@"gamer_level"];
//tracking Level Achieved
[[GinSDK AppsFlyer] trackingLevelArchiveEventOnAF:@"gamer_level"];
//tracking Achievement unlocked
[[GinSDK AppsFlyer] trackingArchiveUnlockEventOnAF:@"gamer_level"];
```
3. Tracking with Firebase
```objectivec
//tracking start trial
[[GinSDK Firebase] trackingEventOnFirebase:@"eventName" parameters:@{@"eventEventLogKey":@"eventEventLogValue"}];
[[GinSDK Firebase] trackingScreenOnFirebase:@"screenName" screenClass:@"screenClass"];
[[GinSDK Firebase] setUserPropertiesOnFirebase:@"userValue" forName:@"usernameName"];
//    subscribe
[[GinSDK Firebase] FirebaseSubscribeToTopic:@"topicName"];
[[GinSDK Firebase] FirebaseUnSubscribeToTopic:@"topicName"];
```
  
By using the GinSDK for iOS you agree to these terms.
