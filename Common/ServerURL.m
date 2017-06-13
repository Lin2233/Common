//
//  ServerURL.m
//
//
//  Created by Yuson Xing on 13-9-27.
//  Copyright (c) 2013年 Yuson Xing. All rights reserved.
//

#import "ServerURL.h"


//static NSString *g_serverURL                        = @"http://dzprodvm-test.chinacloudapp.cn:8082/";
//开发服务器(SIT环境)
//static NSString *g_serverURL                      = @"http://testvm-passenger.chinacloudapp.cn/";
//static NSString *g_serverURL                      = @"http://qavm-passenger.chinacloudapp.cn/";
//本地联调
static NSString *g_serverURL                      = @"http://172.18.2.4:8080/";
//测试服务器
//static NSString *g_serverURL                      = @"http://180.166.66.226:43220/";
//正式环境
//static NSString *g_serverURL                      = @"";

//上传极光推送唯一标示符
#define UPLOADCHANNALID                             @"fordbus_passenger/nm/pushDes/addPushDes"
//登录
#define MOBILE_LOGIN_URL                            @"fordbus_passenger/nm/user/loginRec"
//注册
#define MOBILE_REGISTER                             @"fordbus_passenger/nm/user/register"
//获取部门信息
#define Department_Info_URL                         @"fordbus_passenger/nm/user/getDepts"
//获取验证码
#define ACCOUNT_Verif_URL                           @"fordbus_passenger/nm/user/sendSMS"
//找回密码
#define FORGET_PASSWORD                             @"fordbus_passenger/nm/user/forgetPassWd"
//首页默认线路
#define DEFAULT_BUS_LINE                            @"fordbus_passenger/nm/line/getlinePoints"
//获取所有站点列表
#define ALL_STATIONS_LIST                           @"fordbus_passenger/nm/line/lineList"
//设为默认站点
#define SET_DEFAULT_POINT                           @"fordbus_passenger/nm/line/linePoint"
//获取默认站点
#define GET_USER_INFOMATION                         @"fordbus_passenger/nm/user/passengerInformation"
//上传头像
#define UPLOADIMAGE_URL                             @"fordbus_passenger/nm/user/updatePassengerHeadPic"
//修改个人信息
#define SUBMIT_USER_INFO                            @"fordbus_passenger/nm/user/updatePassenger"
//获取订单列表
#define ORDERLIST_URL                               @"fordbus_passenger/nm/orders/findRecOrdersPage"
//获取订单详情
#define ORDERDETAIL                                 @"fordbus_passenger/nm/orders/getOrder"
//获取公告列表
#define ANNOUCELIST_URL                             @"fordbus_passenger/nm/notice/findNoticePageByType"
//获取公告详情
#define ANNOCEDETAIL_URL                            @"http://testvm-backupground.chinacloudapp.cn/fordbus_back/notice/showNoticeDesc.action"
//意见反馈
#define SUGGEST_URL                                 @"fordbus_passenger/nm/feedBack/addFeedBack"




