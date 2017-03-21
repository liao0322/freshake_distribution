//
//  XFRow.m
//  InnerForCourier
//
//  Created by DamonLiao on 2017/2/9.
//  Copyright © 2017年 DamonLiao. All rights reserved.
//

#import "XFRow.h"

@implementation XFRow

- (instancetype)initWithCellIdentifier:(NSString *)cellIdentifier
                                  data:(id)data
                             rowHeight:(CGFloat)rowHeight {
    if (self = [super init]) {
        self.cellIdentifier = cellIdentifier;
        self.data = data;
        self.rowHeight = rowHeight;
    }
    return self;
}

@end
