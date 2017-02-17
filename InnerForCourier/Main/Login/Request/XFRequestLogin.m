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
                 success:(void (^)())success
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

@end
