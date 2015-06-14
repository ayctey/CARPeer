//
//  TXPrefectBusMessageController.m
//  CARPeer

//汽车信息完善控制器

//  Created by yezejiang on 15-1-14.
//  Copyright (c) 2015年 ayctey. All rights reserved.
//

#import "TXPrefectBusMessageController.h"
#import "TXPrefectUserMessageController.h"
#import "Common.h"

@interface TXPrefectBusMessageController ()

@end

@implementation TXPrefectBusMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"汽车信息完善";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initViews];
}

- (void)initViews
{
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"粤";
    label.frame = CGRectMake((kScreenWidth-50)/2-50, 10+kNavigationH, 50, 40);
    //label.backgroundColor = kBackgroundColor;
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    UITextField *chooseField = [[UITextField alloc] init];
    chooseField.frame = CGRectMake((kScreenWidth-50)/2, 10+kNavigationH, 50, 40);
    chooseField.borderStyle = UITextBorderStyleBezel;
    chooseField.backgroundColor = kBackgroundColor;
    [self.view addSubview:chooseField];
    
    NSArray *label_title = @[@"车牌号",@"车辆类型",@"座位数"];
    NSArray *textField_placeholder = @[@"请输入车牌号",@"请输入车辆类型",@"请输入座位数"];
    for (int i = 0; i < label_title.count; i++) {
        UIView *busView = [[UIView alloc] init];
        busView.backgroundColor = kBackgroundColor;
        busView.userInteractionEnabled = YES;
        busView.frame = CGRectMake(5, 50+10+kNavigationH+50*i, kScreenWidth-10, 40);
        [self.view addSubview:busView];
        
        UILabel *busLabel = [[UILabel alloc] init];
        busLabel.text = label_title[i];
        busLabel.backgroundColor = kBackgroundColor;
        busLabel.frame = CGRectMake(5, 5, 80, 30);
        [busView addSubview:busLabel];
        
        UITextField *busField = [[UITextField alloc] init];
        busField.frame = CGRectMake(80, 5, kScreenWidth-100, 30);
        busField.placeholder = textField_placeholder[i];
        [busView addSubview:busField];
    }
    
    UILabel *teamLabel = [[UILabel alloc] init];
    teamLabel.text = @"所属车队：啦啦队";
    teamLabel.frame = CGRectMake(5, kNavigationH+100+10+100, kScreenWidth-10, 30);
    teamLabel.backgroundColor = kBackgroundColor;
    teamLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:teamLabel];
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [submitBtn setBackgroundColor:[UIColor redColor]];
    [submitBtn setFrame:CGRectMake((kScreenWidth-200)/2, kNavigationH+100+20+100+40, 200, 30)];
    [submitBtn addTarget:self action:@selector(nextClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];
}

- (void)nextClick
{
    TXPrefectUserMessageController *userMessage = [[TXPrefectUserMessageController alloc] init];
    [self.navigationController pushViewController:userMessage animated:YES];
}
@end
