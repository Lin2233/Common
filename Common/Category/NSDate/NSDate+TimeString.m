//
//  NSDate+TimeString.m
//  badianhou
//
//  Created by Yue Huang on 6/8/15.
//  Copyright (c) 2015 careerfrog. All rights reserved.
//

#import "NSDate+TimeString.h"

@implementation NSDate (TimeString)
+ (NSString *)timeStringSince:(NSTimeInterval)createTime
{
    NSDate *createDate = [NSDate dateWithTimeIntervalSince1970:createTime];
    NSDate *nowDate = [NSDate date];
    NSTimeInterval timeInterval = [nowDate timeIntervalSinceDate:createDate];
    NSString *timeString = nil;
    if (timeInterval < 60)
    {
        timeString = @"刚刚";
    }
    else if (timeInterval >= 60 && timeInterval < 60 * 60)
    {
        
        timeString = [NSString stringWithFormat:@"%zd分钟前", (NSInteger)(timeInterval / 60)];
    }
    else if (timeInterval >= 60 * 60 && timeInterval < 24 * 60 * 60)
    {
        
        timeString = [NSString stringWithFormat:@"%zd小时前", (NSInteger)(timeInterval / (60 * 60))];
    }
    else if (timeInterval >= 24 * 60 * 60 && timeInterval < 31 * 24 * 60 * 60)
    {
        if (timeInterval >= 7 * 24 * 60 * 60)
        {
            timeString = [NSString stringWithFormat:@"%zd周前", (NSInteger)(timeInterval / (7 * 24 * 60 * 60))];
        }
        else
        {
            timeString = [NSString stringWithFormat:@"%zd天前", (NSInteger)(timeInterval / (24 * 60 * 60))];
        }
        
    }
    else if (timeInterval >= 31 * 24 * 60 * 60 && timeInterval < 12 * 31 * 24 * 60 * 60)
    {
        timeString = [NSString stringWithFormat:@"%zd月前", (NSInteger)(timeInterval / (31 * 24 * 60 * 60))];
    }
    else
    {
        timeString = [NSString stringWithFormat:@"%zd年前", (NSInteger)(timeInterval / (12 * 31 * 24 * 60 * 60))];

    }
    return timeString;
}

+(NSString *)timeStringWithFormatter:(NSString *)formatter timestamp:(NSTimeInterval)timestamp
{
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:formatter];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    return [f stringFromDate:date];
}


@end
