//
//  Created by yuson on 11-4-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CommonARC.h"
#import <CommonCrypto/CommonDigest.h>
#import "SQLiteDBOperator.h"

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
static NSString *g_userID   = @"";
//static NSString *g_userID = @"PCSH0201";
static NSString *g_userName = @"";
static USERCARTYPE useCartype  = 0;

//yuson add 20140819
static NSDictionary *g_terCodeDic = nil;
static NSMutableString *g_endUserCodeStr = nil;

//static NetworkStatus g_networkStatus = NotReachable;
//static NetworkStatus g_hostStatus    = NotReachable;
// add shenss
static NSArray *sells = nil;
static NSArray *doctors = nil;

static NSArray *polygonXA = nil;
static NSArray *polygonYA = nil;

#define TEXT_FIELD_TAG	9999

@interface ModalAlertDelegate : NSObject <UIAlertViewDelegate, UITextFieldDelegate> 
{
	CFRunLoopRef currentLoop;
	NSString *text;
	NSUInteger index;
}
@property (assign) NSUInteger index;
@property (retain) NSString *text;
@end

@implementation ModalAlertDelegate
@synthesize index;
@synthesize text;

-(id) initWithRunLoop: (CFRunLoopRef)runLoop 
{
	if (self = [super init]) currentLoop = runLoop;
	return self;
}

// User pressed button. Retrieve results
-(void)alertView:(UIAlertView*)aView clickedButtonAtIndex:(NSInteger)anIndex 
{
	UITextField *tf = (UITextField *)[aView viewWithTag:TEXT_FIELD_TAG];
	if (tf) self.text = tf.text;
	self.index = anIndex;
	CFRunLoopStop(currentLoop);
}

- (BOOL) isLandscape
{
	return ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft) || ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight);
}

// Move alert into place to allow keyboard to appear
- (void) moveAlert: (UIAlertView *) alertView
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.25f];
	if (![self isLandscape])
		alertView.center = CGPointMake(160.0f, 180.0f);
	else 
		alertView.center = CGPointMake(240.0f, 90.0f);
	[UIView commitAnimations];
	
	[[alertView viewWithTag:TEXT_FIELD_TAG] becomeFirstResponder];
}

@end

@implementation Common

+ (void) warningAlert:(NSString *)str
{
	UIAlertView *endAlert =[[UIAlertView alloc] initWithTitle:@"警告"  message:str delegate:self
											cancelButtonTitle:@"确定" otherButtonTitles:nil];	
	[endAlert show];
	//[endAlert.numberOfButtons ];
}

+ (void) tipAlert:(NSString *)str
{
	UIAlertView *endAlert =[[UIAlertView alloc] initWithTitle:@"提示"  message:str delegate:self
											cancelButtonTitle:@"确定" otherButtonTitles:nil];	
	[endAlert show];
	//[endAlert.numberOfButtons ];
}

+ (NSString *) getKey:(int)index
{
	NSString *key = [NSString stringWithFormat:@"index%d",index];
	
	return key;
}

+ (BOOL) IsSubString:(NSString *)srcString subString:(NSString *)destString
{
	NSComparisonResult result = [srcString compare:destString options:NSCaseInsensitiveSearch
												   range:NSMakeRange(0, destString.length)];
	if (result == NSOrderedSame)
		return YES;
	else
		return NO;
}

+ (NSUInteger) ask: (NSString *) question withCancel: (NSString *) cancelButtonTitle withButtons: (NSArray *) buttons
{
	CFRunLoopRef currentLoop = CFRunLoopGetCurrent();
	
	// Create Alert
	ModalAlertDelegate *madelegate = [[ModalAlertDelegate alloc] initWithRunLoop:currentLoop];
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:question message:nil delegate:madelegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
	for (NSString *buttonTitle in buttons) [alertView addButtonWithTitle:buttonTitle];
	[alertView show];
	
	// Wait for response
	CFRunLoopRun();
	
	// Retrieve answer
	NSUInteger answer = madelegate.index;
    
	return answer;
}

+ (void) say: (id)formatstring,...
{
	va_list arglist;
	va_start(arglist, formatstring);
	id statement = [[NSString alloc] initWithFormat:formatstring arguments:arglist];
	va_end(arglist);
	[Common ask:statement withCancel:@"Okay" withButtons:nil];
}

