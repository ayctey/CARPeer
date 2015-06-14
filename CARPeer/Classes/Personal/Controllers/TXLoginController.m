//
//  TXLoginController.m
//  CARPeer

//登录控制器

//  Created by yezejiang on 15-1-8.
//  Copyright (c) 2015年 ayctey. All rights reserved.
//

#import "TXLoginController.h"
#import "TXMessageAuthenticationController.h"
#import "TXPrefectBusMessageController.h"
#import "TXLoginRCIM.h"
#import "TXDataService.h"
#import "EGOCache.h"
#import <QuartzCore/QuartzCore.h>
#import "Common.h"
#import "Reachability.h"

@interface TXLoginController()
{
    UIButton *loginButton;
    UIActivityIndicatorView *indicatorView;
}
@end

@implementation TXLoginController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //停止指示图
    if ([indicatorView isAnimating]) {
        [indicatorView stopAnimating];
    }
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    //停止指示图
    if ([indicatorView isAnimating]) {
        [indicatorView stopAnimating];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBackgroundColor;
    
    [self configViews];
    
    //添加活动指示图
    [self indicatorView];
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
    [self.view addSubview:indicatorView];
}

#pragma mark - 加载数据
- (void)loginWithData
{
    NSDictionary *param = @{@"account":userTextField.text,@"password":passwordTextField.text};
    [TXDataService POST:_login param:param isCache:NO caChetime:0  completionBlock:^(id responseObject, NSError *error) {
        
        //停止和启动指示图
        if ([indicatorView isAnimating]) {
            [indicatorView stopAnimating];
        }
        NSDictionary *dic = responseObject;
        int success = [[dic objectForKey:@"success"] intValue];
        if (success) {
            //登陆融云
            [[TXLoginRCIM shareLoginRCIM] connectRCIM];
            
            NSLog(@"%@",[responseObject objectForKey:@"data"]);
            NSDictionary *data = [responseObject objectForKey:@"data"];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            //如果账号与之前账号不一样，清空之前缓存数据
            if ([defaults objectForKey:@"account"] != [data objectForKey:@"account"]) {
                NSDictionary *dictionary = [defaults dictionaryRepresentation];
                for(NSString* key in [dictionary allKeys]){
                    [defaults removeObjectForKey:key];
                    [defaults synchronize];
                }
                [[EGOCache globalCache] clearCache];
            }
            [defaults setValue:[data objectForKey:@"account"] forKey:@"account"];
            //判断个人资料是否完善
            NSString *phoneNumber = [data objectForKey:@"tel"];
            if ([phoneNumber length] == 0) {
                //进资料完善页
               [self perfectData];
            }else
            {
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
            
            id LoginDelegate = [[UIApplication sharedApplication] delegate];
            [LoginDelegate pushMaincomtroller];
            } 
        }else
        {
            [self showAlertViewWithMessage:@"账号或密码不正确！"];
            passwordTextField.text = @"";
        }
    }];
}

