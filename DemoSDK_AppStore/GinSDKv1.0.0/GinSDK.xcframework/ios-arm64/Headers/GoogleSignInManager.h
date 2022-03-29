//
//  GoogleSignInManager.h
//  GameSDK
//
//  Created by Nero-Macbook on 11/10/21.
//
#import <UIKit/UIKit.h>
#import "UserProfileResponse.h"

@interface GoogleSignInManager : NSObject {
    
}
+ (GoogleSignInManager *) sharedInstance;
- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options;
- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
- (void) showSignIn:(UIViewController *)viewMain andUserProfileCallback:(void (^)(UserProfileResponse *))userProfileCallback;
- (void) signOut;
@end
