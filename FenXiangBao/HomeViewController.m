//
//  HomeViewController.m
//  h5App
//
//  Created by YuLinpo on 2016/12/16.
//  Copyright © 2016年 Yulinpo. All rights reserved.
//

#import "HomeViewController.h"
#import "LeadViewController.h"

#import "WXApi.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>

#import "NSURLRequest+SSL.h"

#import "macro.h"
#import "NSDictionary+NSNull.h"
#import "AppDelegate.h"

#import "AFNetworking.h"

typedef void(^CallBack)(NSDictionary*);

#import <JavaScriptCore/JavaScriptCore.h>

@protocol JSObjcDelegate <JSExport>

-(void)appShareToWx:(NSString *)jsonStr;
-(void)appShareFriendToWx:(NSString *)jsonStr;
- (void)weibo:(NSString *)jsonStr;
-(void)qqSpace:(NSString *)jsonStr;
-(void)qqFriend:(NSString *)jsonStr;
-(NSString *)getAppVersion;
-(void)jPushRegistrationID:(NSString *)jsonStr;
-(void)noticeMovement;

@end

@interface HomeViewController ()<UIWebViewDelegate, WXApiDelegate, JSObjcDelegate, NSURLConnectionDelegate>


@property (weak, nonatomic) IBOutlet UIView *RequestTimeOutView;
@property (weak, nonatomic) IBOutlet UIButton *RefreshBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;

@property (strong, nonatomic) NSURLRequest * currentRequest;//当前请求

@property (strong, nonatomic) JSContext * jsonContext;

@property (strong, nonatomic) NSURLRequest * request;
@property (copy, nonatomic) NSString * backJsonStr;
@property(nonatomic ,copy) CallBack callback;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    LeadViewController * leadVc = [[LeadViewController alloc]init];
    [self addChildViewController:leadVc];
    [leadVc didMoveToParentViewController:self];
    [self.view addSubview:leadVc.view];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBarHidden = YES;
    if (self.urlStr) {
        [self setWebViewUrl:self.urlStr];
    }else{
        [self setWebViewUrl:kWebUrl];
    }
    
    //刷新按钮设置
    self.RefreshBtn.layer.cornerRadius = 8;
    self.RefreshBtn.layer.masksToBounds = YES;
    self.RefreshBtn.layer.borderColor = [UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1.0].CGColor;
    self.RefreshBtn.layer.borderWidth = 1;
    
    self.RequestTimeOutView.hidden = YES;
    self.bgView.hidden = NO;
    [self.indicatorView startAnimating];
    
    //手动查找登录账号信息
//    if (self.backJsonStr && self.backJsonStr.length > 0){
//        
//    }else{
//        [self getAccountInfo];
//    }
}
//设置webView、url
-(void)setWebViewUrl:(NSString *)urlStr{
//    NSString* path = [[NSBundle mainBundle] pathForResource:@"test1" ofType:@"html"];
//    NSURL* url = [NSURL fileURLWithPath:path];
    NSURL *url =[NSURL URLWithString:urlStr];
    _request =[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:15.0];
    [NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:@"https"];
    self.webView.delegate = self;
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.opaque = NO;
    [self.webView loadRequest:_request];
    
    self.webView.scrollView.bounces = NO;
    
    self.jsonContext = [_webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.jsonContext[@"jsObj"] = self;
    self.jsonContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"异常信息：%@", exceptionValue);
    };
}
#pragma mark 刷新
- (IBAction)refresh:(id)sender {
    if (self.currentRequest) {
        self.bgView.hidden = NO;
        [self.indicatorView startAnimating];
        [self.webView loadRequest:self.currentRequest];
    }
}

#pragma mark 向后台注册极光id
-(void)noticeMovement{
//    [self alert:@"12345"];
    [self getAccountInfo];
}
-(void)regiestJpushID{
    {
       dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString * systemId = [[NSUserDefaults standardUserDefaults] objectForKey:@"channel_id"];
            if (self.backJsonStr && self.backJsonStr.length > 0 && systemId) {
                NSDictionary * dic = [self dictionaryWithJsonString:self.backJsonStr];
                NSString * urlStr = [NSString stringWithFormat:@"%@app/getJpushInfo", [dic objectForKey:@"serverseIp"]];
                NSDictionary * headDic = @{
                                           @"token" : [dic objectForKey:@"token"]
                                           };
                NSDictionary * bodyDic = @{
                                           @"userAccount" : [dic objectForKey:@"userAccount"],
                                           @"systemType" : @"ios",
                                           @"systemId" : systemId
                                           };
                
                AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
                NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:nil error:nil];
                req.timeoutInterval= 10;
                [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:bodyDic options:NSJSONWritingPrettyPrinted error:nil];
                [req setHTTPBody:jsonData];
                req.allHTTPHeaderFields = headDic;
                AFHTTPResponseSerializer *resonseSerial =  [AFHTTPResponseSerializer serializer];
                resonseSerial.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/javascript",@"text/plain", nil];
                manager.responseSerializer = resonseSerial;
                [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (!error) {
                            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                            NSLog(@"%@",dic);
                        } else {
                            NSLog(@"%@", error.localizedDescription);
                        }
                    });
                }] resume];
            }
        });
    }
}

