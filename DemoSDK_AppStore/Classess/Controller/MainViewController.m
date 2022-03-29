//
//  MainViewController.m
//  DemoGosuSDK
//
//  Created by Phan Phuoc Luong on 11/25/15.
//  Copyright © 2015 Phan Phuoc Luong. All rights reserved.
//
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPhone)
#define IS_IPHONE (!IS_IPAD)

#import "MainViewController.h"
#import "GinSDK.h"

@interface MainViewController ()<LoginDelegate, LogoutDelegate,IAPDelegate>

@end

@implementation MainViewController

#pragma Login Delegate
- (void)loginSuccess:(NSString *)userID andUserName:(NSString *)userName andAccessToken:(NSString *)access_token
{
    //result for game
    /*
     userID
     userName
     access_token
     */
    _userID         = userID;
    _userName       = userName;
    _access_token   = access_token;
    NSLog(@"loginSuccess = %@", userName);
    dispatch_block_t block = ^{
        //======== TEST =========//
        /*
        GameInfo *info = [GosuSDK sharedInstance].gameInfo;
        NSLog(@"ProviderID = %@, userID = %@, userName=%@", info.providerid, userID, userName);
         */
        
        //=== use for testDemo SDK ===//
        if (true) {
            self.lblName.text = userID;
            //set hidden all button
            [self.viewVaoGame setHidden:YES];
            [self.btn_invitefriend setHidden:NO];
            [self.btn_report setHidden:NO];
            [self.btn_Floating setHidden:NO];
            [self.btn_shareVideo setHidden:NO];
            [self.btn_clear setHidden:NO];
            [self.btn_IAP setHidden:NO];
            
            [self.btn_clear setTitle:@"(9) Logout" forState:UIControlStateNormal];
        }
    };
    //
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

- (void)loginFail:(NSString *)message
{
    dispatch_block_t block = ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Fail" message:message delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
        [alert show];
    };
    //
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}
#pragma Logout Delegate
- (void) logoutSuccess{
    dispatch_block_t block = ^{
        NSLog(@"Logout thanh cong");
    };
    //
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

- (void)logoutFail:(NSString *)message {
    NSLog(@"logout fail");
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //set hidden all button
    [_btn_invitefriend setHidden:YES];
    [_btn_report setHidden:YES];
    [_btn_Floating setHidden:YES];
    [_btn_shareVideo setHidden:YES];
    [_btn_clear setHidden:YES];
    [_btn_IAP setHidden:YES];
    [_aiv_loading stopAnimating];
    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayFCMToken:) name:@"FCMToken" object:nil];
    //    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(OrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void) displayFCMToken:(NSNotification *) notification {
    NSString* message = [NSString stringWithFormat:@" FCM token: %@ ", notification.userInfo[@"token"]];
    NSLog(@"%@", message);
    //_edtTokenPush.hidden = NO;
    //_edtTokenPush.text = message;
    //[_edtTokenPush sizeToFit];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (void)OrientationDidChange:(NSNotification*)notification
{
    //    CGSize size = [[UIScreen mainScreen] bounds].size;
    //    CGRect frame = self.view.frame;
    //    if(size.width == frame.size.width)
    //        return;
    
    //NSLog(@"w = %f, h = %f", size.width, size.height);
}

//=========== Payment Apple IAP ==============//
- (IBAction) callIAP:(id)sender
{
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Select ProductID" delegate:self cancelButtonTitle:@"Close" destructiveButtonTitle:nil otherButtonTitles:
                            @"ProductID 1 ($0.99)",
                            @"ProductID 2 ($1.99)",
                            @"ProductID 3 ($2.99)",
                            nil];
    if(!IS_IPAD)
        [popup showInView:[UIApplication sharedApplication].keyWindow];
    else
        [popup showFromRect:_btn_IAP.frame inView:self.view animated:YES];
}

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex >= 3)
        return;
    
    //product id get from apple id (các gói sản phẩm được tạo trên apple account)
    //    NSString *productID = @"aaa";[[[GosuSDK sharedInstance] gameInfo].arrProductIDs objectAtIndex:buttonIndex];
    //    NSLog(@"productList = %@", [[GameSDK sharedInstance] gameInfo].productIDList);
    //    NSString *productID = [[[GameSDK sharedInstance] gameInfo].productIDList objectAtIndex:buttonIndex];
    NSString *productID = @"com.megastudio.huyenthoai.pack1";
    /* password from apple share secret (chuỗi thông tin khi tạo các gói Automatically Renewable Subscription) - dùng để verify iap, trường hợp không phải gói Automatically Renewable Subscription thì để trống */
    NSString *appleSecret = @"";
    //orderID was gernarate from server game and only one (mã hoá đơn là duy nhất không được trùng)
    NSString *orderID = [NSString stringWithFormat:@"%i_10095276_2_13_11", (int)[[NSDate date] timeIntervalSince1970]];
    //description package will purchase (mô tả gói cần mua)
    NSString *orderInfo = @"Item 300 gold";
    //amount
    NSString *amount = @"22000";//this is amount of money (VNĐ)
    switch (buttonIndex) {
        case 0:
            amount = @"22000";
            orderInfo = @"Item 200 gold";
            break;
        case 1:
            amount = @"45000";
            orderInfo = @"Item 700 gold";
            break;
        case 2:
            amount = @"69000";
            orderInfo = @"Item 1000 gold";
            break;
    }
    orderInfo = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)orderInfo, NULL, CFSTR("?=&+"), kCFStringEncodingUTF8));
    //server
    NSString *server = @"22";
    NSString *character = @"Character_Name";
    NSString *extraInfo = @"Extra_Info";
    //Show log value of parameters
    NSLog(@"product_id:%@, apple_secret:%@, order_id:%@, orderInfo:%@, amount:%@, server:%@, username:%@", productID, appleSecret, orderID, orderInfo, amount, server, _userName);
    //
    IAPDataRequest *iapData = [[IAPDataRequest alloc] initWithData:_userName andOrderId:orderID andOrderInfo:orderInfo andServerID:server andAmount:amount andAppleProductID:productID andAppleShareSecrect:appleSecret andRoleID:character andExtraInfo:extraInfo];
    [[GinSDK sharedInstance] showIAP:(IAPDataRequest *)iapData andMainView:self andIAPDelegate:self];
}
- (void) IAPInitFailed:(NSString *)message andErrorCode:(NSString *)errorCode
{
    dispatch_block_t block = ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Init IAP Failed!" message:message delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
        [alert show];
    };
    //
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}
- (void) IAPPurchaseFailed:(NSString *)message andErrorCode:(NSString *)errorCode
{
    dispatch_block_t block = ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Purchase IAP Failed!" message:message delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
        [alert show];
    };
    //
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}
- (void) IAPCompleted:(NSString *)message
{
    dispatch_block_t block = ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Payment Success!" message:message delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
        [alert show];
    };
    //
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

