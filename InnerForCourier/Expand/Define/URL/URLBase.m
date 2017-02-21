//
//  URLBase.m
//  BuyVegetablesTreasure
//
//  Created by DamonLiao on 2016/12/6.
//  Copyright © 2016年 c521xiong. All rights reserved.
//

#import "URLBase.h"


/**
 0：开发环境
 1：测试环境
 2：生产环境
 */
#define DOMAIN_TYPE 1


NSString *URLBaseDomain() {
    
#if DOMAIN_TYPE == 0
    return @"http://122.144.136.72:8090/ordercenter/ocapi/";
#elif DOMAIN_TYPE == 1
    return @"http://oc.freshake.cn:8080/ocapi/";
#elif DOMAIN_TYPE == 2
    return @"";
#endif
}

/*
NSString *URLBasePath() {
    return [NSString stringWithFormat:@"%@%@", URLBaseDomain(), @"api/Phone/four/index.aspx"];
}
 */



