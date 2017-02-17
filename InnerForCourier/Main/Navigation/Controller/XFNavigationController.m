//
//  XFNavigationController.m
//  InnerForCourier
//
//  Created by DamonLiao on 2017/2/4.
//  Copyright © 2017年 DamonLiao. All rights reserved.
//

#import "XFNavigationController.h"

@interface XFNavigationController ()

@end

@implementation XFNavigationController

+ (void)initialize {
    
    UINavigationBar *navBar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[[XFNavigationController class]]];
    navBar.barTintColor = [UIColor colorDomina];
    
}


@end