+ (BOOL) ask: (id)formatstring,...
{
	va_list arglist;
	va_start(arglist, formatstring);
	id statement = [[NSString alloc] initWithFormat:formatstring arguments:arglist];
	va_end(arglist);
	BOOL answer = ([Common ask:statement withCancel:nil withButtons:[NSArray arrayWithObjects:@"是", @"否", nil]] == 0);
    
	return answer;
}

+ (BOOL) alert: (id)formatstring,...
{
	va_list arglist;
	va_start(arglist, formatstring);
	id statement = [[NSString alloc] initWithFormat:formatstring arguments:arglist];
	va_end(arglist);
	BOOL answer = ([Common ask:statement withCancel:nil withButtons:[NSArray arrayWithObjects:@"确定", nil]] == 0);

	return answer;
}


+ (BOOL) confirm: (id)formatstring,...
{
	va_list arglist;
	va_start(arglist, formatstring);
	id statement = [[NSString alloc] initWithFormat:formatstring arguments:arglist];
	va_end(arglist);
	BOOL answer = [Common ask:statement withCancel:@"Cancel" withButtons:[NSArray arrayWithObject:@"OK"]];

	return	answer;
}

+(NSString *) textQueryWith: (NSString *)question prompt: (NSString *)prompt button1: (NSString *)button1 button2:(NSString *) button2
{
	// Create alert
	CFRunLoopRef currentLoop = CFRunLoopGetCurrent();
	ModalAlertDelegate *madelegate = [[ModalAlertDelegate alloc] initWithRunLoop:currentLoop];
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:question message:@"\n" delegate:madelegate cancelButtonTitle:button1 otherButtonTitles:button2, nil];
	
	// Build text field
	UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 260.0f, 30.0f)];
	tf.borderStyle = UITextBorderStyleRoundedRect;
	tf.tag = TEXT_FIELD_TAG;
	tf.placeholder = prompt;
	tf.clearButtonMode = UITextFieldViewModeWhileEditing;
	tf.keyboardType = UIKeyboardTypeAlphabet;
	tf.keyboardAppearance = UIKeyboardAppearanceAlert;
	tf.autocapitalizationType = UITextAutocapitalizationTypeWords;
	tf.autocorrectionType = UITextAutocorrectionTypeNo;
	tf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	
	// Show alert and wait for it to finish displaying
	[alertView show];
	while (CGRectEqualToRect(alertView.bounds, CGRectZero));
	
	// Find the center for the text field and add it
	CGRect bounds = alertView.bounds;
	tf.center = CGPointMake(bounds.size.width / 2.0f, bounds.size.height / 2.0f - 10.0f);
	[alertView addSubview:tf];
	
	// Set the field to first responder and move it into place
	[madelegate performSelector:@selector(moveAlert:) withObject:alertView afterDelay: 0.7f];
	
	// Start the run loop
	CFRunLoopRun();
	
	// Retrieve the user choices
	NSUInteger index = madelegate.index;
	NSString *answer = [madelegate.text copy];
	if (index == 0)
        answer = nil; // assumes cancel in position 0
		
	return answer;
}

+ (NSString *) ask: (NSString *) question withTextPrompt: (NSString *) prompt
{
	return [Common textQueryWith:question prompt:prompt button1:@"Cancel" button2:@"OK"];
}

+ (NSString *) getMD5Value:(NSString *)str
{
	const char *cStr = [str UTF8String]; 
    unsigned char result[16]; 
    CC_MD5( cStr, strlen(cStr), result ); 
    return [NSString stringWithFormat: 
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3], 
            result[4], result[5], result[6], result[7], 
            result[8], result[9], result[10], result[11], 
            result[12], result[13], result[14], result[15] 
            ]; 
}

+ (void) setTipNotification:(NSString *)notifyTipID setContent:(NSString *)notifyTip setDate:(NSDate *)date setRepeat:(NSCalendarUnit)repeat
{
	UILocalNotification *noti = [[UILocalNotification alloc] init];
	noti.fireDate = date;
	noti.soundName = @"ring.caf";
	noti.timeZone  = [NSTimeZone defaultTimeZone];
	noti.repeatInterval = repeat;//kCFCalendarUnitWeekday;
	noti.repeatCalendar = [NSCalendar currentCalendar];
	noti.alertBody = notifyTip;
	noti.userInfo = [NSDictionary dictionaryWithObject:notifyTipID forKey:@"id"];;
#ifdef DEBUG
	NSLog(@"date:%@", [self dateToString:noti.fireDate]);
#endif
	[[UIApplication sharedApplication] scheduleLocalNotification:noti];
}

