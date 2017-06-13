//
//  NSDictionary+NSNull.m
//  badianhou
//
//  Created by Yue Huang on 6/18/15.
//  Copyright (c) 2015 careerfrog. All rights reserved.
//

#import "NSDictionary+NSNull.h"

@implementation NSDictionary (NSNull)
- (id)notNullObjectForKey:(id)key
{
    id obj = self[key];
    if ([obj isKindOfClass:[NSNull class]] || !obj)
    {
        return @"";
    }
    return obj;
}
@end
