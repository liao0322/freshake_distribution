//
//  NSString+FilePath.h
//  Which
//
//  Created by 廖晓飞 on 7/11/16.
//  Copyright © 2016 Jidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (FilePath)

+ (NSString *)homeDirectory;

+ (NSString *)documentsDirectory;

+ (NSString *)cachesDirectory;

+ (NSString *)tempDirectory;

- (NSString *)path;

- (NSString *)documentsAppendingPathComponent:(NSString *)component;

- (NSString *)cachesPath;
@end
