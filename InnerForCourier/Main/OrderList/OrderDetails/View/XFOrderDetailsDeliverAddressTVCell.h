//
//  XFOrderDetailsDeliverAddressTVCell.h
//  InnerForCourier
//
//  Created by DamonLiao on 2017/2/9.
//  Copyright © 2017年 DamonLiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XFOrderDetailsDeliverAddressTVCell : UITableViewCell

/// 提货点地址
@property (weak, nonatomic) IBOutlet UILabel *shopAddressLabel;
/// 提货人
@property (weak, nonatomic) IBOutlet UILabel *customerNameLabel;
/// 提货人电话
@property (weak, nonatomic) IBOutlet UILabel *customerPhoneNumberLabel;
/// 预约时间
@property (weak, nonatomic) IBOutlet UILabel *appointmentTimeLabel;
/// 备注
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;

@property (nonatomic) void(^viewExpressBlock)();

@end
