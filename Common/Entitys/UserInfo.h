//
//  UserInfo.h
// 
//
//  Created by shenshasha on 15/5/15.
//  Copyright (c) 2015年 Yue Huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface UserInfo : NSObject<NSCoding>

@property (nonatomic,copy) NSString *passengerId;
@property (nonatomic,copy) NSString *email;//email
@property (nonatomic,copy) NSString *nickName;//昵称
@property (nonatomic,copy) NSString *phoneNumber;//手机号码
@property (nonatomic,copy) NSString *headPicUrl;//头像
@property (nonatomic,copy) NSString *defaultPointId;//默认站点id
@property (nonatomic,copy) NSString *commonAddress;//常用地址
@property (nonatomic,copy) NSString *sexString;//性别
@property (nonatomic,copy) NSString *CDSID;
@property (nonatomic,copy) NSString *departmentName;//部门
@property (nonatomic,copy) NSString *deptId;//部门id
@property (nonatomic,copy) NSString *isValid;//是否激活

@property (nonatomic,copy)NSString * adUrl;//广告位Url
@property (nonatomic,copy)NSString * payTime;//剩余支付时间
@property (nonatomic,copy)NSString * cancaleOrderTime;//剩余取消订单时间
@property (nonatomic,copy)NSString * complaintPhone;//投诉司机电话
@property (nonatomic,assign)NSInteger noReadNum;//未读数量
@property (nonatomic,assign)NSInteger annoceNonoReadNum;//公告未读数量
@property (nonatomic,copy)NSString *shareString;//分享链接
@property (nonatomic,copy)NSString *sharWechatCouponUrl;//分享体验


+ (UserInfo*) sharedInstance;
+ (id)userInfoWithUserInfomation:(NSDictionary *)userInfo;
- (void)clearUserInfo;

@end