+ (void) removeTipNotification:(NSString *)notifyTipID
{
	NSArray *array = [[UIApplication sharedApplication] scheduledLocalNotifications];
	for (UILocalNotification * notif in array)
	{
#ifdef DEBUG
		NSLog(@"notification body:%@, date:%@", notif.alertBody, [self dateToString:notif.fireDate]);
#endif
		NSDictionary *dic = notif.userInfo;
		if ([[dic objectForKey:@"id"] isEqualToString:notifyTipID])
		{
#ifdef DEBUG
			NSLog(@"remove notification!");
#endif
			[[UIApplication sharedApplication] cancelLocalNotification:notif];
		}
	}
}

+ (NSDate *) dateFromTime:(int)year setMonth:(int)month setDay:(int)day setHour:(int)hour setMinute:(int)minute
{
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
	//NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
	
    [dateComps setYear:year];
    [dateComps setMonth:month];
	[dateComps setDay:day];
    [dateComps setHour:hour];
    [dateComps setMinute:minute];
	[dateComps setSecond:00];
	
    NSDate *date = [calendar dateFromComponents:dateComps];
	
	return date;
}

+ (NSDate *) dateFromWeek:(int)week setYear:(int)year setWeekDay:(int)weekday
{
	NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
	
	[dateComps setYear:year];
	[dateComps setWeekOfMonth:week];
    [dateComps setWeekday:weekday];
	
    NSDate *date = [calendar dateFromComponents:dateComps];
	
	return date;
}

//年月日 时分
+(NSString *)dateMMToString:(id)dateString Format:(int)format
{
    NSString *str = [NSString stringWithFormat:@"%@",dateString];
    if ([str isEqualToString:@""])
    {
        return @"";
    }
    long long time= [dateString longLongValue];
    NSDate *d = [[NSDate alloc]initWithTimeIntervalSince1970:time/1000.0];
    return  [self dateToString:d Format:format];
    
}

//只显示年月日
+ (NSString *) dateToString:(NSDate *)date Format:(int)format
{
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    
    if (format == 0)
    {
       [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
    }else if(format == 2)
    {
     [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }else if(format == 3){
     [dateFormat setDateFormat:@"MM月dd日 HH:mm"];
    }else{
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
    }
	NSString *dateString = [dateFormat stringFromDate:date];
	
	return dateString;
}

+ (NSDate *)stringToDate:(NSString *)dateStr
{
	// Convert string to date object
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSDate *date = [dateFormat dateFromString:dateStr]; 
 	
	return date;
}

+ (NSString *)stringDateToString:(NSString *)stringDate
{
    return [self dateToString:[self stringToDate:stringDate] Format:3];
}

+ (NSString *)cleanZeroNumFromString:(NSString *)stringDate
{
    NSString *currentString = [self dateToString:[self stringToDate:stringDate] Format:3];
    if (currentString.length<12) {
        return currentString;
    }
    NSArray *array = [currentString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"日月"]];

    if (array.count>2){
        NSString *firstStr = array[0];
        NSString *secondStr = array[1];
        if ([array[0] integerValue] < 10) {
            firstStr = [[array objectAtIndex:0] stringByReplacingOccurrencesOfString:@"0" withString:@""];
        }
        if ([array[1] integerValue] < 10) {
            secondStr = [[array objectAtIndex:1] stringByReplacingOccurrencesOfString:@"0" withString:@""];
        }
        return [NSString stringWithFormat:@"%@月%@日%@",firstStr,secondStr,[array objectAtIndex:2]];
    }
    
    return currentString;
}

+ (BOOL) timeToString:(NSString *)time
{
    BOOL isToday;
    NSDate *today = [[NSDate alloc] init];
    // 10 first characters of description is the calendar date:
    NSString * todayString = [[today description] substringToIndex:10];
    if ([time isEqualToString:todayString])
    {
        isToday = YES;
    }
       return isToday;
}

+ (NSString *) generateID
{
	NSDate *date = [NSDate date];
	return [NSString stringWithFormat:@"%.0f", [date timeIntervalSince1970]];
}

+ (BOOL) checkEmailValid:(NSString *)email
{

	NSRange range = [email rangeOfString:@"@"];
	if (range.length <= 0)
		return NO;
	NSRange ran = [email rangeOfString:@"."];
	if (ran.length <= 0 ||
		ran.location-range.location <= 1 ||
		ran.location == [email length]-1)
		return NO;
	
	return YES;
}

+ (void) setUserID :(NSString *)UserID
{
    g_userID = UserID;
}

+ (NSString *) getUserID
{
    return g_userID;
}

+ (void) setUserName:(NSString *)userName
{
    g_userName = userName;
}

+ (NSString *) getUserName
{
    return g_userName;
}

+ (NSString *) getTime
{
    NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
    NSDate *curDate = [NSDate date];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * curTime = [formater stringFromDate:curDate];
    return curTime;
}

+ (NSString *) getDay
{
    NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
    NSDate *curDate = [NSDate date];
    [formater setDateFormat:@"yyyy-MM-dd"];
    NSString * curTime = [formater stringFromDate:curDate];
    return curTime;
}
//
//+ (void) setNetworkStatus:(NetworkStatus)status
//{
//    g_networkStatus = status;
//}
//
//+ (NetworkStatus) getNetworkStatus
//{
//    return [Reachability reachabilityForInternetConnection].currentReachabilityStatus;
//}
//
//+ (void) setHostStatus:(NetworkStatus)status
//{
//    g_hostStatus = status;
//}
//
//+ (NetworkStatus) getHostStatus
//{
//    return g_hostStatus;
//}

+ (BOOL) writeSettingInfo:(NSDictionary *)dic
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths             = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath         = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"settings.plist"];
    NSError *error;
    
    if([fileManager fileExistsAtPath:filePath])
        [fileManager removeItemAtPath:filePath error:&error];
    
    return [dic writeToFile:filePath atomically:YES];
}

