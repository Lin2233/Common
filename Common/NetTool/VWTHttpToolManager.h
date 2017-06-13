//
//  SFCHttpToolManager.h
//  SuperFitnessCenter
//
//  Created by 黄悦 on 5/6/15.
//  Copyright (c) 2015 Yue Huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VWTHttpTool.h"

@class VWTHttpToolManager;

typedef void(^VWTHttpManagerCompletionHandler)(NSDictionary *resBodyDic, NSError *error);

@interface VWTHttpToolManager : NSObject

+ (VWTHttpToolManager *)shareManger;
/**
 *  POST请求
 *
 *  @param urlString  url
 *  @param params     参数
 *  @param completion 结果回调
 */
- (void)postWithUrlString:(NSString *)urlString
                andParams:(NSDictionary *)params
     andCompletionHandler:(VWTHttpManagerCompletionHandler)completion;

- (void)requestWithUrlString:(NSString *)urlString
                   andParams:(NSDictionary *)params
                      method:(HttpRequestMehod)mehod
        andCompletionHandler:(VWTHttpManagerCompletionHandler)completion;

- (void)requestWithUrlString:(NSString *)urlString
                   andParams:(NSDictionary *)params
                      method:(HttpRequestMehod)mehod
         showIndicatorInView:(UIView *)view
        andCompletionHandler:(VWTHttpManagerCompletionHandler)completion;

- (void)downloadImageWithUrlString:(NSString *)urlString placeholderImage:(UIImage *)image imageView:(UIImageView *)imageView;

- (void)uploadImage:(UIImage *)image
           urlString:(NSString *)urlString
      contentType:(NSString *)contentType
completionHandler:(VWTHttpUploadImageCompletionHandler)completion;
/**
 *  移除指定请求
 *
 *  @param key 请求对应的key
 *
 *  @return 成功或者失败
 */
- (BOOL)removeRequestWithKey:(NSString *)key;
- (BOOL)removeAllRequests;
@end