//乘客下单
#define SUBMIT_ORDER_URL                            @"fordbus_passenger/nm/orders/submitOrders"
//乘客支付订单(订单状态)
#define ORDERSTATUS_URL                             @"fordbus_passenger/nm/orders/payOrder"
//乘客取消订单
#define RECALLORDERS                                @"fordbus_passenger/nm/orders/removeOrder"
//乘客第三方登录
#define THIRDLOGIN                                  @"fordbus_passenger/nm/user/thirdLogin"
//乘客绑定第三方账户
#define BINDACCOUNT_URL                             @"fordbus_passenger/nm/user/bindingId"
//获取个人信息
#define ACCOUNTINFO_URL                             @"fordbus_passenger/nm/user/getPassengerById"
//删除订单
#define REMOVEORDER                                 @"fordbus_passenger/nm/orders/delFlagOrder"
//添加常用路线
#define ADDCOMMONROUTE_URL                          @"fordbus_passenger/nm/route/addRoute"
//修改常用路线
#define UPDATEROUTE_URL                             @"fordbus_passenger/nm/route/updateRoute"
//获取常用路线集合
#define GETROUTE_URL                                @"fordbus_passenger/nm/route/findRoutes"
//获取优惠券集合
#define COUPONSLIST_URL                             @"fordbus_passenger/nm/customerCoupons/findCustomerCoupons"
//删除某个常用路线
#define DELETEROUTE_URL                             @"fordbus_passenger/nm/route/delRoute"
//投诉意见
#define COMPLAIN_URL                                @"fordbus_passenger/nm/complaint/addComplaint"
//修改个人信息
#define UPDATEUSERINFO_URL                          @"fordbus_passenger/nm/user/updatePassengerById"
//绑定第三方登录ID
#define BINDINGID                                   @"fordbus_passenger/nm/user/thirdLogin"
//提交星级评价
#define SUBMITSTAR_URL                              @"fordbus_passenger/nm/orders/updateOrder"
//获取投诉信息
#define GETCOMPLAINT_URL                            @"fordbus_passenger/nm/complaint/findComplaintByOrderIdPhone"
//获取系统字典信息
#define GETSYSTEMDIC                                @"fordbus_passenger/nm/sysDict/findSysDictList"
//查看消息列表
#define FINDMESSAGERLIST                            @"fordbus_passenger/nm/message/findMessagePage"
//查看消息详情
#define GETMESSAGEDETAIL                            @"fordbus_passenger/nm/message/getMessage"
//获取历史站点
#define GETSTATIONHISTORY                           @"fordbus_passenger/nm/orders/findHistoryPoint"

@implementation ServerURL

//设置ip及端口
+ (NSString *)getServerURL
{
    return g_serverURL;
}

+ (NSString *)getServerIPAndPort
{
    return g_serverURL;
}

+ (void)setServerIPAndPort:(NSString *)strIPAndPort
{
    g_serverURL = strIPAndPort;
}

+(NSString *) jPush//上传极光推送唯一标示符
{
    return [NSString stringWithFormat:@"%@%@",g_serverURL,UPLOADCHANNALID];
}

+ (NSString *)getLoginURL//登陆
{
    return [NSString stringWithFormat:@"%@%@", g_serverURL, MOBILE_LOGIN_URL];
}

+ (NSString *)getRegisterUrl//注册
{
    return [NSString stringWithFormat:@"%@%@", g_serverURL, MOBILE_REGISTER];
}

+ (NSString *)getDepartmentInfo//获取部门信息
{
    return [NSString stringWithFormat:@"%@%@", g_serverURL, Department_Info_URL];
}

+ (NSString *)getAccountVerifURL//获取验证码
{
    return [NSString stringWithFormat:@"%@%@", g_serverURL, ACCOUNT_Verif_URL];
}

+ (NSString *)forgetPasswordURL//找回密码
{
    return [NSString stringWithFormat:@"%@%@", g_serverURL, FORGET_PASSWORD];
}

+ (NSString *)getDefaultBusLine//首页默认线路
{
    return [NSString stringWithFormat:@"%@%@", g_serverURL, DEFAULT_BUS_LINE];
}

+ (NSString *)getAllStationList//获取所有站点列表
{
    return [NSString stringWithFormat:@"%@%@", g_serverURL, ALL_STATIONS_LIST];
}

+ (NSString *)setDefaultPoint//设为默认站点
{
    return [NSString stringWithFormat:@"%@%@", g_serverURL, SET_DEFAULT_POINT];
}

+ (NSString *)getUserInfomation//获取个人信息
{
    return [NSString stringWithFormat:@"%@%@",g_serverURL, GET_USER_INFOMATION];
}

+ (NSString *)updatePhoto//上传头像
{
    return [NSString stringWithFormat:@"%@%@",g_serverURL, UPLOADIMAGE_URL];
}

+ (NSString *)submitUserInfo//修改个人信息
{
    return [NSString stringWithFormat:@"%@%@",g_serverURL, SUBMIT_USER_INFO];
}

