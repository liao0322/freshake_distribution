//
//  XFOrderListSectionFooterView.h
//  InnerForCourier
//
//  Created by DamonLiao on 2017/2/4.
//  Copyright © 2017年 DamonLiao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XFOrder;

@interface XFOrderListSectionFooterView : UITableViewHeaderFooterView

@property (nonatomic) XFOrder *model;

@property (nonatomic) void(^viewOrderDetailsBlock)();
@property (nonatomic) void(^viewExpressBlock)();


@end
