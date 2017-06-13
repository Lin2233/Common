//
//  SFCNetworkError.m
//  SuperFitnessCenter
//
//  Created by 黄悦 on 5/8/15.
//  Copyright (c) 2015 Yue Huang. All rights reserved.
//

#import "VWTNetworkError.h"

static NSString *const NetworkErrorDomain = @"com.visionet.superfitnesscenter.errordomain";

@implementation VWTNetworkError

+ (VWTNetworkError *)errorWithType:(NetworkErrorType)type andUerInfo:(NSDictionary *)userInfo
{
    return [VWTNetworkError errorWithDomain:NetworkErrorDomain code:type userInfo:userInfo];
}

@end
