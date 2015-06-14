//
//  TXLoginController.h
//  CARPeer

//登陆控制器

//  Created by yezejiang on 15-1-8.
//  Copyright (c) 2015年 ayctey. All rights reserved.
//

#import "TXBaseViewController.h"
#import "LoginDelegation.h"
@interface TXLoginController : TXBaseViewController<UITextFieldDelegate,UIAlertViewDelegate>
{
    UITextField *userTextField;
    UITextField *passwordTextField;
}

@property (nonatomic,strong) UIImageView *imageView;

@end
