//
//  LeadViewController.m
//  FenXiaoBao
//
//  Created by YuLinpo on 2017/3/31.
//  Copyright © 2017年 Yulinpo. All rights reserved.
//

#import "LeadViewController.h"
#import "HomeViewController.h"
#import "AppDelegate.h"

@interface LeadViewController ()

@property(nonatomic,assign) NSTimer *watingNSTimer;
@property(nonatomic,strong) NSDate *startDateTime;//开始时间

@property (weak, nonatomic) IBOutlet UILabel *leadLabel;

@end

@implementation LeadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.leadLabel.layer.cornerRadius = 15;
    self.leadLabel.layer.masksToBounds = YES;
    
    [self p_initWatingTime];
}

-(void)p_initWatingTime
{
    if(!self.watingNSTimer){ //启动时间计时器
        self.startDateTime=[NSDate date];
        self.watingNSTimer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(p_cumulativeTime) userInfo:nil repeats:YES];
        [self.watingNSTimer fire];
        
    }
}
//移除时间计时器
-(void)deallocTime
{
    if([self.watingNSTimer isValid]){
        [self.watingNSTimer invalidate];
        self.watingNSTimer=nil;
    }else{
        [self.watingNSTimer invalidate];
        self.watingNSTimer=nil;
    }
}

//时间倒计时
-(void)p_cumulativeTime
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSInteger lastTime = 3 - [[NSDate date] timeIntervalSinceDate:self.startDateTime];
        if (lastTime <= 0) {
            [self turnToHome:nil];
        }else{
            self.leadLabel.text = [NSString stringWithFormat:@"%ld  跳过", (long)lastTime];
        }
    });
}

- (IBAction)turnToHome:(id)sender {
    [self deallocTime];
//    AppDelegate *appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
//    HomeViewController *homeVc = [[HomeViewController alloc] init];
//    homeVc.navigationController.navigationBarHidden = YES;
//    if (self.urlStr) {
//        homeVc.urlStr = self.urlStr;
//    }
////    homeVc.urlStr = @"https://www.baidu.com";
//    appDelegate.window.rootViewController = homeVc;
    self.view.hidden = YES;
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
