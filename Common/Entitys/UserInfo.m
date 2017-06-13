//
//  UserInfo.m
//  badianhou
//
//  Created by shenshasha on 15/5/15.
//  Copyright (c) 2015年 Yue Huang. All rights reserved.
//

#import "UserInfo.h"
#import "NSDictionary+NSNull.h"
#import "UIImageView+WebCache.h"

static UserInfo *_userInfo;
@implementation UserInfo
+ (UserInfo*) sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _userInfo = [[UserInfo alloc] init];
    });
    return _userInfo;
}

+ (id) allocWithZone:(NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _userInfo=[super allocWithZone:zone];
   });
    return _userInfo;
}

-(id)copyWithZone:(NSZone *)zone
{
    return self;
}

+(id)userInfoWithUserInfomation:(NSDictionary *)userInfo
{
    UserInfo *user=[UserInfo sharedInstance];
    user.email = [userInfo notNullObjectForKey:@"email"];
    user.phoneNumber = [userInfo notNullObjectForKey:@"phone"];
    user.nickName = [userInfo notNullObjectForKey:@"nickName"];
    user.headPicUrl = [userInfo notNullObjectForKey:@"headPic"];
    user.passengerId = [NSString stringWithFormat:@"%@",[userInfo notNullObjectForKey:@"id"]];
    user.commonAddress = [userInfo notNullObjectForKey:@"address"];
    user.CDSID = [userInfo notNullObjectForKey:@"cdsid"];
    user.departmentName = [userInfo notNullObjectForKey:@"deptName"];
    user.deptId = [NSString stringWithFormat:@"%@",[userInfo notNullObjectForKey:@"deptId"]];
    if ([[userInfo notNullObjectForKey:@"sex"] integerValue]== 0)
    {
        user.sexString = @"男";
    }else{
        user.sexString = @"女";
    }
    user.isValid = [NSString stringWithFormat:@"%@",[userInfo notNullObjectForKey:@"isValid"]];
    return user;
}

- (void)clearUserInfo
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"phoneNumber"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"passengerId"];
    self.CDSID = @"";;
    self.email = @"";
    self.nickName = @"";
    self.headPicUrl = @"";
    self.deptId = @"";
    self.departmentName = @"";
    self.defaultPointId = @"";
    self.sexString = @"";
    self.commonAddress = @"";
    self.isValid = @"";
}

- (NSString *)email
{
    if (!_email || [_email isKindOfClass:[NSNull class]])
    {
        _email = @"";
    }
    return _email;
}

@end
