//
//  NSString+Extension.h
//  百思不得姐-01
//
//  Created by 廖晓飞 on 16/5/4.
//  Copyright © 2016年 廖晓飞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (Extension)

/**
 *  计算一段文字的尺寸
 */
+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize;

+ (NSString *)stringWithTime:(NSTimeInterval)time;

/// 判断一段字符串是否为空
- (BOOL)isEmpty;


- (NSString *)clearLeadAndTailSpace;
- (NSString *)clearAllSpace;
@end
