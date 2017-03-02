//
//  HomeViewController.h
//  h5App
//
//  Created by YuLinpo on 2016/12/16.
//  Copyright © 2016年 Yulinpo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *webView;

-(void)setWebViewUrl:(NSString *)urlStr;

@end