#pragma mark webViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    self.currentRequest = request;
    self.jsonContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.jsonContext[@"jsObj"] = self;
    self.jsonContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"异常信息：%@", exceptionValue);
    };
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    self.bgView.hidden = YES;
    [self.indicatorView stopAnimating];
    self.jsonContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.jsonContext[@"jsObj"] = self;
    self.jsonContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"异常信息：%@", exceptionValue);
    };
    self.RequestTimeOutView.hidden = YES;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    self.bgView.hidden = YES;
    [self.indicatorView stopAnimating];
    self.RequestTimeOutView.hidden = NO;
}
#pragma mark 获取账号信息
-(void)getAccountInfo{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5*NSEC_PER_SEC), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        JSValue *jsCallBack = self.jsonContext[@"pusheds"];
        [jsCallBack callWithArguments:@[]];
        if (self.backJsonStr && self.backJsonStr.length > 0){
            [self regiestJpushID];
        }else{
            [self getAccountInfo];
        }
    });
}

#pragma mark private method Json字符串和dic转换
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
#pragma mark 获取版本信息
-(NSString *)getAppVersion{
    NSString *versionStr=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSString * appId = @"dp_client_IOS";
    NSDictionary * dic = @{@"version":versionStr, @"appid":appId};
    return [self dictionaryToJson:dic];
}

#pragma mark 获取极光推送注册ID
-(void)jPushRegistrationID:(NSString *)jsonStr{
    self.backJsonStr = nil;
    if (jsonStr && jsonStr.length > 0) {
        self.backJsonStr = jsonStr;
    }
}

#pragma mark ShareToWechat
//微信好友
-(void)appShareToWx:(NSString *)jsonStr{
    [self shareToWeChat:0 Info:[self dictionaryWithJsonString:jsonStr]];
}

//微信朋友圈
-(void)appShareFriendToWx:(NSString *)jsonStr{
    [self shareToWeChat:1 Info:[self dictionaryWithJsonString:jsonStr]];
}
//微信分享
-(void)shareToWeChat:(int)scene Info:(NSDictionary *)dic{
    if (![WXApi isWXAppInstalled]) {
        [self alert:@"未找到微信，请安装"];
        return;
    }
    //创建发送对象实例
    SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
    sendReq.bText = NO;//不使用文本信息
    sendReq.scene = scene;//0 = 好友列表 1 = 朋友圈 2 = 收藏
    
    if (scene == 0) {
        //创建分享内容对象
        WXMediaMessage *urlMessage = [WXMediaMessage message];
        urlMessage.title = [dic notNullObjectForKey:@"title"];//分享标题
        urlMessage.description = [dic notNullObjectForKey:@"desc"];//分享描述
        NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[dic notNullObjectForKey:@"imgUrl"]]];
        UIImage * img = [UIImage imageWithData:imgData];
        if (!img) {
            img = [UIImage imageNamed:@""];
        }
        [urlMessage setThumbImage:img];
        
        //创建多媒体对象
        WXWebpageObject *webObj = [WXWebpageObject object];
        webObj.webpageUrl = [dic notNullObjectForKey:@"url"];
        
        //完成发送对象实例
        urlMessage.mediaObject = webObj;
        sendReq.message = urlMessage;
        
        //发送分享信息
        dispatch_async(dispatch_get_main_queue(), ^{
            [WXApi sendReq:sendReq];
        });
    }else if (scene == 1){
        //创建分享内容对象
        WXMediaMessage *urlMessage = [WXMediaMessage message];
        urlMessage.title = [dic notNullObjectForKey:@"title"];//分享标题
        urlMessage.description = [dic notNullObjectForKey:@"desc"];//分享描述
        NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[dic notNullObjectForKey:@"imgUrl"]]];
        UIImage * img = [UIImage imageWithData:imgData];
        if (!img) {
            img = [UIImage imageNamed:@""];
        }
        [urlMessage setThumbImage:img];
        
        //创建多媒体对象
        WXWebpageObject *webObj = [WXWebpageObject object];
        webObj.webpageUrl = [dic notNullObjectForKey:@"url"];//分享链接
        
        //完成发送对象实例
        urlMessage.mediaObject = webObj;
        sendReq.message = urlMessage;
        //发送分享信息
        dispatch_async(dispatch_get_main_queue(), ^{
            [WXApi sendReq:sendReq];
        });
    }
}

