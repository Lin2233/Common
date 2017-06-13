//
//  SFHttpTool.m
//  SuperFitnessCenter
//
//  Created by 黄悦 on 4/10/15.
//  Copyright (c) 2015 Yue Huang. All rights reserved.
//

#import "VWTHttpTool.h"
#import "Macro.h"
#import "CommonARC.h"
#import "VWTHttpToolManager.h"
#import "VWTNetworkError.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
#import "UserInfo.h"
#import "NSString+MD5.h"
#import "AFNetworking.h"
#import "SBJson.h"
#import "Encryption.h"


@interface VWTHttpTool ()
// 普通网络请求回调
@property (copy, nonatomic  ) VWTHttpCompletionHandler            httpCompletionHandler;
// 上传照片回调
@property (copy, nonatomic  ) VWTHttpUploadImageCompletionHandler uploadImageCompletionHandler;
// POST
// GET
@property (strong, nonatomic) NSMutableURLRequest                      *httpRequest;
// 自定义error
@property (nonatomic, strong) NSError                     *error;
// 等待指示器显示的视图
@property (nonatomic, weak  ) UIView                              *showView;
// 服务器返回的字典
@property (strong, nonatomic) NSDictionary                        *resBodyDic;
@property (strong, nonatomic) NSMutableDictionary                 *paramDic;
@property (nonatomic,strong)NSString* updateStr;

@end

@implementation VWTHttpTool

- (void)dealloc
{
//    NSLog(@"%s", __func__);
}

- (instancetype)init
{
    if (self = [super init])
    {
        
    }
    return self;
}

+ (VWTHttpTool *)requestWithUrlString:(NSString *)urlString paramasDic:(NSDictionary *)params method:(HttpRequestMehod)method showIndicatorInView:(UIView *)view completionHandler:(VWTHttpCompletionHandler)completion
{
    VWTHttpTool *tool          = [[VWTHttpTool alloc] init];
    tool.urlString             = urlString;
    tool.paramasDic            = params;
    tool.method                = method;
    tool.httpCompletionHandler = completion;
    
    if (view)
    {
        tool.showView = view;
        
    }
    
    [tool p_startRequest];
    return tool;
}

+ (VWTHttpTool *)requestWithUrlString:(NSString *)urlString paramasDic:(NSDictionary *)params method:(HttpRequestMehod)method completionHandler:(VWTHttpCompletionHandler)completion
{
    return [self requestWithUrlString:UIWindowDidResignKeyNotification paramasDic:params method:method showIndicatorInView:nil completionHandler:completion];
}

- (void)p_startRequest
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.showView)
        {
            [MBProgressHUD showHUDAddedTo:self.showView animated:YES];
        }
    });
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (weakSelf.method == HttpRequestMehodGET)
        {
            [weakSelf p_startGETRequest];
        }
        else
        {
            [weakSelf p_startPOSTRequest];
        }
    });
}

- (void)p_startGETRequest
{
//    self.httpRequest                = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:self.urlString]];
//    self.httpRequest.delegate       = self;
//    self.httpRequest.timeOutSeconds = 60;
//    [self.httpRequest startAsynchronous];
}

#pragma mark post
+ (VWTHttpTool *)postWithUrlString:(NSString *)urlString paramasDic:(NSDictionary *)params method:(HttpRequestMehod)method completionHandler:(VWTHttpCompletionHandler)completion
{
    return [self requestWithUrlString:urlString paramasDic:params method:HttpRequestMehodPOST completionHandler:completion];
}

#pragma mark get
+ (VWTHttpTool *)getWithUrlString:(NSString *)urlString paramasDic:(NSDictionary *)params method:(HttpRequestMehod)method completionHandler:(VWTHttpCompletionHandler)completion
{
    return [self requestWithUrlString:urlString paramasDic:params method:HttpRequestMehodGET completionHandler:completion];
}

//- (void)postWithCompletionHandler:(VWTHttpCompletionHandler)completion
//{
//    self.completionHandler = completion;
//    [self.networkObj setURL:self.urlString];
//    [self.networkObj setBodyDic:self.bodyDic];
//    [self p_startPostRequest];
//}