+ (BOOL) writeSettingInfo:(id)value forKey:(NSString *)key
{
    NSDictionary *dic = [Common readSettingInfo];
    NSMutableDictionary *settingDic = [NSMutableDictionary dictionary];
    if (dic != nil)
    {
        NSArray *allKeys = [dic allKeys];
        for (NSString *keyStr in allKeys)
        {
            if ([keyStr isEqualToString:key])
                [settingDic setObject:value forKey:key];
            else
                [settingDic setObject:[dic objectForKey:keyStr] forKey:keyStr];
        }
    }
    else
    {
        [settingDic setObject:value forKey:key];
    }
    
    return [Common writeSettingInfo:settingDic];
}

+ (NSDictionary *) readSettingInfo
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths             = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath         = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"settings.plist"];
    
    if([fileManager fileExistsAtPath:filePath])
    {
        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
        return dic;
    }
    
    return nil;
}

+ (BOOL) writeUserInfo:(NSDictionary *)dic
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths             = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath         = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"account.plist"];
    NSError *error;
    
    if([fileManager fileExistsAtPath:filePath])
        [fileManager removeItemAtPath:filePath error:&error];
    
    return [dic writeToFile:filePath atomically:YES];
}

+ (BOOL) writeUserInfo:(id)value forKey:(NSString *)key
{
    NSDictionary *dic = [Common readSettingInfo];
    NSMutableDictionary *settingDic = [NSMutableDictionary dictionary];
    if (dic != nil)
    {
        NSArray *allKeys = [dic allKeys];
        for (NSString *keyStr in allKeys)
        {
            if ([keyStr isEqualToString:key])
                [settingDic setObject:value forKey:key];
            else
                [settingDic setObject:[dic objectForKey:keyStr] forKey:keyStr];
        }
    }
    else
    {
        [settingDic setObject:value forKey:key];
    }
    
    return [Common writeSettingInfo:settingDic];
}

+ (NSDictionary *) readUserInfo
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths             = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath         = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"account.plist"];
    
    if([fileManager fileExistsAtPath:filePath])
    {
        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
        return dic;
    }
    
    return nil;
}

+ (BOOL)saveUserInfo:(id)userInfo
{
    NSArray *paths             = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *directoryPath    = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"UserCache"];
    NSString *filePath = [directoryPath stringByAppendingPathComponent:@"userInfo.info"];
    NSFileManager *f = [NSFileManager defaultManager];
    if (![f fileExistsAtPath:directoryPath])
    {
        [f createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    BOOL bSuccess = [NSKeyedArchiver archiveRootObject:userInfo toFile:filePath];
    
    return bSuccess;
}

+ (id) getUserInfo
{
    NSArray *paths             = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *directoryPath    = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"UserCache"];
    NSString *filePath = [directoryPath stringByAppendingPathComponent:@"userInfo.info"];
    
    id model = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    if (model != nil) {
        return model;
    }
    return nil;
}

