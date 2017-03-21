//
//  XFExpressDetailsRequest.m
//  InnerForCourier
//
//  Created by DamonLiao on 2017/2/23.
//  Copyright © 2017年 DamonLiao. All rights reserved.
//

#import "XFExpressDetailsRequest.h"
#import "URLOrderCenter.h"
#import "XFExpressList.h"
#import "XFExpress.h"

@implementation XFExpressDetailsRequest

+ (void)orderExpressWithOriginalNo:(NSString *)originalNo
                        sourceCode:(NSString *)sourceCode
                           syscode:(NSString *)syscode
                           success:(void(^)(NSArray *dataArray, NSInteger statusCode, XFExpress *express))success
                           failure:(Failed)failure {
    NSDictionary *parametersDict = @{
                                     @"originalNo": originalNo,
                                     @"sourceCode": sourceCode,
                                     @"syscode": syscode
                                     };
    [XFNetworking GET:URLExpress() parameters:parametersDict success:^(id responseObject, NSInteger statusCode) {
        if (statusCode != 200) {
            if (failure) {
                failure(nil, statusCode);
            }
            return;
        }
        NSDictionary *dictData = [self dictWithData:responseObject];
        NSString *code = dictData[KEY_CODE];
        if (![code isEqualToString:@"0"]) {
            [self handleCode:code];
            if (success) {
                success(nil, statusCode, nil);
            }
            return;
        }
        if (!dictData[KEY_RESULT]) {
            if (success) {
                success(nil, statusCode, nil);
            }
        }
        NSArray *dataArray = [XFExpressList mj_objectArrayWithKeyValuesArray:dictData[KEY_RESULT][KEY_EXPRESS_LIST]];
        XFExpress *express = [XFExpress mj_objectWithKeyValues:dictData[KEY_RESULT][KEY_EXPRESS]];
        
        if (success) {
            success(dataArray, statusCode, express);
        }
    } failure:^(NSError *error, NSInteger statusCode) {
        if (failure) {
            failure(error, statusCode);
        }
    }];
    
}

@end
