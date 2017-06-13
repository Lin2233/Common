//
//  SFHttpTool.h
//  SuperFitnessCenter
//
//  Created by 黄悦 on 4/10/15.
//  Copyright (c) 2015 Yue Huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class VWTHttpToolManager, VWTHttpTool;

typedef NS_ENUM(NSUInteger, HttpRequestMehod) {
    HttpRequestMehodGET = 1,
    HttpRequestMehodPOST,
};

typedef void(^VWTHttpCompletionHandler)(NSDictionary *resBodyDic, NSError *error);
typedef void(^VWTHttpUploadImageCompletionHandler)(UIImage *image, NSDictionary *resBodyDic, NSError *error);
@interface VWTHttpTool : NSObject<UIAlertViewDelegate>

@property (copy, nonatomic) NSString *urlString;
@property (strong, nonatomic) NSDictionary *paramasDic;
@property (weak, nonatomic) VWTHttpToolManager * manager;
@property (assign, nonatomic) HttpRequestMehod method;

+ (VWTHttpTool *)requestWithUrlString:(NSString *)urlString
                           paramasDic:(NSDictionary *)params
                               method:(HttpRequestMehod)method
                    completionHandler:(VWTHttpCompletionHandler)completion;

+ (VWTHttpTool *)requestWithUrlString:(NSString *)urlString
                           paramasDic:(NSDictionary *)params
                               method:(HttpRequestMehod)method
              showIndicatorInView:(UIView *)view
                    completionHandler:(VWTHttpCompletionHandler)completion;

+ (VWTHttpTool *)postWithUrlString:(NSString *)urlString
                           paramasDic:(NSDictionary *)params
                               method:(HttpRequestMehod)method
                    completionHandler:(VWTHttpCompletionHandler)completion;

+ (VWTHttpTool *)getWithUrlString:(NSString *)urlString
                        paramasDic:(NSDictionary *)params
                            method:(HttpRequestMehod)method
                 completionHandler:(VWTHttpCompletionHandler)completion;

+ (void)downloadImageWithUrlString:(NSString *)urlString placeholderImage:(UIImage *)image imageView:(UIImageView *)imageView;

- (void) uploadImage:(UIImage *)image
           urlString:(NSString *)urlString
      contentType:(NSString *)contentType
   completionHandler:(VWTHttpUploadImageCompletionHandler)completion;

- (void)cancel;


@end
