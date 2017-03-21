//
//  XFOrderChart.h
//  InnerForCourier
//
//  Created by DamonLiao on 2017/3/21.
//  Copyright © 2017年 DamonLiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XFModel.h"

@interface XFOrderChart : XFModel

// 门店|仓库
@property (copy, nonatomic) NSString *shopId;
// 门店|仓库名称
@property (copy, nonatomic) NSString *shopName;
// 操作用户
@property (copy, nonatomic) NSString *userId;
// 操作用户姓名
@property (copy, nonatomic) NSString *userName;
// 操作日期
@property (copy, nonatomic) NSString *operDate;
// 操作类型
@property (copy, nonatomic) NSString *operType;// orderStatus
// 操作订单量
@property (copy, nonatomic) NSString *cnt;

@end
