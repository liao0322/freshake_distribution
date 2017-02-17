//
//  URLLogin.m
//  InnerForCourier
//
//  Created by DamonLiao on 2017/2/17.
//  Copyright © 2017年 DamonLiao. All rights reserved.
//

#import "URLLogin.h"
#import "URLBase.h"

NSString *URLUserLogin() {
    return [NSString stringWithFormat:@"%@authUser", URLBaseDomain()];
}
