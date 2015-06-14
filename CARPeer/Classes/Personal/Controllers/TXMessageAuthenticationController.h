//
//  TXMessageAuthenticationController.h
//  CARPeer
//
//  Created by yezejiang on 15-1-12.
//  Copyright (c) 2015年 ayctey. All rights reserved.
//

#import "UIKit/UIKit.h"
#import "TXBaseViewController.h"
#import "LoginDelegation.h"

enum WhichViewController{
    VCChangePasswordController = 1,
    VCChangePhoneNumberController,
    VCCTXLoginController,
};

@interface TXMessageAuthenticationController : TXBaseViewController<UIAlertViewDelegate>
{
    UIButton *validationBtn;
    int time;
    UITextField *verificationCodeTF;
    UITextField *phoneNumberTF;
    enum WhichViewController viewController;
    NSString *_phoneNumber;
    
}

- (void)pushTo:(enum WhichViewController)vc;
- (void)setPhoneText:(NSString *)phoneNumber;
- (void)pushToViewController;

@end
