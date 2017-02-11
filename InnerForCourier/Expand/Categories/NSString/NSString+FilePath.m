//
//  NSString+FilePath.m
//  Which
//
//  Created by 廖晓飞 on 7/11/16.
//  Copyright © 2016 Jidu. All rights reserved.
//

#import "NSString+FilePath.h"

@implementation NSString (FilePath)

+ (NSString *)homeDirectory {
    return NSHomeDirectory();
}

+ (NSString *)documentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

+ (NSString *)cachesDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

+ (NSString *)tempDirectory {
    return NSTemporaryDirectory();
}

- (NSString *)path
{
    return [NSHomeDirectory() stringByAppendingPathComponent:self];
}

- (NSString *)documentsAppendingPathComponent:(NSString *)component {
    return [[NSString documentsDirectory] stringByAppendingPathComponent:component];
}



- (NSString *)cachesPath {
    return [[NSString cachesDirectory] stringByAppendingPathComponent:self];
}

@end
