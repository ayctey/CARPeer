//
//  TXPersonalController.m
//  CARPeer

//个人中心控制器

//  Created by yezejiang on 15-1-4.
//  Copyright (c) 2015年 ayctey. All rights reserved.
//

#import "TXPersonalController.h"
#import "TXUserMessageController.h"
#import "TXLicensePlateListController.h"
#import "TXMessageAuthenticationController.h"
#import "TXLoginController.h"
#import "TXAboutController.h"
#import "TXDataService.h"
#import "UserView.h"
#import "Common.h"

#define userView_height 80

@interface TXPersonalController ()
{
    UserView *userView;
}
@end

@implementation TXPersonalController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initViews];
    
    [self addBarItem];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self getData];
}

#pragma mark - 加载数据
- (void)getData
{
    //获取用户数据
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userName = [defaults objectForKey:@"trainman_Name"];
    NSString *tel = [defaults objectForKey:@"tel"];
    NSString *url = [defaults objectForKey:@"protrait_Url"];

    //填充用户数据
    userView.userName.text = userName;
    userView.accout.text = tel;
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    userView.headImage.image = [UIImage imageWithData:imageData];
    
}
#pragma mark - 添加BarButton
- (void)addBarItem
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"注 销" style:UIBarButtonItemStyleDone target:self action:@selector(cancellationClick)];
    item.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)initViews
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTapClick:)];
    
    userView = [[UserView alloc] init];
    userView.frame = CGRectMake(0, kNavigationH, kScreenWidth, userView_height);
    userView.backgroundColor = kBackgroundColor;
    
    [userView addGestureRecognizer:tapGesture];
    [self.view addSubview:userView];
    
    
    NSArray *title_arr = @[@"车牌号码",@"运营公司或车队",@"密码保护",@"关于"];
    for (int i = 0; i < title_arr.count; i++) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        UIView *view = [[UIView alloc] init];
        view.tag = 100+i;
        view.backgroundColor = kBackgroundColor;
        view.frame = CGRectMake(0, userView_height+kNavigationH+kSpacing+45*i, kScreenWidth, 40);
        [view addGestureRecognizer:tap];
        [self.view addSubview:view];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.frame = CGRectMake(10, 5, 120, 30);
        titleLabel.font = [UIFont systemFontOfSize:15.0f];
        titleLabel.text = title_arr[i];
        titleLabel.tag = 20+i;
        [view addSubview:titleLabel];
    }
}

- (void)userTapClick:(UITapGestureRecognizer *)tap
{
    TXUserMessageController *messageVC = [[TXUserMessageController alloc] init];
    messageVC.isPrefectData = NO;
    messageVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:messageVC animated:YES];
}

- (void)tapClick:(UITapGestureRecognizer *)tap
{
    NSLog(@"%ld",(long)tap.view.tag);
    if (tap.view.tag == 100) {
        TXLicensePlateListController *licenseVC = [[TXLicensePlateListController alloc] init];
        licenseVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:licenseVC animated:YES];
    }else if (tap.view.tag == 102)
    {
         NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *tel = [defaults objectForKey:@"tel"];
        TXMessageAuthenticationController *authenticationVC = [[TXMessageAuthenticationController alloc] init];
        [authenticationVC pushTo:VCChangePasswordController];
        [authenticationVC setPhoneText:tel];
        authenticationVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:authenticationVC animated:YES];
    }else if (tap.view.tag == 103)
    {
        TXAboutController *aboutVC = [[TXAboutController alloc] init];
        aboutVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:aboutVC animated:YES];
    }
}

- (void)cancellationClick
{
//    //注销登录
//    [TXDataService POST:loginOut param:nil isCache:NO caChetime:0 completionBlock:nil];
    
    //清空密码
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"password"];
    [defaults removeObjectForKey:@"token"];
    [defaults removeObjectForKey:@"isFirstLogin"];
    
    TXLoginController *login = [[TXLoginController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:login];
    [self presentViewController:nav animated:YES completion:^{
       
    }];
}

- (void)addbackButton{}

@end
