//
//  XFRequestOrderCenter.m
//  InnerForCourier
//
//  Created by DamonLiao on 2017/2/7.
//  Copyright © 2017年 DamonLiao. All rights reserved.
//

#import "XFRequestOrderCenter.h"
#import "XFOrder.h"
#import "XFUser.h"
#import "XFExpress.h"
#import "XFOrderDetailsModel.h"

@implementation XFRequestOrderCenter

+ (void)loginWithAccount:(NSString *)account
                password:(NSString *)password
                 success:(void (^)())success
                 failure:(Failed)failure {
    
    NSDictionary *parametersDict = @{
                                     @"usercode": account,
                                     @"userpwd": password,
                                     @"syscode": @"002"
                                     };
    
    [XFNetworking POST:URLUserLogin() parameters:parametersDict success:^(id responseObject, NSInteger statusCode) {
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
        
        // 登录成功
        [XFKVCPersistence setValue:dict[KEY_RESULT][KEY_USER_CODE] forKey:KEY_ACCOUNT];
        [XFKVCPersistence setValue:password forKey:KEY_PASSWORD];
        NSDictionary *userDict = dict[KEY_RESULT][KEY_USER];
        [XFKVCPersistence setValue:userDict[KEY_USER_ID] forKey:KEY_USER_ID];
        [XFKVCPersistence setValue:userDict[KEY_USER_NAME] forKey:KEY_USER_NAME];
        [XFKVCPersistence setValue:userDict[KEY_USER_STATUS] forKey:KEY_USER_STATUS];
        [XFKVCPersistence setValue:userDict[KEY_USER_OWNERID] forKey:KEY_USER_OWNERID];
        [XFKVCPersistence setValue:userDict[KEY_USER_TYPE] forKey:KEY_USER_TYPE];
        
        if (success) {
            success();
        }
    } failure:^(NSError *error, NSInteger statusCode) {
        if (failure) {
            failure(error, statusCode);
        }
    }];
}

+ (void)orderListWithPageNum:(NSInteger)pageNum
                    pageSize:(NSInteger)pageSize
                      shopid:(NSString *)shopid
                 orderStatus:(NSString *)orderStatus
                     success:(SuccessWithArray)success
                     failure:(Failed)failure {
    NSDictionary *parametersDict = @{
                                     @"pageNum": @(pageNum),
                                     @"pageSize": @(pageSize),
                                     @"shopid": shopid,
                                     @"orderStatus": orderStatus
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
        
        if (!dictData[KEY_RESULT][KEY_ROWS]) {
            if (success) {
                success(nil, statusCode);
            }
        }
        NSArray *dataArray = [XFOrder mj_objectArrayWithKeyValuesArray:dictData[KEY_RESULT][KEY_ROWS]];
        if (success) {
            success(dataArray, statusCode);
        }
        NSLog(@"%@", dataArray);
    } failure:^(NSError *error, NSInteger statusCode) {
        if (failure) {
            failure(error, statusCode);
        }
    }];
    
}

+ (void)orderExpressWithOriginalNo:(NSString *)originalNo
                        sourceCode:(NSString *)sourceCode
                           syscode:(NSString *)syscode
                           success:(SuccessWithArray)success
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
                success(nil, statusCode);
            }
            return;
        }
        if (!dictData[KEY_RESULT]) {
            if (success) {
                success(nil, statusCode);
            }
        }
        NSArray *dataArray = [XFExpress mj_objectArrayWithKeyValuesArray:dictData[KEY_RESULT]];
        if (success) {
            success(dataArray, statusCode);
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
    [XFNetworking GET:@"http://h5.freshake.cn/api/Phone/Fifth/index.aspx" parameters:parametersDict success:^(id responseObject, NSInteger statusCode) {
        NSDictionary *dict = [self dictWithData:responseObject];
        if (!dict) {
            [XFProgressHUD showMessage:@"数据解析失败"];
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
