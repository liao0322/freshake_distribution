//
//  AppDelegate.m
//  InnerForCourier
//
//  Created by DamonLiao on 2017/1/17.
//  Copyright © 2017年 DamonLiao. All rights reserved.
//

#import "AppDelegate.h"
#import "XFKVCPersistence.h"
#import "NSDate+Extension.h"

// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

#import "XFOrderDetailsViewController.h"

@interface AppDelegate ()<JPUSHRegisterDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window.backgroundColor = [UIColor whiteColor];
    [self setupJPUSHWithOptions:launchOptions];
    
    if ([XFKVCPersistence contain:KEY_ACCOUNT]) { // 已登录
        [self toMain];
    } else {
        [self toLogin];
    }
    
    return YES;
}

- (void)toLogin {
    [self setRootViewControllerWithIdentifier:@"LoginSB"];
}

- (void)toMain {
    [self setRootViewControllerWithIdentifier:@"TabBarSB"];
}

- (void)setRootViewControllerWithIdentifier:(NSString *)identifier {
    UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    [self restoreRootViewController:[mainSB instantiateViewControllerWithIdentifier:identifier]];
}

+ (AppDelegate *)appDelegate {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

#pragma mark - Custom

- (void)restoreRootViewController:(UIViewController *)rootViewController {
    typedef void (^Animation)(void);
    UIWindow* window = [UIApplication sharedApplication].delegate.window;
    rootViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    Animation animation = ^{
        BOOL oldState = [UIView areAnimationsEnabled];
        [UIView setAnimationsEnabled:NO];
        window.rootViewController = rootViewController;
        [UIView setAnimationsEnabled:oldState];
    };
    [UIView transitionWithView:window
                      duration:0.4f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:animation
                    completion:nil];
}

- (void)setupJPUSHWithOptions:(NSDictionary *)launchOptions {
    // 角标归0
    NSDictionary *remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (remoteNotification) {
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }
    
    // 初始化APNs
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    
    // 初始化JPush
    BOOL isProduction = YES;
    NSString *channel = @"AppStore";
#ifdef DEBUG
    isProduction = NO;
    channel = @"DEBUG";
#endif
    [JPUSHService setupWithOption:launchOptions appKey:AppKeyJPUSH
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}


- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    if ([XFKVCPersistence contain:KEY_ACCOUNT]) { // 已登录
        [self pushToOrderDetailsViewControllerWithUserInfo:userInfo];
        
    } else {
        [self toLogin];
    }
    
    completionHandler();  // 系统要求执行这个方法
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    [JPUSHService handleRemoteNotification:userInfo];
    
    application.applicationIconBadgeNumber = 0;
    
    if (completionHandler) {
        completionHandler(UIBackgroundFetchResultNewData);
    }
    
    // 收到推送消息
    if (application.applicationState == UIApplicationStateActive) {
        NSLog(@"%@",userInfo);
        
        if (application.applicationState == UIApplicationStateActive) {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"收到推送消息" message:userInfo[@"aps"][@"alert"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [self pushToOrderDetailsViewControllerWithUserInfo:userInfo];
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消 " style:UIAlertActionStyleCancel handler:nil];
            
            [alert addAction:confirmAction];
            [alert addAction:cancelAction];
            [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
        }
    }
    return;
}
- (void)pushToOrderDetailsViewControllerWithUserInfo:(NSDictionary *)userInfoDict {
    XFOrderDetailsViewController *orderDetailsVC = [XFOrderDetailsViewController new];
    
    orderDetailsVC.originalNo = userInfoDict[@"originalNo"];
    orderDetailsVC.originalId = userInfoDict[@"originalId"];
    orderDetailsVC.orderStatus = userInfoDict[@"orderStatus"];
    
    [(UINavigationController *)self.window.rootViewController pushViewController:orderDetailsVC animated:YES];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}

@end
