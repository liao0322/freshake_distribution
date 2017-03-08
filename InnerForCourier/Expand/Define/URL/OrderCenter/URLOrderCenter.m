//
//  URLOrderCenter.m
//  InnerForCourier
//
//  Created by DamonLiao on 2017/2/6.
//  Copyright © 2017年 DamonLiao. All rights reserved.
//

#import "URLOrderCenter.h"


NSString *URLOrderList() {
    return [NSString stringWithFormat:@"%@queryOrderList", URLBaseDomain()];
}

NSString *URLExpress() {
    return [NSString stringWithFormat:@"%@queryOrderExpress", URLBaseDomain()];
}

NSString *URLOrderOperation() {
    return [NSString stringWithFormat:@"%@operOrderBiz", URLBaseDomain()];
}
