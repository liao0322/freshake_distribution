//
//  XFRequestLogin.h
//  InnerForCourier
//
//  Created by DamonLiao on 2017/2/17.
//  Copyright © 2017年 DamonLiao. All rights reserved.
//

#import "XFBaseRequest.h"
#import "XFRequestLoginKeys.h"

@interface XFRequestLogin : XFBaseRequest

/**
 帐号和密码登录请求
 
 @param account 帐号
 @param password 密码
 */
+ (void)loginWithAccount:(NSString *)account
                password:(NSString *)password
                 success:(void (^)())success
                 failure:(Failed)failure;

@end
