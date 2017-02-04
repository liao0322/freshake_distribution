//
//  AppDelegate.h
//  InnerForCourier
//
//  Created by DamonLiao on 2017/1/17.
//  Copyright © 2017年 DamonLiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (AppDelegate *)appDelegate;

- (void)toLogin;

- (void)toMain;

@end