+ (NSString *)getOrderList//获取订单列表
{
    return [NSString stringWithFormat:@"%@%@",g_serverURL, ORDERLIST_URL];
}

+(NSString*)getOrderDetail{//获取订单详情
    return [NSString stringWithFormat:@"%@%@", g_serverURL, ORDERDETAIL];
}

+ (NSString *)getAnnounceListURL//获取公告列表
{
    return [NSString stringWithFormat:@"%@%@",g_serverURL, ANNOUCELIST_URL];
}

+ (NSString *)getAnnounceDetail//获取公告详情
{
    return [NSString stringWithFormat:@"%@",ANNOCEDETAIL_URL];
}

+ (NSString *)suggestUrl//意见反馈
{
    return [NSString stringWithFormat:@"%@%@",g_serverURL, SUGGEST_URL];
}





+(NSString*)removeOrder{
    return [NSString stringWithFormat:@"%@%@", g_serverURL, REMOVEORDER];
}

+(NSString*)getMessagerDetail{
    return [NSString stringWithFormat:@"%@%@", g_serverURL, GETMESSAGEDETAIL];
}

+(NSString*)findMessagerList{
    return [NSString stringWithFormat:@"%@%@", g_serverURL, FINDMESSAGERLIST];
}

+(NSString*)getSystemDic{
    return [NSString stringWithFormat:@"%@%@", g_serverURL, GETSYSTEMDIC];
}

+(NSString*)getComplaint{
    return [NSString stringWithFormat:@"%@%@", g_serverURL, GETCOMPLAINT_URL];
}

+(NSString*)thirdLogin{
    return [NSString stringWithFormat:@"%@%@", g_serverURL, THIRDLOGIN];
}

+(NSString*)bindingIDUrl{
    return [NSString stringWithFormat:@"%@%@", g_serverURL, BINDINGID];
}

+ (NSString *)recallOrdersURL
{
    return [NSString stringWithFormat:@"%@%@", g_serverURL, RECALLORDERS];
}

+ (NSString *)submitOrderURL
{
    return [NSString stringWithFormat:@"%@%@", g_serverURL, SUBMIT_ORDER_URL];
}

+ (NSString *)getOrderInfo
{
   return [NSString stringWithFormat:@"%@%@", g_serverURL, ORDERSTATUS_URL];
}

+ (NSString *)bindAccount
{
   return [NSString stringWithFormat:@"%@%@", g_serverURL, BINDACCOUNT_URL];
}

+ (NSString *)getAccountInfo
{
   return [NSString stringWithFormat:@"%@%@", g_serverURL, ACCOUNTINFO_URL];
}


+ (NSString *)addCommonRoute
{
    return [NSString stringWithFormat:@"%@%@",g_serverURL, ADDCOMMONROUTE_URL];
}

+ (NSString *)updateCommonRoute
{
    return [NSString stringWithFormat:@"%@%@",g_serverURL, UPDATEROUTE_URL];
}

+ (NSString *)getCommonRoute
{
   return [NSString stringWithFormat:@"%@%@",g_serverURL, GETROUTE_URL];
}

+ (NSString *)getCouponsList
{
    return [NSString stringWithFormat:@"%@%@",g_serverURL, COUPONSLIST_URL];
}

+ (NSString *)getMessageListURL
{
    return nil;
}
+ (NSString *)deleteRoute
{
   return [NSString stringWithFormat:@"%@%@",g_serverURL, DELETEROUTE_URL];
}

+ (NSString *)complainUrl
{
   return [NSString stringWithFormat:@"%@%@",g_serverURL, COMPLAIN_URL];
}
+ (NSString *)updateUserInfo
{
    return [NSString stringWithFormat:@"%@%@",g_serverURL,UPDATEUSERINFO_URL];
}
+ (NSString *)submitStar
{
   return [NSString stringWithFormat:@"%@%@",g_serverURL,SUBMITSTAR_URL];
}

+(NSString *)getHistoryPoint
{
  return [NSString stringWithFormat:@"%@%@",g_serverURL,GETSTATIONHISTORY];
}
@end
