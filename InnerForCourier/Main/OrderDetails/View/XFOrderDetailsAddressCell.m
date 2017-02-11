//
//  XFOrderDetailsAddressCell.m
//  InnerForCourier
//
//  Created by DamonLiao on 2017/2/9.
//  Copyright © 2017年 DamonLiao. All rights reserved.
//

#import "XFOrderDetailsAddressCell.h"

@implementation XFOrderDetailsAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)viewExpress:(id)sender {
    if (self.viewExpressBlock) {
        self.viewExpressBlock();
    }
}
@end
