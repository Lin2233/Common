//
//  SFCHttpToolManager.m
//  SuperFitnessCenter
//
//  Created by 黄悦 on 5/6/15.
//  Copyright (c) 2015 Yue Huang. All rights reserved.
//

#import "VWTHttpToolManager.h"
#import "CommonARC.h"
#import "VWTNetworkError.h"
#import "AFNetworking.h"
#import "ToastMessageView.h"
#import "Reachability.h"



@interface VWTHttpToolManager ()

@property (strong, nonatomic) NSMutableDictionary *requestDic;

@end

@implementation VWTHttpToolManager

static VWTHttpToolManager *manager = nil;

+(VWTHttpToolManager *)shareManger
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[VWTHttpToolManager alloc] init];
        manager.requestDic = [NSMutableDictionary dictionary];
    });
    return manager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [super allocWithZone:zone];
    });
    return manager;
}

- (void)requestWithUrlString:(NSString *)urlString andParams:(NSDictionary *)params method:(HttpRequestMehod)mehod showIndicatorInView:(UIView *)view andCompletionHandler:(VWTHttpManagerCompletionHandler)completion
{
    NSLog(@"%@", params);
    if (![self isNetworkSuccess])
    {
        NSDictionary *userInfo = nil;
        VWTNetworkError *error = nil;
        userInfo               = @{
                                   NSLocalizedDescriptionKey : @"当前无可用网络，请检查网络！"
                                   };
        error                  = [VWTNetworkError errorWithType:NetworkErrorTypeNoNetConnecting andUerInfo:userInfo];
        completion(nil, error);
        return;
    }
    VWTHttpTool *tool = self.requestDic[urlString];
    if (tool)
    {
        return;
    }
    
    tool         = [VWTHttpTool requestWithUrlString:urlString paramasDic:params method:mehod showIndicatorInView:view  completionHandler:completion];
    tool.manager = self;
    [self.requestDic setObject:tool forKey:urlString];
}

- (void)requestWithUrlString:(NSString *)urlString andParams:(NSDictionary *)params method:(HttpRequestMehod)mehod andCompletionHandler:(VWTHttpManagerCompletionHandler)completion
{
    [self requestWithUrlString:urlString andParams:params method:mehod showIndicatorInView:nil andCompletionHandler:completion];
}

- (void)postWithUrlString:(NSString *)urlString andParams:(NSDictionary *)params andCompletionHandler:(VWTHttpManagerCompletionHandler)completion
{
    [self requestWithUrlString:urlString andParams:params method:HttpRequestMehodPOST andCompletionHandler:completion];
}

- (void)uploadImage:(UIImage *)image urlString:(NSString *)urlString contentType:(NSString *)contentType completionHandler:(VWTHttpUploadImageCompletionHandler)completion
{
    if (![self isNetworkSuccess])
    {
        NSDictionary *userInfo = nil;
        VWTNetworkError *error = nil;
        userInfo               = @{
                     NSLocalizedDescriptionKey : @"当前无可用网络，请检查网络！"
                     };
        error                  = [VWTNetworkError errorWithType:NetworkErrorTypeNoNetConnecting andUerInfo:userInfo];
        completion(nil, nil, error);
        return;
    }
    VWTHttpTool *tool = self.requestDic[urlString];
    if (tool)
    {
        return;
    }
    
    tool = [[VWTHttpTool alloc] init];
    tool.manager = self;
    [tool uploadImage:image urlString:urlString contentType:contentType completionHandler:completion];
    [self.requestDic setObject:tool forKey:urlString];
}

- (void)downloadImageWithUrlString:(NSString *)urlString placeholderImage:(UIImage *)image imageView:(UIImageView *)imageView
{

    [VWTHttpTool downloadImageWithUrlString:urlString placeholderImage:image imageView:imageView];
}

- (BOOL)removeRequestWithKey:(NSString *)key
{
    VWTHttpTool *tool = self.requestDic[key];
    if (tool)
    {
        [tool cancel];
        [self.requestDic removeObjectForKey:key];
    }
    return YES;
}

- (BOOL)removeAllRequests
{
    for (VWTHttpTool *tool in self.requestDic.allValues)
    {
        [tool cancel];
    }
    
    [self.requestDic removeAllObjects];
    return YES;
}

- (BOOL)isNetworkSuccess
{
    BOOL isExistenceNetwork = YES;
    //    Reachability *reach = [Reachability reachabilityWithHostName:@"www.baidu.cn"];
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork = NO;
            NSLog(@"notReachable");
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = YES;
            NSLog(@"WIFI");
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = YES;
            NSLog(@"3G");
            break;
    }
    return isExistenceNetwork;
}

@end














