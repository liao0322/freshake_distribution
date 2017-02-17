//
//  XFRequestOrderCenter.m
//  InnerForCourier
//
//  Created by DamonLiao on 2017/2/7.
//  Copyright © 2017年 DamonLiao. All rights reserved.
//

#import "XFRequestOrderCenter.h"
#import "XFOrder.h"
#import "XFExpressList.h"
#import "XFOrderDetailsModel.h"
#import "XFExpress.h"

@implementation XFRequestOrderCenter

+ (void)orderListWithPageNum:(NSInteger)pageNum
                    pageSize:(NSInteger)pageSize
                      shopid:(NSString *)shopid
                 orderStatus:(NSString *)orderStatus
                     success:(SuccessWithArray)success
                     failure:(Failed)failure {
    NSDictionary *parametersDict = @{
                                     KEY_PAGE_NUM: @(pageNum),
                                     KEY_PAGE_SIZE: @(pageSize),
                                     KEY_SHOP_ID: shopid,
                                     KEY_ORDER_STATUS: orderStatus
                                     };
    
    [XFNetworking GET:URLOrderList() parameters:parametersDict success:^(id responseObject, NSInteger statusCode) {
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
                success(nil, statusCode);
            }
            return;
        }
        
        NSArray *rowsArray = dictData[KEY_RESULT][KEY_ROWS];
        
        if (rowsArray.count == 0) {
            if (success) {
                success(nil, statusCode);
            }
        }
        NSArray *dataArray = [XFOrder mj_objectArrayWithKeyValuesArray:dictData[KEY_RESULT][KEY_ROWS]];
        if (success) {
            success(dataArray, statusCode);
        }
    } failure:^(NSError *error, NSInteger statusCode) {
        if (failure) {
            failure(error, statusCode);
        }
    }];
    
}

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



+ (void)orderDetailsWithOrderId:(NSString *)orderId
                        success:(void (^)(XFOrderDetailsModel *orderDetailsModel))success
                        failure:(Failed)failure {
    NSDictionary *parametersDict = @{
                                     @"page": @"GetOrderInfo",
                                     @"id": orderId
                                     };
    
    // http://h5.freshake.cn/
    // http://122.144.136.72:9970/
    
    [XFNetworking GET:@"http://h5.freshake.cn/api/Phone/Fifth/index.aspx" parameters:parametersDict success:^(id responseObject, NSInteger statusCode) {
        NSDictionary *dict = [self dictWithData:responseObject];

        if (!dict) {
            if (success) {
                success(nil);
            }
            return;
        }
        XFOrderDetailsModel *model = [XFOrderDetailsModel mj_objectWithKeyValues:dict];
        if (success) {
            success(model);
        }
        
    } failure:^(NSError *error, NSInteger statusCode) {
        if (failure) {
            failure(error, statusCode);
        }
    }];
}

+ (void)orderOperationWithSyscode:(NSString *)syscode
                       originalNo:(NSString *)originalNo
                       sourceCode:(NSString *)sourceCode
                         usercode:(NSString *)usercode
                          bizcode:(NSString *)bizcode
                          success:(void (^)())success
                          failure:(Failed)failure {
    NSDictionary *parametersDict = @{
                                     @"syscode": syscode,
                                     @"originalNo": originalNo,
                                     @"sourceCode": sourceCode,
                                     @"usercode": usercode,
                                     @"bizcode": bizcode
                                     };
    
    [XFNetworking POST:URLOrderOperation() parameters:parametersDict success:^(id responseObject, NSInteger statusCode) {
        NSDictionary *dict = [self dictWithData:responseObject];
        if (!dict) {
            [XFProgressHUD showMessage:@"数据解析失败"];
            return;
        }
        NSString *code = dict[KEY_CODE];
        if (![code isEqualToString:@"0"]) {
            [self handleCode:code];
            return;
        }
        if (success) {
            success();
        }
        
    } failure:^(NSError *error, NSInteger statusCode) {
        if (failure) {
            failure(error, statusCode);
        }
    }];
    
}



@end