+ (void)downloadImageWithUrlString:(NSString *)urlString placeholderImage:(UIImage *)image imageView:(UIImageView *)imageView
{
    [imageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:image options:SDWebImageLowPriority | SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        NSLog(@"%@", imageURL);
        
    }];
}

- (void)uploadImage:(UIImage *)image urlString:(NSString *)urlString contentType:(NSString *)contentType completionHandler:(VWTHttpUploadImageCompletionHandler)completion
{
}



#pragma mark 发起请求
- (void)p_startPOSTRequest
{
    __weak typeof(self) weakSelf = self;
    
    NSMutableDictionary *postBodyDic = [NSMutableDictionary dictionary];
    if (self.paramasDic)
    {
        [postBodyDic setObject:self.paramasDic forKey:@"body"];
    }
    else
    {
        [postBodyDic setObject:[[NSDictionary alloc] init] forKey:@"body"];
    }
    NSString *phoneNum = [UserInfo sharedInstance].phoneNumber;
    if (phoneNum == nil)
    {
        phoneNum = @"";
    }
     NSDictionary *headDic = @{
                              @"screeny" : @(kScreenHeight),
                              @"screenx" : @(kScreenWidth),
                              @"mos" : @"iphone",
                              @"ver" : [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"],
                              @"de" : [Common getTime],
                              @"aid" : @"com.visionet.FordBus",
                              @"phone":phoneNum,
                              @"cd":@"",
                              @"imei":@"111111111111111111111"
                              };

    [postBodyDic setObject:headDic forKey:@"head"];
    
    self.paramasDic = postBodyDic;
    // 加密
//    NSString *encryptionString=[[Encryption shareSingle] encryptionDictionaryToString:postBodyDic];//加密字符串
//    NSData *jsonData=[encryptionString dataUsingEncoding:NSUTF8StringEncoding];

   NSData *jsonData = [NSJSONSerialization dataWithJSONObject:postBodyDic options:NSJSONWritingPrettyPrinted error:nil];
    
//    NSMutableData *tempJsonData = [NSMutableData dataWithData:jsonData];
//    self.httpRequest                = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:self.urlString]];
//    
//    self.httpRequest.delegate       = self;
//    self.httpRequest.timeOutSeconds = 60;
//    [self.httpRequest addRequestHeader:@"Content-Type" value:@"application/json; encoding=utf-8"];
//    [self.httpRequest addRequestHeader:@"Accept" value:@"application/json"];
//    [self.httpRequest setRequestMethod:@"POST"];
//    [self.httpRequest setPostBody:tempJsonData];
//    [self.httpRequest startAsynchronous];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:self.urlString parameters:nil error:nil];
    
    req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [req setHTTPBody:jsonData];
     AFHTTPResponseSerializer *resonseSerial =  [AFHTTPResponseSerializer serializer];
    resonseSerial.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/javascript",@"text/plain", nil];
    manager.responseSerializer = resonseSerial;
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            //NSLog(@"%@",[responseObject JSONRepresentation]);
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            weakSelf.resBodyDic = dic;
            [weakSelf p_requestCompleted];
            
           //NSLog(@"%@",[responseObject JSONRepresentation]);
        } else {
            if (self.showView)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.showView animated:YES];
                });
            }
            NSDictionary *userInfo = @{
                                       NSLocalizedDescriptionKey : @"请求失败!"
                                       };
            VWTNetworkError *error1 = [VWTNetworkError errorWithType:NetworkErrorTypeErrorMsg andUerInfo:userInfo];
            weakSelf.error = error1;
            self.httpCompletionHandler(nil,error1);
            
            [self.manager removeRequestWithKey:self.urlString];
            }
    }] resume];
    
    
    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    
