//
//  TXMessageAuthenticationController.m
//  CARPeer

//短信验证控制器

//  Created by yezejiang on 15-1-12.
//  Copyright (c) 2015年 ayctey. All rights reserved.
//

#import "TXMessageAuthenticationController.h"
#import "TXChangePasswordController.h"
#import "TXPrefectUserMessageController.h"
#import "TXUserMessageController.h"
#import "TXModifyPhoneNumber.h"
#import "TXDataService.h"
#import "SMS_SDK/SMS_SDK.h"
#import "SMS_SDK/CountryAndAreaCode.h"
#import "Common.h"

@class AppDelegate;

@interface TXMessageAuthenticationController ()

@end

@implementation TXMessageAuthenticationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"安全验证";
    self.view.backgroundColor = [UIColor whiteColor];
    time = 60;
    [self initViews];
}

#pragma mark - 添加视图
- (void)initViews
{
    UILabel *navLabel = [[UILabel alloc] init];
    navLabel.frame = CGRectMake(0, kNavigationH, kScreenWidth, 50);
    
    //判断是修改密码还是修改电话号码
    if (viewController == VCChangePasswordController) {
         navLabel.text = @"安全验证>修改密码";
    }
    else if(viewController == VCChangePhoneNumberController){
        navLabel.text = @"安全验证>修改电话号码";
    }else
    {
        navLabel.text = @"绑定电话号码";
    }
    
    navLabel.font = [UIFont systemFontOfSize:15.0f];
    navLabel.backgroundColor = kBackgroundColor;
    navLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:navLabel];
    
    UIView *bgView1 = [[UIView alloc] init];
    bgView1.frame = CGRectMake(0, 60+kNavigationH, kScreenWidth, 50);
    bgView1.backgroundColor = kBackgroundColor;
    [self.view addSubview:bgView1];
    
    phoneNumberTF = [[UITextField alloc] init];
    phoneNumberTF.frame = CGRectMake(20, 10, kScreenWidth-90, 30);
    phoneNumberTF.placeholder = @"手机号";
    phoneNumberTF.text = _phoneNumber;
    phoneNumberTF.keyboardType = UIKeyboardTypeNumberPad;
    if (![phoneNumberTF.text  isEqual: @""]) {
        phoneNumberTF.enabled = NO;
    }
    [bgView1 addSubview:phoneNumberTF];
    
    validationBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [validationBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [validationBtn setFrame:CGRectMake(kScreenWidth-100, 10, 80, 30)];
    [validationBtn addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
    [bgView1 addSubview:validationBtn];
    
    UIView *bgView2 = [[UIView alloc] init];
    bgView2.frame = CGRectMake(0, 60+kNavigationH+52, kScreenWidth, 50);
    bgView2.backgroundColor = kBackgroundColor;
    [self.view addSubview:bgView2];
    
    verificationCodeTF = [[UITextField alloc] init];
    verificationCodeTF.frame = CGRectMake(20, 10, kScreenWidth-90, 30);
    verificationCodeTF.placeholder = @"验证码";
    verificationCodeTF.keyboardType = UIKeyboardTypeNumberPad;
    [bgView2 addSubview:verificationCodeTF];
    
    UIButton *verificationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [verificationBtn setTitle:@"验 证" forState:UIControlStateNormal];
    [verificationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    verificationBtn.backgroundColor = [UIColor redColor];
    [verificationBtn setFrame:CGRectMake((kScreenWidth-120)/2, bgView2.frame.origin.y+70, 120, 40)];
    [verificationBtn addTarget:self action:@selector(verificationClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:verificationBtn];
}

#pragma mark - 获取验证码
- (void)sendMessage:(UIButton *)button
{
    //判断是否联网
    if (![[Reachability reachabilityWithHostName:@"www.baidu.com"] isReachable])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络不佳，请稍后再试" delegate:self cancelButtonTitle:@"好" otherButtonTitles: nil];
        [alertView show];
    }else
    {
        //判断输入电话号码是否为绑定电话号码
        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
        NSString *call = [defaults objectForKey:@"tel"];
        //判断是不是第一次验证电话号码
        if(viewController != VCCTXLoginController )
        {
            if (![call isEqualToString:phoneNumberTF.text]) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"输入号码与绑定号码不匹配。" delegate:self cancelButtonTitle:@"重新输入" otherButtonTitles: nil];
                [alertView show];
            }else
            {
                [self messageAuthentication];
            }
        }else
        {
            [self messageAuthentication];
        }
    }
}

