//
//  XFRow.h
//  InnerForCourier
//
//  Created by DamonLiao on 2017/2/9.
//  Copyright © 2017年 DamonLiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XFRow : NSObject

@property (copy, nonatomic) NSString *cellIdentifier;
@property (nonatomic) id data;
@property (assign, nonatomic) CGFloat rowHeight;

- (instancetype)initWithCellIdentifier:(NSString *)cellIdentifier
                                  data:(id)data
                             rowHeight:(CGFloat)rowHeight;

@end
