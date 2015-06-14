//
//  TXMoodifyUserNameController.m
//  CARPeer

//修改用户名控制器

//  Created by yezejiang on 15-1-14.
//  Copyright (c) 2015年 ayctey. All rights reserved.
//

#import "TXMoodifyUserNameController.h"
#import "TXDataService.h"
#import "TXUserMessageController.h"
#import "Common.h"

@interface TXMoodifyUserNameController ()
{
    UIActivityIndicatorView *indicatorView; //活动指示图
}

@end

@implementation TXMoodifyUserNameController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"姓名修改";
    self.view.backgroundColor = kBackgroundColor;
    
    userNameField = [[UITextField alloc] init];
    userNameField.frame = CGRectMake(20, 10+kNavigationH, kScreenWidth-40, 35);
    userNameField.borderStyle = UITextBorderStyleNone;
    userNameField.backgroundColor = [UIColor whiteColor];
    userNameField.text = nameString;
    [userNameField becomeFirstResponder];
    [self.view addSubview:userNameField];
    
    UIButton *modifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [modifyBtn setFrame:CGRectMake(20, 70+kNavigationH, kScreenWidth-40, 35)];
    [modifyBtn setBackgroundColor:[UIColor redColor]];
    [modifyBtn setTitle:@"保存修改" forState:UIControlStateNormal];
    [modifyBtn addTarget:self action:@selector(modifyClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:modifyBtn];
    
    //活动指示图
    [self indicatorView];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    if ([indicatorView isAnimating]) {
        [indicatorView stopAnimating];
    }
}

//活动指示图
-(void)indicatorView
{
    indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [indicatorView setCenter:CGPointMake(kScreenWidth/2, kScreenHeight/2)];
    [indicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    indicatorView.backgroundColor = [UIColor blackColor];
    indicatorView.alpha = 0.5;
    //设置背景为圆角矩形
    indicatorView.layer.cornerRadius = 6;
    [[[UIApplication sharedApplication].delegate window] addSubview:indicatorView];
}

#pragma mark - 加载数据
- (void)modifyUserName
{
    //停止和启动指示图
    if ([indicatorView isAnimating]) {
        [indicatorView stopAnimating];
    }
    else
    {
        if ([[Reachability reachabilityWithHostName:@"www.baidu.com"] isReachable]) {
            [indicatorView startAnimating];
        }
    }
    
    NSDictionary *param = @{@"trainman_name":userNameField.text};
    [TXDataService POST:updateTrainmanName param:param isCache:NO caChetime:0  completionBlock:^(id responseObject, NSError *error) {
        
        //停止活动指示图
        if ([indicatorView isAnimating]) {
            [indicatorView stopAnimating];
        }
        
        if(error != nil)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"修改不成功！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"好", nil];
            [alert show];
        }
        
        if ([responseObject objectForKey:@"success"]) {
            NSLog(@"responseObject:%@",[responseObject objectForKey:@"message"]);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"修改成功！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"好", nil];
            [alert show];
        }
    }];
}
#pragma mark - 点击事件
- (void)modifyClick
{
    [self modifyUserName];
    //[self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if([alertView.message isEqualToString:@"修改成功！"])
    {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"userName" object:userNameField.text];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:userNameField.text forKey:@"trainman_Name"];
    [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark - 其他事件
- (void)getName:(NSString *)name
{
    nameString = name;
}
@end
