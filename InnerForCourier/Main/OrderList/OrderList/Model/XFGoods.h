//
//  XFGoods.h
//  InnerForCourier
//
//  Created by DamonLiao on 2017/2/8.
//  Copyright © 2017年 DamonLiao. All rights reserved.
//

#import "XFModel.h"

@interface XFGoods : XFModel



/**
 * 订单id
 */
@property (copy, nonatomic) NSString *orderId;

/**
 * 商品id
 */
@property (copy, nonatomic) NSString *goodsId;

/**
 * 商品名称
 */
@property (copy, nonatomic) NSString *goodsName;

/**
 * 商品数量
 */
@property (copy, nonatomic) NSString *goodsQty;

/**
 * 计量单位
 */
@property (copy, nonatomic) NSString *goodsUnit;

/**
 * SKU编码
 */
@property (copy, nonatomic) NSString *skuCode;

/**
 * SKU名称
 */
@property (copy, nonatomic) NSString *skuName;

/**
 * 分类标识
 */
@property (copy, nonatomic) NSString *categroyCode;

/**
 * 分类名称
 */
@property (copy, nonatomic) NSString *categroyName;

/**
 * 品牌
 */
@property (copy, nonatomic) NSString *brand;

/**
 * 原始单价
 */
@property (copy, nonatomic) NSString *originalPrice;

/**
 * 销售单价
 */
@property (copy, nonatomic) NSString *salePrice;


@property (copy, nonatomic) NSString *goodImg;

@end
