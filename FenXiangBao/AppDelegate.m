//
//  AppDelegate.m
//  h5App
//
//  Created by YuLinpo on 2016/12/16.
//  Copyright © 2016年 Yulinpo. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "LeadViewController.h"

#import "WXApi.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "macro.h"

#import "JPUSHService.h"
#import <AdSupport/AdSupport.h>
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate ()<WXApiDelegate, WeiboSDKDelegate, TencentSessionDelegate, JPUSHRegisterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
//    LeadViewController * leadVc = [[LeadViewController alloc]init];
//    leadVc.navigationController.navigationBarHidden = YES;
//    self.window.rootViewController = leadVc;
    HomeViewController * homeVC= [[HomeViewController alloc]init];
    homeVC.navigationController.navigationBarHidden = YES;
    self.window.rootViewController = homeVC;
    
    [self.window makeKeyAndVisible];
    
    //微信分享注册
    [WXApi registerApp:kWXAPPID];
    
    //微博注册
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:kWBAPPKEY];
    //qq注册
    [[TencentOAuth alloc] initWithAppId:kQQAPPKEY andDelegate:self];
    
    NSLog(@"%f", [[UIDevice currentDevice].systemVersion floatValue]);
    //极光推送
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        //iOS10以上
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    }else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //iOS8以上可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    }
    else {
        //iOS8以下categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
//    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
//    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
//    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    BOOL isProduction = YES;// NO为开发环境，YES为生产环境
    //广告标识符
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    //Required(2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    [JPUSHService setupWithOption:launchOptions appKey:jPushKey
                          channel:nil
                 apsForProduction:isProduction
            advertisingIdentifier:advertisingId];
    
    //极光推送登录成功
    NSNotificationCenter *jsPushLogin = [NSNotificationCenter defaultCenter];
    [jsPushLogin addObserver:self selector:@selector(networkDidLogin:) name:kJPFNetworkDidLoginNotification object:nil];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    [WXApi handleOpenURL:url delegate:self];
    [WeiboSDK handleOpenURL:url delegate:self];
    [TencentOAuth HandleOpenURL:url];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    [WXApi handleOpenURL:url delegate:self];
    [WeiboSDK handleOpenURL:url delegate:self];
    [TencentOAuth HandleOpenURL:url];
    return YES;
}

-(void)networkDidLogin:(NSNotification *)notification{
//    [[[UIAlertView alloc] initWithTitle:@"123" message:[JPUSHService registrationID] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:[JPUSHService registrationID] forKey:@"channel_id"];
}

#pragma mark 推送相关
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    NSLog(@"%@", userInfo);
    [self customReceivedRemoteMsg:userInfo];
}
- (void)customReceivedRemoteMsg:(NSDictionary *)userInfo
{
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    [JPUSHService setBadge:0];
        if ([[[self.window.rootViewController childViewControllers] lastObject] isKindOfClass:[HomeViewController class]]) {
            HomeViewController * home = (HomeViewController * )[[self.window.rootViewController childViewControllers] lastObject] ;
            NSString * webUrl = [userInfo objectForKey:@"htmlUrl"];
            if (webUrl && webUrl.length > 0) {
                [home setWebViewUrl:webUrl];
            }
        }else if ([[[self.window.rootViewController childViewControllers] lastObject] isKindOfClass:[LeadViewController class]]){
            LeadViewController * leadVc = (LeadViewController * )[[self.window.rootViewController childViewControllers] lastObject] ;
            NSString * webUrl = [userInfo objectForKey:@"htmlUrl"];
            if (webUrl && webUrl.length > 0) {
                leadVc.urlStr = webUrl;
            }

        }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"%@", userInfo);
    [self customReceivedRemoteMsg:userInfo];
}
// 在 iOS8 系统中，还需要添加这个方法。通过新的 API 注册推送服务
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#pragma mark JPUSHRegisterDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger options))completionHandler
{

}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler
{
    NSLog(@"%@", response.notification.request.content.userInfo);
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    [self customReceivedRemoteMsg:userInfo];
}

#pragma mark -- WeiboSDKDelegate
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response {
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        WBSendMessageToWeiboResponse* sendMessageToWeiboResponse = (WBSendMessageToWeiboResponse*)response;
        NSString* accessToken = [sendMessageToWeiboResponse.authResponse accessToken];
        if (accessToken)
        {
            self.wbtoken = accessToken;
        }
        NSString* userID = [sendMessageToWeiboResponse.authResponse userID];
        if (userID) {
            self.wbCurrentUserID = userID;
        }
    }
}

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request {
    
}
#pragma mark tencentDelegate
-(void)tencentDidLogin{

}

-(void)tencentDidNotLogin:(BOOL)cancelled{

}

-(void)tencentDidNotNetWork{

}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [JPUSHService setBadge:0];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
    [JPUSHService setBadge:0];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
