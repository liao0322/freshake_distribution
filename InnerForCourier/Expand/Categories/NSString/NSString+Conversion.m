//
//  NSString+Conversion.m
//  InnerForCourier
//
//  Created by DamonLiao on 2017/2/9.
//  Copyright © 2017年 DamonLiao. All rights reserved.
//

#import "NSString+Conversion.h"
#import "NSString+Extension.h"

@implementation NSString (Conversion)

+ (NSString *)stringWithString:(NSString *)string defaultValue:(NSString *)value {
    if (![string isEmpty]) {
        return string;
    } else {
        return value;
    }
}

@end
