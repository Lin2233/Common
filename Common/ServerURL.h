//
//  ServerURL.h
//  ESolution
//
//  Created by Yuson Xing on 13-9-27.
//  Copyright (c) 2013年 Yuson Xing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerURL : NSObject

+ (void) setServerIPAndPort:(NSString *)strIPAndPort;
+ (NSString *)getServerURL;
+ (NSString *)getServerIPAndPort;

+ (NSString *) jPush;//上传极光推送唯一标示符
+ (NSString *)getLoginURL;//登陆
+ (NSString *)getRegisterUrl;//注册
+ (NSString *)getDepartmentInfo;//获取部门信息
+ (NSString *)getAccountVerifURL;//获取验证码
+ (NSString *)forgetPasswordURL;//找回密码
+ (NSString *)getDefaultBusLine;//首页默认线路
+ (NSString *)getAllStationList;//获取所有站点列表
+ (NSString *)setDefaultPoint;//设为默认站点
+ (NSString *)getUserInfomation;//获取个人信息
+ (NSString *)updatePhoto;//上传头像
+ (NSString *)submitUserInfo;//修改个人信息
+ (NSString *)getOrderList;//获取订单列表
+ (NSString *)getOrderDetail;//获取订单详情
+ (NSString *)getAnnounceListURL;//获取公告列表
+ (NSString *)getAnnounceDetail;//获取公告详情
+ (NSString *)suggestUrl;//意见反馈



+ (NSString *)submitOrderURL;
+ (NSString *)getOrderInfo;
+ (NSString *)getAccountInfo;
+ (NSString *)bindAccount;
+ (NSString *)addCommonRoute;
+ (NSString *)updateCommonRoute;
+ (NSString *)getCommonRoute;
+ (NSString *)getCouponsList;
+ (NSString *)getMessageListURL;
+ (NSString *)recallOrdersURL;
+ (NSString *)deleteRoute;
+ (NSString *)complainUrl;
+ (NSString *)updateUserInfo;
+ (NSString *)bindingIDUrl;
+ (NSString *)submitStar;
+ (NSString *)thirdLogin;
+ (NSString *)getComplaint;
+ (NSString *)getSystemDic;
+ (NSString *)findMessagerList;
+ (NSString *)getMessagerDetail;
+ (NSString *)removeOrder;
+ (NSString *)getHistoryPoint;

@end
