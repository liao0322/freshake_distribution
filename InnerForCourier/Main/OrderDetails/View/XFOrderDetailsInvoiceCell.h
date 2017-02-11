//
//  XFOrderDetailsInvoiceCell.h
//  InnerForCourier
//
//  Created by DamonLiao on 2017/2/9.
//  Copyright © 2017年 DamonLiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XFOrderDetailsInvoiceCell : UITableViewCell

/// 发票类型
@property (weak, nonatomic) IBOutlet UILabel *invoiceTypeLabel;
/// 发票抬头
@property (weak, nonatomic) IBOutlet UILabel *invoiceTitleLabel;
/// 发票内容
@property (weak, nonatomic) IBOutlet UILabel *invoiceContentLabel;
@end
