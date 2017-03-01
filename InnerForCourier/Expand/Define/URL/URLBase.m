//
//  URLBase.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2016/12/6.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "URLBase.h"

NSString *URLBaseDomain() {
    NSString *domainUrlString = @"";
    
#ifdef BUILD_FOR_DEVELOP
    domainUrlString = @"http://test.freshake.cn:8090/ordercenter/ocapi/";
#elif defined BUILD_FOR_TEST
    domainUrlString = @"http://test.freshake.cn:8090/ordercenter/ocapi/";
#elif defined BUILD_FOR_RELEASE
    domainUrlString = @"http://oc.freshake.cn:8080/ocapi/";
#endif
    
    return domainUrlString;
}




