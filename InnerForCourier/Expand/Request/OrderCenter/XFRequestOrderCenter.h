//
//  XFRequestOrderCenter.h
//  InnerForCourier
//
//  Created by DamonLiao on 2017/2/7.
//  Copyright © 2017年 DamonLiao. All rights reserved.
//

#import "XFBaseRequest.h"
#import "URLOrderCenter.h"
#import "XFRequestOrderCenterKeys.h"
@class XFOrderDetailsModel;
@class XFExpress;

@interface XFRequestOrderCenter : XFBaseRequest


/**
 帐号和密码登录请求

 @param account 帐号
 @param password 密码
 @param success 成功的回调
 @param failure 失败的回调
 */
+ (void)loginWithAccount:(NSString *)account
                password:(NSString *)password
                 success:(void (^)())success
                 failure:(Failed)failure;


/**
 获取订单列表请求

 @param pageNum 第几页
 @param pageSize 订单数量
 @param shopid 门店仓库id
 @param orderStatus 订单状态
 */
+ (void)orderListWithPageNum:(NSInteger)pageNum
                    pageSize:(NSInteger)pageSize
                      shopid:(NSString *)shopid
                 orderStatus:(NSString *)orderStatus
                     success:(SuccessWithArray)success
                     failure:(Failed)failure;


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


/**
 获取某个订单的详情

 @param orderId 订单ID
 */
+ (void)orderDetailsWithOrderId:(NSString *)orderId
                        success:(void (^)(XFOrderDetailsModel *orderDetailsModel))success
                        failure:(Failed)failure;


/**
 订单相关操作

 @param syscode 系统编码 {仓库app=001，派送员app=002，鲜摇派商城：003}
 @param originalNo 第三方订单编码
 @param sourceCode 来源编码{订单中心=0,鲜摇派商城=1}，默认1
 @param usercode 当前用户标示 usercode
 @param bizcode 业务类型编码
 仓库app{确认订单=CONF，分拣=SORT，打包=PACK，出库=OUTS}，派送员app{开始配送=DELV，配送完成=FINH} ，操作标示不区分大小写
 */
+ (void)orderOperationWithSyscode:(NSString *)syscode
                       originalNo:(NSString *)originalNo
                       sourceCode:(NSString *)sourceCode
                         usercode:(NSString *)usercode
                          bizcode:(NSString *)bizcode
                          success:(void (^)())success
                          failure:(Failed)failure;




@end
