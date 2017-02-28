//
//  AppDelegate.m
//  InnerForCourier
//
//  Created by DamonLiao on 2017/1/17.
//  Copyright © 2017年 DamonLiao. All rights reserved.
//

#import "AppDelegate.h"
#import "XFKVCPersistence.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
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
    [self setRootViewControllerWithIdentifier:@"NavigationSB"];
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


@end
