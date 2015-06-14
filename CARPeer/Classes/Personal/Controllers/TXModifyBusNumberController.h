//
//  TXModifyBusNumberController.h
//  CARPeer

//修改车辆信息控制器

//  Created by yezejiang on 15-1-13.
//  Copyright (c) 2015年 ayctey. All rights reserved.
//

#import "TXBaseViewController.h"
#import "TXBusTypeViewController.h"
#import "TXBusTypeIDModel.h"
#import "TXBusMessageModel.h"

@interface TXModifyBusNumberController : TXBaseViewController<UIAlertViewDelegate,TXBusTypeDelegate,UITextFieldDelegate>
{
    NSInteger index;
    TXBusTypeIDModel *busTypeIDModel;
    UIActivityIndicatorView *indicatorView;//活动指示图    
}

@property (nonatomic,strong) TXBusMessageModel *busModel;

- (void)setBusNumber:(NSString *)number type:(NSString *)type busID:(NSString *)busId row:(NSInteger)row mySiteNumber:(NSString *)mySiteNumber;
- (void)modifyClick;
@end
