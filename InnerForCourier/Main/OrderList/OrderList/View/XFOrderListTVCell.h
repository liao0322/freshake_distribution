//
//  XFOrderListTVCell.h
//  InnerForCourier
//
//  Created by DamonLiao on 2017/2/4.
//  Copyright © 2017年 DamonLiao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XFGoods;
@class XFOrderDetailsGoodsModel;

@interface XFOrderListTVCell : UITableViewCell

@property (nonatomic) XFGoods *model;
@property (nonatomic) XFOrderDetailsGoodsModel *orderDetailsGoodsModel;
@end
