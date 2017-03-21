//
//  XFDataStatisticsRequest.m
//  InnerForCourier
//
//  Created by DamonLiao on 2017/3/21.
//  Copyright © 2017年 DamonLiao. All rights reserved.
//

#import "XFDataStatisticsRequest.h"
#import "XFOrderChart.h"

@implementation XFDataStatisticsRequest

// http://122.144.136.72:8050/mcapi/queryOrderChartCnt?syscode=002&dattype=su&shopid=11&userid=5&orderStatus=007

// http://122.144.136.72:8050/mcapi/queryOrderChartList?syscode=002&dattype=su&shopid=11&userid=5&orderStatus=007


+ (void)orderCountWithOrderStatus:(NSString *)orderStatus
                          success:(void (^)(NSString *countString))success
                          failure:(Failed)failure {
    
    NSString *shopId = [XFKVCPersistence get:KEY_USER_OWNERID];
    NSString *userId = [XFKVCPersistence get:KEY_USER_ID];
    NSString *URLString = [NSString stringWithFormat:@"http://122.144.136.72:8050/mcapi/queryOrderChartCnt?syscode=002&dattype=su&shopid=%@&userid=%@&orderStatus=%@", shopId, userId, orderStatus];
    
    [XFNetworking GET:URLString parameters:nil success:^(id responseObject, NSInteger statusCode) {
        NSDictionary *dict = [self dictWithData:responseObject];
        NSString *resultString = @"0";
        
        if (statusCode != 200 || dict.count == 0 || dict == nil) {
            if (success) {
                success(resultString);
            }
            return;
        }
        resultString = [dict[KEY_RESULT] stringValue];
        if (success) {
            success(resultString);
        }
    } failure:^(NSError *error, NSInteger statusCode) {
        if (failure) {
            failure(error, statusCode);
        }
    }];
}

+ (void)orderListWithStartDate:(NSString *)startDate
                       Success:(SuccessWithArray)success
                       failure:(Failed)failure {
    NSString *shopId = [XFKVCPersistence get:KEY_USER_OWNERID];
    NSString *userId = [XFKVCPersistence get:KEY_USER_ID];
    NSString *URLString = [NSString stringWithFormat:@"http://122.144.136.72:8050/mcapi/queryOrderChartList?syscode=002&dattype=su&shopid=%@&userid=%@&orderStatus=007&startDate=%@", shopId, userId, startDate];
    
    [XFNetworking GET:URLString parameters:nil success:^(id responseObject, NSInteger statusCode) {
        NSDictionary *dict = [self dictWithData:responseObject];
        NSArray *dataArray = nil;
        if (statusCode != 200 || dict.count == 0 || dict == nil) {
            if (success) {
                success(dataArray, statusCode);
            }
            return;
        }
        dataArray = dict[KEY_RESULT];
        NSArray *modelArray = [XFOrderChart mj_objectArrayWithKeyValuesArray:dataArray];
        if (success) {
            success(modelArray, statusCode);
        }
    } failure:^(NSError *error, NSInteger statusCode) {
        if (failure) {
            failure(error, statusCode);
        }
    }];
}



@end
