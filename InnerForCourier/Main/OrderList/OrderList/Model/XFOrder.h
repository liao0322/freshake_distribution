//
//  XFOrder.h
//  InnerForCourier
//
//  Created by DamonLiao on 2017/2/7.
//  Copyright © 2017年 DamonLiao. All rights reserved.
//

#import "XFModel.h"

@interface XFOrder : XFModel

/**
 第三方订单编号
 */
@property (copy, nonatomic) NSString *originalNo;

/**
 * 第三方订单编号
 */
@property (copy, nonatomic) NSString *originalId;

/**
 订单状态
 */
@property (copy, nonatomic) NSString *orderStatus;

/**
 下单时间
 */
@property (copy, nonatomic) NSString *orderTime;

/**
 商品总数量
 */
@property (copy, nonatomic) NSString *goodsNum;


/**
 商品总金额
 */
@property (copy, nonatomic) NSString *orderAmt;


/**
 * 应付金额
 */
@property (copy, nonatomic) NSString *payableAmt;


/**
 * 付款状态
 */
@property (copy, nonatomic) NSString *payStatus;


/**
 * 付款时间
 */
@property (copy, nonatomic) NSString *payTime;

/**
 * 实付金额
 */
@property (copy, nonatomic) NSString *realpayAmt;

/**
 * 下单用户id
 */
@property (copy, nonatomic) NSString *userId;

/**
 * 下单用户姓名
 */
@property (copy, nonatomic) NSString *userName;

/**
 * 下单用户手机号
 */
@property (copy, nonatomic) NSString *userPhone;

/**
 * 下单用户地址
 */
@property (copy, nonatomic) NSString *userAddress;

/**
 * 收货人id
 */
@property (copy, nonatomic) NSString *revUserId;

/**
 * 收货人姓名
 */
@property (copy, nonatomic) NSString *revUserName;

/**
 * 收货人手机号
 */
@property (copy, nonatomic) NSString *revUserPhone;

/**
 * 收货城市
 */
@property (copy, nonatomic) NSString *revUserCity;

/**
 * 收货地址
 */
@property (copy, nonatomic) NSString *revUserAddress;

/**
 * 分仓标识
 */
@property (copy, nonatomic) NSString *asmStaus;

/**
 * 派送门店id
 */
@property (copy, nonatomic) NSString *asmDevShopId;

/**
 * 分仓时间
 */
@property (copy, nonatomic) NSString *asmTime;

/**
 * 派送标识
 */
@property (copy, nonatomic) NSString *devStauts;

/**
 * 派送员id
 */
@property (copy, nonatomic) NSString *devUserId;

/**
 * 派送员姓名
 */
@property (copy, nonatomic) NSString *devUserName;

/**
 * 派送员手机号
 */
@property (copy, nonatomic) NSString *devUserPhone;

/**
 * 订单来源
 */
@property (copy, nonatomic) NSString *fromSource;

/**
 * 纬度
 */
@property (copy, nonatomic) NSString *longitude;

/**
 * 经度
 */
@property (copy, nonatomic) NSString *latitude;

/**
 * 分拣时间
 */
@property (copy, nonatomic) NSString *srtTime;

/**
 * 打包时间
 */
@property (copy, nonatomic) NSString *pckTime;

/**
 * 发货时间
 */
@property (copy, nonatomic) NSString *devTime;

/**
 * 完成时间
 */
@property (copy, nonatomic) NSString *cmpTime;

/**
 * 支付方式
 */
@property (copy, nonatomic) NSString *payType;

/**
 * 快递费
 */
@property (copy, nonatomic) NSString *expressFee;

/**
 * 优惠金额
 */
@property (copy, nonatomic) NSString *discAmt;

/**
 * 积分抵扣
 */
@property (copy, nonatomic) NSString *pointAmt;

/**
 * 赠送积分
 */
@property (copy, nonatomic) NSString *comPonits;

/**
 * 发票抬头
 */
@property (copy, nonatomic) NSString *invoiceTitle;

/**
 * 发票内容
 */
@property (copy, nonatomic) NSString *invoiceContent;

/**
 * 备注
 */
@property (copy, nonatomic) NSString *remark;

/** 客户自提 */
@property (copy, nonatomic) NSString *cpckStatus;

/**
 * 分配门店信息
 */
//private ShopEntity shop;

/**
 * 商品明细
 */
@property (copy, nonatomic) NSArray *goods;

/**
 * 付款流水
 */
@property (copy, nonatomic) NSArray *pays;

/**
 * 赠送积分流水
 */
@property (copy, nonatomic) NSArray *points;

/**
 * 订单跟踪信息
 */
@property (copy, nonatomic) NSArray *traces;




@end