+ (BOOL) removeUserInfo
{
    NSFileManager *f = [NSFileManager defaultManager];
    NSArray *paths             = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *directoryPath    = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"UserCache"];
    NSString *filePath = [directoryPath stringByAppendingPathComponent:@"userInfo.info"];
    
    NSError *error = nil;
    if ([f fileExistsAtPath:filePath])
    {
        [f removeItemAtPath:filePath error:&error];
    }
    if (error)
    {
        return  NO;
    }
    else
    {
        return YES;
    }
}

+ (BOOL)removeAllUserCache
{
    NSFileManager *f = [NSFileManager defaultManager];
    NSArray *paths             = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *directoryPath    = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"UserCache"];
    return [f removeItemAtPath:directoryPath error:nil];
}

+ (BOOL)saveUserCacheWithFileName:(NSString *)name obj:(id)obj
{
    NSArray *paths             = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *directoryPath    = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"UserCache"];
    NSFileManager *f = [NSFileManager defaultManager];
    if (![f fileExistsAtPath:directoryPath])
    {
        [f createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *filePath = [directoryPath stringByAppendingPathComponent:name];
    if ([obj isKindOfClass:[NSDictionary class]])
    {
        return [(NSDictionary *)obj writeToFile:filePath atomically:YES];
    }
    if ([obj isKindOfClass:[NSArray class]])
    {
        return [(NSArray *)obj writeToFile:filePath atomically:YES];
    }
    return NO;
}

+ (id)getUserCacheWithFileName:(NSString *)name
{
    NSArray *paths             = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *directoryPath    = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"UserCache"];
    NSString *filePath = [directoryPath stringByAppendingPathComponent:name];
    NSArray *array = [NSArray arrayWithContentsOfFile:filePath];
    if (array)
    {
        return array;
    }
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    if (dic)
    {
        return dic;
    }
    return nil;
}

+ (BOOL)saveAppCacheWithFileName:(NSString *)name obj:(id)obj
{
    NSArray *paths             = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *directoryPath    = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"BDHApp"];
    NSFileManager *f = [NSFileManager defaultManager];
    if (![f fileExistsAtPath:directoryPath])
    {
        [f createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *filePath = [directoryPath stringByAppendingPathComponent:name];
    if ([obj isKindOfClass:[NSDictionary class]])
    {
        return [(NSDictionary *)obj writeToFile:filePath atomically:YES];
    }
    if ([obj isKindOfClass:[NSArray class]])
    {
        return [(NSArray *)obj writeToFile:filePath atomically:YES];
    }
    return NO;
}



+ (id)getAppCacheWithFileName:(NSString *)name
{
    NSArray *paths             = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *directoryPath    = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"BDHApp"];
    NSString *filePath = [directoryPath stringByAppendingPathComponent:name];
    NSArray *array = [NSArray arrayWithContentsOfFile:filePath];
    if (array)
    {
        return array;
    }
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    if (dic)
    {
        return dic;
    }
    return nil;
}

+ (BOOL)removeAppCacheWithFileName:(NSString *)name
{
    NSArray *paths             = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *directoryPath    = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"BDHApp"];
    NSString *filePath = [directoryPath stringByAppendingPathComponent:name];
    NSFileManager *f = [NSFileManager defaultManager];
    if (![f fileExistsAtPath:filePath])
    {
        return [f removeItemAtPath:filePath error:nil];
    }
    return YES;
}

+ (BOOL)removeAllAppCache
{
    [Common removeCheckDataBuffer];
    NSArray *paths             = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *directoryPath    = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"BDHApp"];
    NSFileManager *f = [NSFileManager defaultManager];
    return [f removeItemAtPath:directoryPath error:nil];
}

+ (NSString *)getCheckDataBuffer
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"checkDataBuffer"];
}

+ (void)saveCheckDataBuffer:(NSString *)dataBuffer
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:dataBuffer forKey:@"checkDataBuffer"];
    [defaults synchronize];
}

+ (void)removeCheckDataBuffer
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"checkDataBuffer"];
    [defaults synchronize];
}

+ (BOOL)saveSettingConfiguration:(id)configuration
{
    NSArray *paths             = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath         = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"setting.info"];
    
    BOOL bSuccess = [NSKeyedArchiver archiveRootObject:configuration toFile:filePath];
    
    return bSuccess;
}

