//
//  SFCNetworkError.h
//  SuperFitnessCenter
//
//  Created by 黄悦 on 5/8/15.
//  Copyright (c) 2015 Yue Huang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, NetworkErrorType) {
    NetworkErrorTypeTimeOut         = -1000,
    NetworkErrorTypeErrorMsg        = - 800,
    NetworkErrorTypeNoNetConnecting = - 900
};

@class VWTNetworkError;

@interface VWTNetworkError : NSError

+ (VWTNetworkError *)errorWithType:(NetworkErrorType)type andUerInfo:(NSDictionary *)userInfo;

@end
