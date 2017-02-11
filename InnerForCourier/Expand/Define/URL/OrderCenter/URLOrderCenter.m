//
//  URLOrderCenter.m
//  InnerForCourier
//
//  Created by DamonLiao on 2017/2/6.
//  Copyright © 2017年 DamonLiao. All rights reserved.
//

#import "URLOrderCenter.h"
#import "URLBase.h"


NSString *URLPath() {
    return [NSString stringWithFormat:@"%@ordercenter/ocapi/", URLBaseDomain()];
}


NSString *URLUserLogin() {
    return [NSString stringWithFormat:@"%@authUser", URLPath()];
}

NSString *URLOrderList() {
    return [NSString stringWithFormat:@"%@queryOrderList", URLPath()];
}

NSString *URLExpress() {
    return [NSString stringWithFormat:@"%@queryOrderExpress", URLPath()];
}

NSString *URLOrderOperation() {
    return [NSString stringWithFormat:@"%@operOrderBiz", URLPath()];
}
