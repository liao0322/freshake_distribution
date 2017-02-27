//
//  XFRequestLogin.m
//  InnerForCourier
//
//  Created by DamonLiao on 2017/2/17.
//  Copyright © 2017年 DamonLiao. All rights reserved.
//

#import "XFRequestLogin.h"
#import "URLLogin.h"


@implementation XFRequestLogin

+ (void)loginWithAccount:(NSString *)account
                password:(NSString *)password
                 success:(void (^)(NSDictionary *dict))success
                 failure:(Failed)failure {
    
    NSDictionary *parametersDict = @{
                                     KEY_USER_CODE: account,
                                     KEY_USER_PWD: password,
                                     KEY_SYSCODE: @"002"
                                     };
    
    [XFNetworking POST:URLUserLogin() parameters:parametersDict success:^(id responseObject, NSInteger statusCode) {
        NSDictionary *dict = [self dictWithData:responseObject];
        if (!dict) {
            [XFProgressHUD showMessage:@"数据解析失败"];
            if (success) {
                success(nil);
            }
            return;
        }
        NSString *code = dict[KEY_CODE];
        if (![code isEqualToString:@"0"]) {
            [self handleCode:code];
            if (success) {
                success(nil);
            }
            return;
        }
        // 登录成功
        if (success) {
            success(dict);
        }
    } failure:^(NSError *error, NSInteger statusCode) {
        if (failure) {
            failure(error, statusCode);
        }
    }];
}



@end
