//
//  NSDate+TimeString.h
//  badianhou
//
//  Created by Yue Huang on 6/8/15.
//  Copyright (c) 2015 careerfrog. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (TimeString)
+ (NSString *)timeStringSince:(NSTimeInterval)createTime;

+ (NSString *)timeStringWithFormatter:(NSString *)formatter timestamp:(NSTimeInterval)timestamp;

@end