-(void)messageAuthentication
{
    
    [SMS_SDK getVerifyCodeByPhoneNumber:[NSString stringWithFormat:@"%@",phoneNumberTF.text] AndZone:@"86" result:^(enum SMS_GetVerifyCodeResponseState state) {
        
        if (1==state) {
            NSLog(@"block 获取验证码成功");
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countdown:) userInfo:nil repeats:YES];
            
        }
        else if(0==state)
        {
            NSLog(@"block 获取验证码失败");
            NSString* str=[NSString stringWithFormat:NSLocalizedString(@"获取验证码失败", nil)];
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil) message:str delegate:self cancelButtonTitle:NSLocalizedString(@"sure", nil) otherButtonTitles:nil, nil];
            [alert show];
        }
        else if (SMS_ResponseStateMaxVerifyCode==state)
        {
            NSString* str=[NSString stringWithFormat:NSLocalizedString(@"maxcodemsg", nil)];
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"maxcode", nil) message:str delegate:self cancelButtonTitle:NSLocalizedString(@"sure", nil) otherButtonTitles:nil, nil];
            [alert show];
        }
        else if(SMS_ResponseStateGetVerifyCodeTooOften==state)
        {
            NSString* str=[NSString stringWithFormat:NSLocalizedString(@"获取验证码太频繁，请稍后再试", nil)];
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil) message:str delegate:self cancelButtonTitle:NSLocalizedString(@"sure", nil) otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
}

- (void)verificationClick
{
    if(verificationCodeTF.text.length!=4)
    {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"请输入四位验证码", nil) delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        [SMS_SDK commitVerifyCode:verificationCodeTF.text result:^(enum SMS_ResponseState state) {
            if (1==state) {
                NSLog(@"验证成功");
                [self pushToViewController];
            }
            else if(0==state)
            {
                NSLog(@"验证失败");
                NSString* str=[NSString stringWithFormat:NSLocalizedString(@"验证失败", nil)];
                UIAlertView* alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil) message:str delegate:self cancelButtonTitle:NSLocalizedString(@"确定", nil)  otherButtonTitles:nil, nil];
                [alert show];
            }
        }];
    }
}

- (void)countdown:(NSTimer *)timer
{
    time--;
    [validationBtn setTitle:[NSString stringWithFormat:@"%dS",time] forState:UIControlStateDisabled];
    validationBtn.enabled = NO;
    if (time == 0) {
        [validationBtn setTitle:@"发送短信" forState:UIControlStateNormal];
        validationBtn.enabled = YES;
        time = 60;
        [timer invalidate];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)verificationCode
{
    
}

- (void)pushToViewController
{
    if (viewController == VCChangePasswordController) {
        TXChangePasswordController *changePasswordVC = [[TXChangePasswordController alloc] init];
        changePasswordVC.tel = phoneNumberTF.text;
        [self.navigationController pushViewController:changePasswordVC animated:YES];
    }else if(viewController == VCChangePhoneNumberController)
    {
        TXModifyPhoneNumber *modifyVC = [[TXModifyPhoneNumber alloc] init];
        [self.navigationController pushViewController:modifyVC animated:YES];
        
    }
    else if (viewController == VCCTXLoginController)
    {
        NSDictionary *existTelparam = @{@"tel":phoneNumberTF.text,};
        [TXDataService POST:existTel param:existTelparam isCache:NO caChetime:0  completionBlock:^(id responseObject, NSError *error) {
            if (error == nil) {
                NSDictionary *dataDic = responseObject;
                
                //电话号码是否已经被注册
                BOOL exist = (BOOL)[dataDic objectForKey:@"result"];
                if (!exist) {
                    UIAlertView *alerView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"电话号码已被绑定，请重新输入电话号码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [alerView show];
                }else
                {
                    [self perfectPhoneNumber];
                }
            }
         
        }];
    }
}

//完善用户电话
-(void)perfectPhoneNumber
{
    NSDictionary *existTelparam = @{@"tel":phoneNumberTF.text,};
    [TXDataService POST:updateTel param:existTelparam isCache:NO caChetime:0  completionBlock:^(id responseObject, NSError *error) {
        if (error == nil) {
            //保存用户资料在本地
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setValue:phoneNumberTF.text forKey:@"tel"];
             TXUserMessageController *prefectUserMessageController = [[TXUserMessageController alloc] init];
            prefectUserMessageController.isPrefectData = YES;
            [self.navigationController pushViewController:prefectUserMessageController animated:YES];
        }
    }];
}

- (void)pushTo:(enum WhichViewController)vc
{
    viewController = vc;
}

- (void)setPhoneText:(NSString *)phoneNumber
{
    NSLog(@"SET%@",phoneNumber);
    _phoneNumber = phoneNumber;
    phoneNumberTF.enabled = NO;
}

//#pragma mark - UIAlertViewDelegate
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == 0) {
//        id LoginDelegate = [[UIApplication sharedApplication] delegate];
//        if ([LoginDelegate respondsToSelector:@selector(pushMaincomtroller)]) {
//            [LoginDelegate pushMaincomtroller];
//        }
//    }
//}

@end
