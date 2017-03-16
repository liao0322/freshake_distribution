//
//  XFBaseRequest.m
//  InnerForCourier
//
//  Created by DamonLiao on 2017/2/7.
//  Copyright © 2017年 DamonLiao. All rights reserved.
//

#import "XFBaseRequest.h"

static NSDictionary* codeDict;

@implementation XFBaseRequest

+ (void)initialize {
    codeDict = @{
                  @"0": @"成功",
                  @"000001": @"系统异常",
                  @"000002": @"参数异常",
                  @"000101": @"身份异常，非法请求！",
                  @"000102": @"请求超时！",
                  @"000103": @"当前接口无调用权限！",
                  @"010101": @"账号或密码不正确！",
                  @"010102": @"当前账号不存在！",
                  @"010103": @"当前账号不允许登录该应用！",
                  @"010203": @"当前用户已存在！",
                  @"020101": @"无效订单！",
                  @"020102": @"当前订单已取消",
                  @"020201": @"当前订单已确认！",
                  @"020202": @"当前订单已分拣！",
                  @"020203": @"当前订单已打包！",
                  @"020204": @"当前订单已出库！",
                  @"020205": @"当前用户没有重现分仓权限！",
                  @"020301": @"当前订单已开始配送！",
                  @"020302": @"当前订单已配送完成！"
                  };
}

+ (NSDictionary *)dictWithData:(NSData *)data {
    NSError *error = nil;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    return error ? nil : dict;
}

+ (void)handleCode:(NSString *)code {
    [XFProgressHUD showMessage:codeDict[code]];
}
@end