+ (id)getSettingConfiguration
{
    NSArray *paths             = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath         = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"setting.info"];
    
    id configuration = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    if (configuration != nil) {
        return configuration;
    }
    return nil;
}

+ (NSString *) getUUID
{
	CFUUIDRef theUUID = CFUUIDCreate(NULL);
	NSString *string = (__bridge NSString *)CFUUIDCreateString(NULL, theUUID);
	CFRelease(theUUID);
    
	return string;
}
+ (int)getUseCarType
{
    return useCartype;
}
+ (void)setUseCarType:(USERCARTYPE)type
{
   useCartype = type;
}
// add by shenss
+ (NSArray *)getAllSells
{
    return doctors;
}
+ (void)setAllSells:(NSArray *)arr
{
    doctors =arr;
}
+ (NSArray *)getAllManagers
{
    return sells;
}
+ (void)setAllManagers:(NSArray *)arr
{
    sells = arr;
}

+ (BOOL)verifyMobile:(NSString *)mobile
{
    if (mobile.length == 11)
    {
        return YES;
    }
    return NO;
}

+ (BOOL)isPureInt:(NSString *)string
{
        NSScanner* scan = [NSScanner scannerWithString:string];
        int val;
        return[scan scanInt:&val] && [scan isAtEnd];
}

BOOL stringIsNotEmpty (NSString * str) {
    return str != nil && str != (NSString *) [NSNull null] && str.length > 0;
}

BOOL stringIsEmpty (NSString * str) {
    return ! stringIsNotEmpty(str);
}

+ (NSString *)getRegistId
{
//    NSString *document=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    NSString *path=[document stringByAppendingPathComponent:@"registId.regist"];
//    NSString *registrationId=[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
//    if (stringIsEmpty(registrationId))
//    {
//    NSString * registrationId=[APService registrationID];
//        if (registrationId.length != 0)
//        {
//            [registrationId writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
//        }
//        else
//        {
//            registrationId = nil;
//        }
//
//    }
//    if (registrationId == nil || registrationId.length == 0)
//        registrationId = @"888888888888";
    
    return @"";
}
+ (NSString *)getTimeZoneName:(NSString *)timeZoneId{
    NSDictionary *dic=[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"timeZone" ofType:@"plist"]];
    return [dic valueForKey:timeZoneId];
}
+(void)saveChannelId:(NSString *)channelId
{
    [[NSUserDefaults standardUserDefaults] setObject:channelId forKey:@"channelId"];
}

//判断时间间隔
+(NSString *)intervalDayFromLastDate:(id)dateString1 type:(int)dateType
{
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date1;
    if (dateType == 0)
    {
     date1=[dateFormatter dateFromString:[self dateMMToString:dateString1 Format:2]];
        NSDate *date2=[dateFormatter dateFromString:[self getTime]];
        
        NSTimeInterval time=[date2 timeIntervalSinceDate:date1];
        
        //   NSLog(@"time   %f",time);
        int days=(int)time;
        NSString *dateContent=[[NSString alloc] initWithFormat:@"%i",days];
        NSLog(@"time   %@",dateContent);
        return dateContent;
    }else
    {
        date1= dateString1;
    }
    NSDate *date2=[dateFormatter dateFromString:[self getTime]];
    
    NSTimeInterval time=[date1 timeIntervalSinceDate:date2];
    
    //   NSLog(@"time   %f",time);
    int days=(int)time;
    NSString *dateContent=[[NSString alloc] initWithFormat:@"%i",days];
    NSLog(@"time   %@",dateContent);
    return dateContent;

}

+(BOOL)isIntervalInthisTime:(NSString *)resultTime
{
    BOOL isInterval = YES;
    NSString *str = [resultTime substringFromIndex:11];
    if ([str compare:@"06:00"] == NSOrderedAscending)
    {
        isInterval = NO;
    }else if ([str compare:@"20:00"] == NSOrderedDescending)
    {
        isInterval = NO;
    }
    return isInterval;
}

+(BOOL)isInA20:(double)px py:(double)py
{
   polygonXA =@[@"121.363812",@"121.506966",@"121.601252",@"121.648395",@"121.654144",@"121.395432",@"121.352314",@"121.365902",@"121.365291",@"121.370609"];
   polygonYA =@[@"31.338277",@"31.383666",@"31.359494",@"31.321003",@"31.160948",@"31.126827",@"31.241504",@"31.27205",@"31.29538",@"31.322654"];
    return [self isPointInPolygon:px py:py arrayX:polygonXA arrayY:polygonYA];
}

