//
//  XFExpressDetailsRequest.h
//  InnerForCourier
//
//  Created by DamonLiao on 2017/2/23.
//  Copyright © 2017年 DamonLiao. All rights reserved.
//

#import "XFBaseRequest.h"
#import "XFExpressDetailsRequestKeys.h"
@class XFExpress;

@interface XFExpressDetailsRequest : XFBaseRequest

/**
 获取订单物流信息请求
 
 @param originalNo 订单编号
 @param sourceCode 来源编码{订单中心=001,鲜摇派商城=002}
 @param syscode 系统编码 {仓库app=001，派送员app=002，鲜摇派商城：003}
 */
+ (void)orderExpressWithOriginalNo:(NSString *)originalNo
                        sourceCode:(NSString *)sourceCode
                           syscode:(NSString *)syscode
                           success:(void(^)(NSArray *dataArray, NSInteger statusCode, XFExpress *express))success
                           failure:(Failed)failure;

@end