//    
//    [manager POST:self.urlString parameters:self.paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        weakSelf.resBodyDic = responseObject;
//        [weakSelf p_requestCompleted];
//        NSLog(@"%@",[responseObject JSONRepresentation]);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        if (self.showView)
//        {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [MBProgressHUD hideHUDForView:self.showView animated:YES];
//            });
//        }
//        NSDictionary *userInfo = @{
//                                   NSLocalizedDescriptionKey : @"请求失败!"
//                                   };
//        VWTNetworkError *error1 = [VWTNetworkError errorWithType:NetworkErrorTypeErrorMsg andUerInfo:userInfo];
//        weakSelf.error = error1;
//        self.httpCompletionHandler(nil,error1);
//        
//        [self.manager removeRequestWithKey:self.urlString];
//    }];
    
//    [manager POST:self.urlString parameters:self.paramDic progress:^(NSProgress * _Nonnull uploadProgress) {
//        //
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        weakSelf.resBodyDic = responseObject;
//        [weakSelf p_requestCompleted];
//        NSLog(@"%@",[responseObject JSONRepresentation]);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        if (self.showView)
//        {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [MBProgressHUD hideHUDForView:self.showView animated:YES];
//            });
//        }
//        NSDictionary *userInfo = @{
//                                   NSLocalizedDescriptionKey : @"请求失败!"
//                                   };
//        VWTNetworkError *error1 = [VWTNetworkError errorWithType:NetworkErrorTypeErrorMsg andUerInfo:userInfo];
//        weakSelf.error = error1;
//        self.httpCompletionHandler(nil,error1);
//        
//        [self.manager removeRequestWithKey:self.urlString];
//    }];
    
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.urlString]];
//    [request setHTTPMethod:@"POST"];
//     [request setHTTPBody:tempJsonData];
//    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    //[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    operation.responseSerializer = [AFJSONResponseSerializer serializer];
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        weakSelf.resBodyDic = responseObject;
//       [weakSelf p_requestCompleted];
//        NSLog(@"%@",[responseObject JSONRepresentation]);
//      NSLog(@"responseObject  %@",responseObject);
//      } failure:^(AFHTTPRequestOperation *operation, NSError *error)
//     {
//         if (self.showView)
//         {
//             dispatch_async(dispatch_get_main_queue(), ^{
//                 [MBProgressHUD hideHUDForView:self.showView animated:YES];
//             });
//         }
//        NSDictionary *userInfo = @{
//                                                                                    NSLocalizedDescriptionKey : @"请求失败!"
//                                                                                    };
//                                                         VWTNetworkError *error1 = [VWTNetworkError errorWithType:NetworkErrorTypeErrorMsg andUerInfo:userInfo];
//                                                         weakSelf.error = error1;
//         self.httpCompletionHandler(nil,error1);
//         
//         [self.manager removeRequestWithKey:self.urlString];
 
         //NSLog(@"error  %@",error.localizedDescription);
//         NSDictionary *userInfo = @{
//                                                                           NSLocalizedDescriptionKey : @"请求失败!"
//                                                                           };
//                                                VWTNetworkError *error1 = [VWTNetworkError errorWithType:NetworkErrorTypeErrorMsg andUerInfo:userInfo];
//                                                weakSelf.error = error1;
         
     //}];
    //[operation start];
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [weakSelf.networkObj setURL:weakSelf.urlString];
//        [weakSelf.networkObj setBodyDic:weakSelf.paramasDic];
//
//        [weakSelf.networkObj setHeadDic:headDic];
//        [weakSelf.networkObj PostRequestToServer];
//        weakSelf.resBodyDic = [weakSelf.networkObj getResponse];
//        if (!weakSelf.resBodyDic)
//        {
//            NSDictionary *userInfo = @{
//                                       NSLocalizedDescriptionKey : @"请求失败!"
//                                       };
//            VWTNetworkError *error = [VWTNetworkError errorWithType:NetworkErrorTypeErrorMsg andUerInfo:userInfo];
//            weakSelf.error = error;
//        }
//        [weakSelf p_requestCompleted];
//    });
}

