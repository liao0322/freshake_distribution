//
//  XFBaseRequest.h
//  InnerForCourier
//
//  Created by DamonLiao on 2017/2/7.
//  Copyright © 2017年 DamonLiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XFNetworking.h"

/** 请求成功的Block */
typedef void(^Success)(id responseObject, NSInteger statusCode);

/** 请求失败的Block */
typedef void(^Failed)(NSError *error, NSInteger statusCode);

typedef void(^SuccessWithArray)(NSArray *dataArray, NSInteger statusCode);


@interface XFBaseRequest : NSObject

+ (NSDictionary *)dictWithData:(NSData *)data;

+ (void)handleCode:(NSString *)code;

@end
