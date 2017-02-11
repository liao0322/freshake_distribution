//
//  NSString+Extension.m
//  百思不得姐-01
//
//  Created by 廖晓飞 on 16/5/4.
//  Copyright © 2016年 廖晓飞. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize {
    NSDictionary *attrs = @{NSFontAttributeName : font};
    
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

+ (NSString *)stringWithTime:(NSTimeInterval)time {
    NSInteger minute = time / 60;
    NSInteger second = (int)round(time) % 60;
    return [NSString stringWithFormat:@"%02ld%@%02ld", minute, @":", second];
}

- (BOOL)isEmpty {
    if (self == nil) { return YES; }
    if ([self isKindOfClass:NSNull.class]) { return YES; }
    if ([self isEqualToString:@""]) {
        return YES;
    }
    NSCharacterSet *set = [NSCharacterSet whitespaceCharacterSet];
    NSString *result = [self stringByTrimmingCharactersInSet:set];
    if (result.length == 0) { return YES; }
    return NO;
}

- (NSString *)clearLeadAndTailSpace {
    if(self.length == 0){
        return @"";
    }
    NSString *string = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return string;
}

- (NSString *)clearAllSpace {
    if(self.length == 0){
        return @"";
    }
    NSString *string = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    return string;
}
@end
