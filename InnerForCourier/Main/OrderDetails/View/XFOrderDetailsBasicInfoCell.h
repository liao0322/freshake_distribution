//
//  XFOrderDetailsBasicInfoCell.h
//  InnerForCourier
//
//  Created by DamonLiao on 2017/2/9.
//  Copyright © 2017年 DamonLiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XFOrderDetailsBasicInfoCell : UITableViewCell
/// 运费
@property (weak, nonatomic) IBOutlet UILabel *postageLabel;
/// 合计
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
/// 使用优惠券
@property (weak, nonatomic) IBOutlet UILabel *couponLabel;
/// 积分抵扣
@property (weak, nonatomic) IBOutlet UILabel *pointLabel;
/// 实付
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
/// 支付方式
@property (weak, nonatomic) IBOutlet UILabel *paymentTypeLabel;
@end