#pragma mark 请求完成
- (void)p_requestCompleted
{
        if (self.httpCompletionHandler)
        {
            if (self.showView)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.showView animated:YES];
                });
            }
            NSArray *array = [self.resBodyDic allKeys];
            
            
            NSString *str = @"";
            for (NSString *keyString in array)
            {
                NSLog(@"keyString  %@",keyString);
                if ([keyString isEqualToString:@"st"])
                {
                    str = @"st";
                }
            }
            
            if ([str isEqualToString:@"st"])
            {
                if ([[self.resBodyDic objectForKey:@"st"] isEqualToString:@"1"])
                {
                    [self suggestupdate:self.resBodyDic];
                }else if ([[self.resBodyDic objectForKey:@"st"] isEqualToString:@"2"])
                {
                    [self mustupdate:self.resBodyDic];
                }
            }else
             {
//                 if (![[self.resBodyDic objectForKey:@"success"] isEqualToString:@"0"])
//                 {
//                     [Common tipAlert:[self.paramasDic JSONRepresentation]];
//                 }
                self.httpCompletionHandler(self.resBodyDic, self.error);
                [self.manager removeRequestWithKey:self.urlString];
            }
        }

//    NSDictionary *userInfo = nil;
//    VWTNetworkError *error = nil;
//    if (_resBodyDic != nil && [_resBodyDic isKindOfClass:[NSDictionary class]])
//    {
//        BOOL bSuccess = [_resBodyDic[@"success"] isEqualToString:@"Y"];
//        if (bSuccess)
//        {
//            if (self.httpCompletionHandler)
//            {
//                self.httpCompletionHandler(_resBodyDic, nil);
//            }
//        }
//        else
//        {
//            userInfo = @{
//                         NSLocalizedDescriptionKey : _resBodyDic[@"msg"]
//                         };
//            error = [VWTNetworkError errorWithType:NetworkErrorTypeErrorMsg andUerInfo:userInfo];
//            if (self.httpCompletionHandler)
//            {
//                self.httpCompletionHandler(_resBodyDic, error);
//            }
//        }
//    }
//    else
//    {
//        userInfo = @{
//                     NSLocalizedDescriptionKey : @"请求失败!"
//                     };
//        error = [VWTNetworkError errorWithType:NetworkErrorTypeErrorMsg andUerInfo:userInfo];
//        if (self.httpCompletionHandler)
//        {
//            self.httpCompletionHandler(nil, error);
//        }
//    }
    
}

#pragma mark event Methods
-(void)suggestupdate:(NSDictionary * )notify
{
    NSDictionary *dic = notify;
    if (dic != nil && [dic isKindOfClass:[NSDictionary class]])
    {
        self.updateStr = dic[@"ul"];
        NSString* suggestStr = dic[@"msg"];
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:suggestStr delegate:self cancelButtonTitle:@"稍后再说" otherButtonTitles:@"立即更新",nil];
            alert.tag = 11;
            [alert show];
        });
    }
}
-(void)mustupdate:(NSDictionary *)notify
{
    NSDictionary* dic = notify;
    if (dic != nil && [dic isKindOfClass:[NSDictionary class]])
    {
        self.updateStr = dic[@"ul"];
        NSString* mustStr = dic[@"msg"];
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:mustStr delegate:self cancelButtonTitle:nil otherButtonTitles:@"立即更新",nil];
            alert.tag = 12;
            [alert show];
        });
    }
}

#pragma mark AlertViewDelegate


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 11 && buttonIndex == 1)
    {
        if ([self.updateStr hasPrefix:@"http"])
        {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:self.updateStr]];
        }
    }
    else if (alertView.tag == 12 && buttonIndex == 0)
    {
        if ([self.updateStr hasPrefix:@"http"])
        {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:self.updateStr]];
        }
    }
     [self.manager removeRequestWithKey:self.urlString];
}

- (void)cancel
{
    self.uploadImageCompletionHandler = nil;
    self.httpCompletionHandler = nil;
//    [self.httpRequest cancel];
//    self.httpRequest.delegate = nil;
    self.httpRequest = nil;
}

@end