#pragma mark 微博分享
- (void)weibo:(NSString *)jsonStr
{
    // 获取AppDelegate
    AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    /**
     第三方应用向微博客户端请求认证的消息结构
     
     第三方应用向微博客户端申请认证时，需要调用[WeiboSDK sendRequest:]函数， 向微博客户端发送一个WBAuthorizeRequest的消息结构。
     
     微博客户端处理完后会向第三方应用发送一个结构为WBAuthorizeResponse的处理结果。
     */
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    // 微博开放平台第三方应用授权回调页地址，默认为`http://`
    authRequest.redirectURI = @"http://www.sina.com";
    // 微博开放平台第三方应用scope，多个scope用逗号分隔
    authRequest.scope = @"all";
    // 第三方应用发送消息至微博客户端程序的消息结构体，其中message类型我会在下面放出
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:[self messageToShare:[self dictionaryWithJsonString:jsonStr]] authInfo:authRequest access_token:myDelegate.wbtoken];
    // 自定义信息字典，用于数据传输过程中存储相关的上下文环境数据
    
    // 第三方应用给微博客户端程序发送request时，可以在userInfo中存储请求相关的信息。
    request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    // 发送请求给微博客户端程序，并切换到微博
    
    // 请求发送给微博客户端程序之后，微博客户端程序会进行相关的处理，处理完成之后一定会调用 [WeiboSDKDelegate didReceiveWeiboResponse:] 方法将处理结果返回给第三方应用
    dispatch_async(dispatch_get_main_queue(), ^{
        [WeiboSDK sendRequest:request];
    });
}
//微博分享内容
-(WBMessageObject *)messageToShare:(NSDictionary *)dic{
    WBMessageObject *message = [WBMessageObject message];
    // 消息中包含的网页数据对象
    WBWebpageObject *webpage = [WBWebpageObject object];
    // 对象唯一ID，用于唯一标识一个多媒体内容
    // 当第三方应用分享多媒体内容到微博时，应该将此参数设置为被分享的内容在自己的系统中的唯一标识
    webpage.objectID = @"identifier1";
    webpage.title = NSLocalizedString([dic notNullObjectForKey:@"title"], nil);
    webpage.description = [NSString stringWithFormat:NSLocalizedString([dic notNullObjectForKey:@"desc"], nil), [[NSDate date] timeIntervalSince1970]];
    // 多媒体内容缩略图
    webpage.thumbnailData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[dic notNullObjectForKey:@"imgUrl"]]];
    // 网页的url地址
    webpage.webpageUrl = [dic notNullObjectForKey:@"url"];
    // 消息的多媒体内容
    message.mediaObject = webpage;
    return message;
}

#pragma mark QQ分享
//qq空间
-(void)qqSpace:(NSString *)jsonStr{
    [self ShareToQQ:0 Info:[self dictionaryWithJsonString:jsonStr]];
}
//qq好友
-(void)qqFriend:(NSString *)jsonStr{
    [self ShareToQQ:1 Info:[self dictionaryWithJsonString:jsonStr]];
}
//qq分享
-(void)ShareToQQ:(int)scene Info:(NSDictionary *)dic{
    if (![QQApiInterface isQQInstalled]) {
        [self alert:@"未找到QQ，请安装"];
        return;
    }
    NSString *url = [dic notNullObjectForKey:@"url"];
    // 分享图、预览图URL地址
    NSString *previewImageUrl = [dic notNullObjectForKey:@"imgUrl"];
    //分享内容
    QQApiNewsObject *newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:url] title:[dic notNullObjectForKey:@"title"] description:[dic notNullObjectForKey:@"desc"] previewImageURL:[NSURL URLWithString:previewImageUrl]];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    // 将内容分享到qzone
    dispatch_async(dispatch_get_main_queue(), ^{
        if (scene == 0) {
            [QQApiInterface SendReqToQZone:req];
        }else if (scene == 1){// 分享到QQ好友
            [QQApiInterface sendReq:req];
        }
    });
    
}
#pragma mark 弹窗
-(void)alert:(NSString *)str{
    [[[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
}

#pragma mark 清理webView缓存
-(void)viewWillDisappear:(BOOL)animated{
    _webView = nil;
    [self cleanCacheAndCookie];
}

- (void)cleanCacheAndCookie{
    //清除cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]){
        [storage deleteCookie:cookie];
    }
    
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
