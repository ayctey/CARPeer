//
//  TXChangePasswordController.m
//  CARPeer
//
//  Created by yezejiang on 15-1-12.
//  Copyright (c) 2015年 ayctey. All rights reserved.
//

#import "TXChangePasswordController.h"
#import "TXDataService.h"
#import "TXUserMessageController.h"
#import "TXPersonalController.m"
#import "Common.h"

@interface TXChangePasswordController ()
{
    UITextField *newPasswordField;
    UITextField *confirmPasswordField;
}
@end

@implementation TXChangePasswordController

@synthesize tel;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
    self.view.backgroundColor = [UIColor whiteColor];
    [self initViews];
}

#pragma mark - 加载数据
- (void)submitData
{
    NSDictionary *param = @{@"tel":tel, @"password":newPasswordField.text};
    [TXDataService POST:updatePass param:param isCache:NO caChetime:0  completionBlock:^(id responseObject, NSError *error) {
        
        //判断修改是否成功
        if (error == nil) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"修改成功！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
        
    }];
}
#pragma mark - 添加视图
- (void)initViews
{
    UIView *newPwView = [[UIView alloc] init];
    newPwView.backgroundColor = kBackgroundColor;
    newPwView.frame = CGRectMake(0, kNavigationH+10, kScreenWidth, 40);
    [self.view addSubview:newPwView];
    
    newPasswordField = [[UITextField alloc] init];
    newPasswordField.frame = CGRectMake(20, 5, kScreenWidth-40, 30);
    newPasswordField.placeholder = @"新密码";
    newPasswordField.secureTextEntry = YES;
    [newPwView addSubview:newPasswordField];
    
    UIView *confirmPwView = [[UIView alloc] init];
    confirmPwView.backgroundColor = kBackgroundColor;
    confirmPwView.frame = CGRectMake(0, kNavigationH+10+40+10, kScreenWidth, 40);
    [self.view addSubview:confirmPwView];
    
    confirmPasswordField = [[UITextField alloc] init];
    confirmPasswordField.frame = CGRectMake(20, 5, kScreenWidth-40, 30);
    confirmPasswordField.placeholder = @"确认新密码";
    confirmPasswordField.secureTextEntry = YES;
    [confirmPwView addSubview:confirmPasswordField];
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitBtn setTitle:@"确认提交" forState:UIControlStateNormal];
    [submitBtn setBackgroundColor:[UIColor redColor]];
    [submitBtn setFrame:CGRectMake((kScreenWidth-200)/2, kNavigationH+100+20, 200, 30)];
    [submitBtn addTarget:self action:@selector(submitNewPassword) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];
}


#pragma mark - 点击事件
- (void)submitNewPassword
{
    if (![newPasswordField.text isEqualToString:confirmPasswordField.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"输入的两次密码不相同！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }else if([newPasswordField.text length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密码不能设置为空！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        //上传新密码
        [self submitData];
        
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.message isEqualToString:@"修改成功！"]) {
         [self.navigationController popToRootViewControllerAnimated:YES];
    }else
    {
        newPasswordField.text = nil;
        confirmPasswordField.text = nil;
    }
}

@end
