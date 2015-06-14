//
//  TXUserMessageController.h
//  CARPeer

//个人资料控制器

//  Created by yezejiang on 15-1-12.
//  Copyright (c) 2015年 ayctey. All rights reserved.
//

#import "TXBaseViewController.h"

@interface TXUserMessageController : TXBaseViewController<UIActionSheetDelegate>
{
    UIButton *validationBtn;
    int time;
    UITextField *verificationCodeTF;
    UITextField *phoneNumberTF;
}

@property (nonatomic,strong) NSString *userName;
@property (nonatomic,strong) NSString *intro;
@property (nonatomic,strong) NSString *tel;
@property (nonatomic,assign) BOOL isPrefectData;
@end
