//
//  AppDelegate.m
//  InnerForCourier
//
//  Created by DamonLiao on 2017/1/17.
//  Copyright © 2017年 DamonLiao. All rights reserved.
//

#import "AppDelegate.h"
#import "XFKVCPersistence.h"


@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    if ([XFKVCPersistence contain:@"account"]) {
        [self toMain];
    } else {
        [self toLogin];
    }
    
    return YES;
}

- (void)toLogin {
    UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    [self restoreRootViewController:[mainSB instantiateViewControllerWithIdentifier:@"LoginSB"]];
}

- (void)toMain {
    UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    [self restoreRootViewController:[mainSB instantiateViewControllerWithIdentifier:@"NavigationSB"]];
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
                      duration:0.7f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:animation
                    completion:nil];
}


@end