+(BOOL)isPointInPolygon:(double)px py:(double)py arrayX:(NSArray *)polygonXA arrayY:(NSArray *)polygonYA
{
    BOOL isInside = NO;
    double ESP = 1e-9;
    int count = 0;
    double linePoint1x;
    double linePoint1y;
    double linePoint2x = 180;
    double linePoint2y;
    
    linePoint1x = px;
    linePoint1y = py;
    linePoint2y = py;
    
    for (int i = 0; i < polygonXA.count - 1; i++) {
        double cx1 = [[polygonXA objectAtIndex:i] doubleValue];
        double cy1 = [[polygonYA objectAtIndex:i] doubleValue];
        double cx2 = [[polygonXA objectAtIndex:i+1] doubleValue];
        double cy2 = [[polygonYA objectAtIndex:i+1] doubleValue];
        
        if ([self isPointOnLine:px py0:py px1:cx1 py1:cy1 px2:cx2 py2:cy2])
        {
            return true;
        }
        if (fabs(cy2 - cy1) < ESP) {
            continue;
        }
        if ([self isPointOnLine:cx1 py0:cy1 px1:linePoint1x py1:linePoint1y px2:linePoint2x py2:linePoint2y])
        {
            if (cy1 > cy2)
                count++;
        }else if ([self isPointOnLine:cx2 py0:cy2 px1:linePoint1x py1:linePoint1y px2:linePoint2x py2:linePoint2y])
        {
            if (cy2 > cy1)
                count++;
        }else if ([self isIntersect:cx1 py1:cy1 px2:cx2 py2:cy2 px3:linePoint1x py3:linePoint1y px4:linePoint2x py4:linePoint2y])
        {
            count++;
        }
    }
    //   System.out.println(count);
    if (count % 2 == 1) {
        isInside = true;
    }
    return isInside;
}

+(double)mutiply:(double)px0 py0:(double)py0 px1:(double)px1 py1:(double)py1 px2:(double)px2
             py2:(double)py2
{
    return ((px1 - px0) * (py2 - py0) - (px2 - px0) * (py1 - py0));
}

+(double)isPointOnLine:(double)px0  py0:(double)py0  px1:(double)px1 py1:(double)py1 px2:(double)px2 py2:(double)py2
{
    BOOL flag = false;
    double ESP = 1e-9;
    if (fabs([self mutiply:px0 py0:py0 px1:px1 py1:py1 px2:px2 py2:py2]) < ESP
        && ((px0 - px1) * (px0 - px2) <= 0)
        && ((py0 - py1) * (py0 - py2) <= 0)) {
        flag = true;
    }
    return flag;
}

+(BOOL)isIntersect:(double)px1 py1:(double)py1 px2:(double)px2 py2:(double)py2 px3:(double) px3 py3:(double)py3 px4:(double)px4 py4:(double)py4
{
    BOOL flag = false;
    double d = (px2 - px1) * (py4 - py3) - (py2 - py1) * (px4 - px3);
    if (d != 0) {
        double r = ((py1 - py3) * (px4 - px3) - (px1 - px3) * (py4 - py3))
        / d;
        double s = ((py1 - py3) * (px2 - px1) - (px1 - px3) * (py2 - py1))
        / d;
        if ((r >= 0) && (r <= 1) && (s >= 0) && (s <= 1)) {
            flag = true;
        }
    }
    return flag;
}

+(CGFloat)DegreesToRadians:(CGFloat)degress
{
    return degress*M_PI/180.0;
}

+ (UIImage *)imageRotatedByDegrees:(CGFloat)degrees localImage:(UIImage *)image
{
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,image.size.width, image.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation([self DegreesToRadians:degrees]);
    rotatedViewBox.transform = t;
    rotatedViewBox.alpha = 0;
    CGSize rotatedSize = rotatedViewBox.frame.size;
//    [rotatedViewBox release];
    
    // Create the bitmap context
//    UIGraphicsBeginImageContext(rotatedSize);
    UIGraphicsBeginImageContextWithOptions(rotatedViewBox.frame.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, [self DegreesToRadians:degrees]);
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-image.size.width / 2, -image.size.height / 2, image.size.width, image.size.height), [image CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;


}

@end