- (void)configViews
{
    UIImageView *bgImageView = [self ImageViewWithFrame:[UIScreen mainScreen].bounds Image:@"登录背景" In:self.view];
    
    
    _imageView = [self ImageViewWithFrame:CGRectMake(20, kScreenWidth/3, kScreenWidth-40, kScreenWidth-80) Image:@"" In:bgImageView];
    _imageView.backgroundColor = [UIColor colorWithRed:233 green:233 blue:233 alpha:0.4];
    _imageView.layer.cornerRadius = 8;
    
    UIImageView *imageView2 = [self ImageViewWithFrame:CGRectMake(20, 30, _imageView.frame.size.width-40, 120) Image:@"" In:_imageView];
    imageView2.backgroundColor = [UIColor colorWithRed:233 green:233 blue:233 alpha:0.4];
    
    [self ImageViewWithFrame:CGRectMake(15, 10+5, 35, 35) Image:@"登录-人头@2x" In:imageView2];
    
    [self ImageViewWithFrame:CGRectMake(15, 10+40+20+5, 30, 30) Image:@"锁@2x" In:imageView2];
    
    //输入用户名TextField
    userTextField = [[UITextField alloc] init];
    userTextField.frame = CGRectMake(20+50, 10, imageView2.frame.size.width-90, 40);
    userTextField.borderStyle = UITextBorderStyleNone;
    userTextField.placeholder = @"用户名";
    //获取
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"account"]) {
        userTextField.text = [defaults objectForKey:@"account"];
    }
    userTextField.delegate = self;
    [imageView2 addSubview:userTextField];
    
    //输入密码TextField
    passwordTextField = [[UITextField alloc] init];
    passwordTextField.frame = CGRectMake(20+50, 10+40+20, imageView2.frame.size.width-90, 40);
    passwordTextField.placeholder = @"密码";
    passwordTextField.secureTextEntry = YES;
    passwordTextField.tag = 102;
    passwordTextField.delegate = self;
    [imageView2 addSubview:passwordTextField];
    
    UILabel *lineLabel = [[UILabel alloc] init];
    lineLabel.frame = CGRectMake(0, 20+40, _imageView.frame.size.width-40, 1);
    [imageView2 addSubview:lineLabel];
    lineLabel.backgroundColor = [UIColor whiteColor];
    
    //登陆按钮
    loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setTitle:@"登  录" forState:UIControlStateNormal];
    loginButton.backgroundColor = [UIColor colorWithRed:233 green:233 blue:233 alpha:0.4];
    [loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [loginButton setFrame:CGRectMake((_imageView.frame.size.width-180)/2, imageView2.frame.origin.y+150, 180, 40)];
    [loginButton addTarget:self action:@selector(loginClick:) forControlEvents:UIControlEventTouchUpInside];
    [_imageView addSubview:loginButton];
    
    UIButton *forgetPassword = [UIButton buttonWithType:UIButtonTypeCustom];
    [forgetPassword setFrame:CGRectMake(kScreenWidth-120, _imageView.frame.origin.y+kScreenWidth-80+30, 120, 25)];
    [forgetPassword setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [forgetPassword addTarget:self action:@selector(forgetPasswordClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetPassword];
    
}

//忘记密码
- (void)forgetPasswordClick
{
    TXMessageAuthenticationController *authen = [[TXMessageAuthenticationController alloc] init];
    [authen pushTo:VCChangePasswordController];
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController pushViewController:authen animated:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [self unregNotification];
}

//登陆按钮触发登陆事件
- (void)loginClick:(UIButton *)sender
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
    
    [loginButton endEditing:YES];
    if (userTextField.text == nil || passwordTextField.text == nil) {
        [self showAlertViewWithMessage:@"账号或密码不能为空!"];
    }else
    {
        [self loginWithData];
    }
    [self.view endEditing:YES];
}

- (UIImageView *)ImageViewWithFrame:(CGRect)frame Image:(NSString *)image In:(UIView *)view
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = frame;
    imageView.image = [UIImage imageNamed:image];
    imageView.userInteractionEnabled = YES;
    [view addSubview:imageView];
    return imageView;
}

- (void)showAlertViewWithMessage:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

#pragma mark - reg & unreg notification

- (void)regNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)unregNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

#pragma mark - notification handler

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect beginKeyboardRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endKeyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat yOffset = (endKeyboardRect.origin.y - beginKeyboardRect.origin.y)/2;
    
    CGRect inputFieldRect = _imageView.frame;
    CGRect moreBtnRect = passwordTextField.frame;
    
    inputFieldRect.origin.y += yOffset;
    moreBtnRect.origin.y += yOffset;
    [UIView animateWithDuration:duration animations:^{
        _imageView.frame = inputFieldRect;
    }];
}

#pragma mark - UITextField delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    //注册通知
    if (iPhone4) {
        [self regNotification];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    //注册通知
    [self unregNotification];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    BOOL isresign = [textField resignFirstResponder];
    [self unregNotification];
    return isresign;
    
}

//进资料完善页
-(void)perfectData
{
    TXMessageAuthenticationController *authen = [[TXMessageAuthenticationController alloc] init];
    [authen pushTo:VCCTXLoginController];
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController pushViewController:authen animated:YES];
}

#pragma mark - UialertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //停止和启动指示图
    if ([indicatorView isAnimating]) {
        [indicatorView stopAnimating];
    }
}

@end
