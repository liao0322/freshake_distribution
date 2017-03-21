//
//  XFOrderListSectionHeaderView.h
//  InnerForCourier
//
//  Created by DamonLiao on 2017/2/4.
//  Copyright © 2017年 DamonLiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XFOrderListSectionHeaderView : UITableViewHeaderFooterView

@property (copy, nonatomic) NSString *orderNumber;
@property (copy, nonatomic) NSString *orderStatus;

@property (nonatomic) void(^startDeliverBlock)();
@property (nonatomic) void(^deliveryComplete)();

@end
