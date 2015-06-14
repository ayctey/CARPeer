//
//  AppDelegate.m
//  CARPeer
//
//  Created by ayctey on 15-1-3.
//  Copyright (c) 2015年 ayctey. All rights reserved.
//

#import "AppDelegate.h"
#import "TXLoginController.h"
#import "TXBaseNavController.h"
#import "MainViewController.h"
#import "TXDataService.h"
#import "SMS_SDK/SMS_SDK.h"
#import "YRJSONAdapter.h"
#import "AFNetworkReachabilityManager.h"
#import "AFHTTPRequestOperationManager.h"
#import "TXLoginRCIM.h"
#import "RCIM.h"
#import "Common.h"
#import "Reachability.h"

@interface AppDelegate ()
{
    BOOL isLogined;
}

@end

@implementation AppDelegate
@synthesize rechable;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen]bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //登录
    [self isLogin];
    
    //网络监测
    [self setNetworkMonitor];
    
    //设置网络缓存
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:8 * 1024 * 1024 diskCapacity:0 diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    
    return YES;
}

// 获取苹果推送权限成功。
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // 设置 deviceToken。
    [[RCIM sharedRCIM] setDeviceToken:deviceToken];
}

//判断是否曾经已经成功登陆，没有重新登录
-(void)isLogin
{
    //获取本地账号密码
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //本地账号密码登陆
    if ([defaults objectForKey:@"account"] && [defaults objectForKey:@"password"]) {
        //是否有网络连接
        
        if (!rechable.isReachable) {
            //进入网络
            MyLog(@"recable:%d",rechable.isReachable);
            [self pushMaincomtroller];
        }else
        {
            NSDictionary *param = @{@"account":[defaults objectForKey:@"account"],@"password":[defaults objectForKey:@"password"]};
            [TXDataService POST:_login param:param isCache:NO caChetime:0 completionBlock:^(id responseObject, NSError *error) {
                NSDictionary *dic = responseObject;
                int success = [[dic objectForKey:@"success"] intValue];
                if (success) {
                    
                    //把登陆状态设置为NO
                    isLogined = YES;
                    
                    //链接融云
                    [[TXLoginRCIM shareLoginRCIM] connectRCIM];
                    
                    MyLog(@"%@",[responseObject objectForKey:@"data"]);
                    NSDictionary *data = [responseObject objectForKey:@"data"];
                    
                    //保存用户信息在本地
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setValue:[data objectForKey:@"account"] forKey:@"account"];
                    [defaults setValue:[data objectForKey:@"birthday"] forKey:@"birthday"];
                    [defaults setValue:[data objectForKey:@"intro"] forKey:@"intro"];
                    [defaults setValue:[data objectForKey:@"isValid"] forKey:@"isValid"];
                    [defaults setValue:[data objectForKey:@"motorcade_Name"] forKey:@"motorcade_Name"];
                    [defaults setValue:[data objectForKey:@"tel"] forKey:@"tel"];
                    [defaults setValue:[data objectForKey:@"password"] forKey:@"password"];
                    [defaults setValue:[data objectForKey:@"protrait_Url"] forKey:@"protrait_Url"];
                    [defaults setValue:[data objectForKey:@"sex"] forKey:@"sex"];
                    [defaults setValue:[data objectForKey:@"trainman_ID"] forKey:@"trainman_ID"];
                    [defaults setValue:[data objectForKey:@"trainman_Name"] forKey:@"trainman_Name"];
                    
                    //进入主页
                    [self pushMaincomtroller];
                }
            }];
        }
    }
    else
    {
        //进入登陆界面
        TXLoginController *login = [[TXLoginController alloc] init];
        TXBaseNavController *nav = [[TXBaseNavController alloc] initWithRootViewController:login];
        nav.navigationBarHidden = YES;
        self.window.rootViewController = nav;
    }
}


#pragma mark - 网络状况监听
-(void)setNetworkMonitor
{
    //实施网络状况监听
    rechable = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStateChange) name:kReachabilityChangedNotification object:nil];
    //延时进行网络监测通知
    [self performSelector:@selector(startNotifier) withObject:nil afterDelay:0.01f];
}

//监控网络状态的变化
-(void)networkStateChange
{
    // 检测手机是否能上网络(WIFI\3G\2.5G)
    Reachability *conn = [Reachability reachabilityForInternetConnection];
    
    // 判断网络状态
    if ([conn currentReachabilityStatus] != NotReachable) {
        if (!isLogined) {
            [self isLogin];
        }
    } else {
        //把登陆状态设置为NO
        isLogined = NO;
        // 没有网络
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"断网啦！" delegate:self cancelButtonTitle:@"好" otherButtonTitles: nil];
        [alert show];
    }
}

//开始网络监测通知
-(void)startNotifier
{
    [rechable startNotifier];
}

-(void)dealloc{
    //停止监听网络状况
    [rechable stopNotifier];
    // 删除通知对象
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - LoginDelegate

//进入主页
-(void)pushMaincomtroller
{
    self.window.rootViewController = nil;
    MainViewController *mainCtrl = [[MainViewController alloc] init];
    self.window.rootViewController = mainCtrl;
}

//进入登陆界面
-(void)pushToLoginViewcontroller
{
    self.window.rootViewController = nil;
    TXLoginController *loginViewController = [[TXLoginController alloc] init];
    self.window.rootViewController = loginViewController;
}

@end