- (void) loadAppleItemInfo
{
    //[[GosuSDK sharedInstance] getProductIdInfos:[[GosuSDK sharedInstance] gameInfo].arrProductIDs delegate:self];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    for (NSString *invalidId in response.invalidProductIdentifiers) {
        NSLog(@"Item invalid %@", invalidId);
        //show invalid
        break;
    }
    
    NSArray *rsProduct = response.products;
    for(SKProduct *product in rsProduct){
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
        [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [numberFormatter setLocale:product.priceLocale];
        NSString *formattedPrice = [numberFormatter stringFromNumber:product.price];
        NSLog(@"ProductId: %@ - Price: %@", product.productIdentifier, formattedPrice);
        //
        //update Game UI with price, currency, ...
    }
}

#pragma Click PlayGame
- (IBAction) call_VaoGame:(id)sender
{
    //    [_viewVaoGame setHidden:YES];
    //    [[GameSDK sharedInstance] showSignInView:self andResultDelegate:self];
    [[GinSDK sharedInstance] showSignInView:self andResultDelegate:self];
}

#pragma Logout
- (IBAction) call_refresh:(id)sender
{
    _lblName.text = @"";
    //    [[GosuSDK sharedInstance] logoutAccount:self];
    [_viewVaoGame setHidden:NO];
    [_btn_invitefriend setHidden:YES];
    [_btn_report setHidden:YES];
    [_btn_Floating setHidden:YES];
    [_btn_shareVideo setHidden:YES];
    [_btn_clear setHidden:YES];
    [_btn_IAP setHidden:YES];
    [[GinSDK sharedInstance] IDSignOut:self];
    [[GinSDK sharedInstance] showSignInView:self andResultDelegate:self];
}

- (IBAction)call_invitefriends:(id)sender
{
    //    [[GosuSDK sharedInstance] inviteFacebookFriends:self andImageUrl:@"https://gihot.vn/img/imgo.jpeg" andAppLink:@"http://taikinh.vn" FBInviteDelegate:nil];
}

- (IBAction) call_sharePhoto:(id)sender
{
    NSURL *photoURL = [NSURL URLWithString:@"http://taikinh.vn/cpanel/static/uploads/hinh-the-tuong_360x469/bach-ho_1.png"];
    NSData *data = [[NSData alloc] initWithContentsOfURL:photoURL];
    UIImage *image = [UIImage imageWithData:data];
    //maybe you can load image from your device to share
    
    //call share
    //    [[GosuSDK sharedInstance] sharePhotoToFacebook:self andImage:image andCaption:@"Caption" FBShareDelegate:self];
}

- (IBAction) call_shareLink:(id)sender
{
    //    [[GosuSDK sharedInstance] FirebaseSubscribeToTopic:@"titi"];
    NSLog(@"Nero FirebaseSubscribeToTopic");
    //    [[GosuSDK sharedInstance] shareLinkToFacebook:self andLink:[NSURL URLWithString:@"https://388.gsscdn.com/ShareFB.jpg"] andContentTitle:@"UTtile" andDescription:@"UDescription" FBShareDelegate:self];
}

- (IBAction) call_shareVideo:(id)sender
{
    [[GinSDK Facebook] shareVideoToFacebook:self andVideoURL:nil FBShareDelegate:self];
}

- (IBAction) call_appopenreport:(id)sender
{
    NSString *serverID = @"1";
    NSString *roleID = @"1234567";
    NSString *roleName = @"Hoàng Thanh Hà";
    //encode roleName
    roleName = [roleName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //call to SDK
        [[GinSDK ServerIdTracking] idAppTrackingOpen:serverID roleID:roleID roleName:roleName];
}

- (IBAction) call_Floating:(id)sender
{
}

- (void) callTrackingAFExample {
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
}

- (void) callTrackingFirebaseExample {
    //tracking start trial
        [[GinSDK Firebase] trackingEventOnFirebase:@"eventName" parameters:@{@"eventEventLogKey":@"eventEventLogValue"}];
        [[GinSDK Firebase] trackingScreenOnFirebase:@"screenName" screenClass:@"screenClass"];
        [[GinSDK Firebase] setUserPropertiesOnFirebase:@"userValue" forName:@"usernameName"];
    //    subscribe
        [[GinSDK Firebase] FirebaseSubscribeToTopic:@"topicName"];
        [[GinSDK Firebase] FirebaseUnSubscribeToTopic:@"topicName"];
}
- (void)encodeWithCoder:(nonnull NSCoder *)coder {

    
}

@end
