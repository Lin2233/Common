//
//  CommonARC.h
//
//  Created by yuson on 11-4-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define COLOR(R,G,B,A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]
typedef enum
{
    //以下是枚举成员
    CARENTAL = 0,
    RELOCATION
}USERCARTYPE;//枚举名称

typedef enum
{
    TOSUBWAY= 0,//去地铁站
    FROMSUBWAY = 2,//从地铁站出发
    SAVEADDRESS = 1 //常用路线下单
}ChoiceType;


BOOL stringIsNotEmpty (NSString * str);

BOOL stringIsEmpty (NSString * str);

@interface Common : NSObject 


+ (void) warningAlert:(NSString *)str;
+ (void) tipAlert:(NSString *) str;

+ (NSString *) getKey:(int)index;
+ (BOOL) IsSubString:(NSString *)srcString subString:(NSString *)destString;

//信息提示
+ (NSString *) ask: (NSString *) question withTextPrompt: (NSString *) prompt;
+ (NSUInteger) ask: (NSString *) question withCancel: (NSString *) cancelButtonTitle withButtons: (NSArray *) buttons;
+ (void) say: (id)formatstring,...;
+ (BOOL) ask: (id)formatstring,...;
+ (BOOL) confirm: (id)formatstring,...;
+ (BOOL) alert: (id)formatstring,...;

+ (NSString *) getMD5Value:(NSString *)str;

+ (void) setTipNotification:(NSString *)notifyTipID setContent:(NSString *)notifyTip setDate:(NSDate *)date setRepeat:(NSCalendarUnit)repeat;
+ (void) removeTipNotification:(NSString *)notifyTipID;
+ (NSDate *) dateFromTime:(int)year setMonth:(int)month setDay:(int)day setHour:(int)hour setMinute:(int)minute;
+ (NSDate *) dateFromWeek:(int)week setYear:(int)year setWeekDay:(int)weekday;
+ (NSString *) dateToString:(NSDate *)date;
+ (NSDate *) stringToDate:(NSString *)dateStr;
+(NSString *)dateMMToString:(id)dateString Format:(int)format;
+ (BOOL) timeToString:(NSString *)time;
+ (NSString *) generateID;


+ (BOOL) checkEmailValid:(NSString *)email;
+ (void) setUserID :(NSString *)UserID;
+ (void) setUserName:(NSString *)userName;
+ (NSString *) getUserID;
+ (NSString *) getUserName;
+ (NSString *) getTime;
+ (NSString *) getDay;

//+ (void) setNetworkStatus:(NetworkStatus)status;
//+ (NetworkStatus) getNetworkStatus;
//+ (void) setHostStatus:(NetworkStatus)status;
//+ (NetworkStatus) getHostStatus;

//设置plist
+ (BOOL) writeSettingInfo:(NSDictionary *)dic;
+ (BOOL) writeSettingInfo:(id)value forKey:(NSString *)key;
+ (NSDictionary *) readSettingInfo;
//账号plist
// userCache默认存放在Documents/UserCache目录下
// add by Yeo Huang 2015.7.15
+ (BOOL)saveAppCacheWithFileName:(NSString *)name obj:(id)obj;
+ (id)getAppCacheWithFileName:(NSString *)name;
+ (BOOL)removeAppCacheWithFileName:(NSString *)name;
+ (BOOL)removeAllAppCache;
+ (NSString *)getCheckDataBuffer;
+ (void)saveCheckDataBuffer:(NSString *)dataBuffer;



+ (BOOL) writeUserInfo:(NSDictionary *)dic;
+ (BOOL) writeUserInfo:(id)value forKey:(NSString *)key;
+ (NSDictionary *) readUserInfo;
+ (BOOL)saveUserInfo:(id)userInfo;
+ (id) getUserInfo;
+ (BOOL) removeUserInfo;
+ (BOOL)removeAllUserCache;
+ (BOOL)saveUserCacheWithFileName:(NSString *)name obj:(id)obj;
+ (id)getUserCacheWithFileName:(NSString *)name;
+ (BOOL)saveSettingConfiguration:(id)configuration;
+ (id)getSettingConfiguration;

+ (NSString *) getUUID;
+ (int)getUseCarType;
+ (void)setUseCarType:(USERCARTYPE)type;
+ (NSArray *)getAllSells;
+ (void)setAllSells:(NSArray *)arr;
+ (NSArray *)getAllManagers;
+ (void)setAllManagers:(NSArray *)arr;

+ (BOOL)verifyMobile:(NSString *)mobile;

+ (BOOL)isPureInt:(NSString *)string;

+ (NSString *)getRegistId;
+ (NSString *)getTimeZoneName:(NSString *)timeZoneId;


+(NSString *)channelId;
+(void)saveChannelId:(NSString *)channelId;
+(NSString *)intervalDayFromLastDate:(id) dateString1 type:(int)dateType;

+(BOOL)isIntervalInthisTime:(NSString *)resultTime;

+(BOOL)isInA20:(double)px py:(double)py;
+ (NSString *)stringDateToString:(NSString *)stringDate;
+ (NSString *)cleanZeroNumFromString:(NSString *)stringDate;
+ (UIImage *)imageRotatedByDegrees:(CGFloat)degrees localImage:(UIImage *)image;
@end
