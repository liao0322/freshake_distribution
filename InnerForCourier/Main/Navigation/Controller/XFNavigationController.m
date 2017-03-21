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

#pragma mark - Override

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (self.viewControllers.count != 0) {
        
        [viewController setHidesBottomBarWhenPushed:YES];
    }
    
    [super pushViewController:viewController animated:animated];
}

@end
