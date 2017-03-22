//
//  XFDataStatisticsRequest.h
//  InnerForCourier
//
//  Created by DamonLiao on 2017/3/21.
//  Copyright © 2017年 DamonLiao. All rights reserved.
//

#import "XFBaseRequest.h"

@interface XFDataStatisticsRequest : XFBaseRequest

+ (void)orderCountWithOrderStatus:(NSString *)orderStatus
                          success:(void (^)(NSString *countString))success
                          failure:(Failed)failure;

+ (void)orderListWithEndDate:(NSString *)startDate
                       Success:(SuccessWithArray)success
                       failure:(Failed)failure;


@end
