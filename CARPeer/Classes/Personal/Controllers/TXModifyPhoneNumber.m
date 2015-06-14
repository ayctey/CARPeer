//
//  TXModifyPhoneNumber.m
//  CARPeer
//
//  Created by yezejiang on 15-2-4.
//  Copyright (c) 2015年 ayctey. All rights reserved.
//

#import "TXModifyPhoneNumber.h"
#import "SMS_SDK/SMS_SDK.h"
#import "SMS_SDK/CountryAndAreaCode.h"
#import "APIManage.h"
#import "TXDataService.h"

@implementation TXModifyPhoneNumber

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"修改绑定手机号";
    phoneNumberTF.placeholder = @"请输入新手机号";
}

- (void)pushToViewController
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:phoneNumberTF.text forKey:@"tel"];
    NSDictionary *param = @{@"tel":phoneNumberTF.text};
    [TXDataService POST:updateTel param:param isCache:NO caChetime:0  completionBlock:^(id responseObject, NSError *error) {
        
        NSDictionary *dic = responseObject;
        int success = [[dic objectForKey:@"success"] intValue];
        //判断是否修改成功
        if (success) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"更改绑定手机号成功！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
    }];
    
}

#pragma mark - 获取验证码
- (void)sendMessage:(UIButton *)button
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *phoneNumber = [defaults objectForKey:@"tel"];
    //判断输入的电话号码是否与原电话号码相同
    if (![phoneNumberTF.text isEqualToString:phoneNumber]) {
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
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"电话与原电话相同，请重新输入" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if([alertView.message isEqualToString:@"电话与原电话相同，请重新输入"])
    {
        phoneNumberTF.text = nil;
    }else if([alertView.message isEqualToString:@"更改绑定手机号成功！"])
    {
    [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
