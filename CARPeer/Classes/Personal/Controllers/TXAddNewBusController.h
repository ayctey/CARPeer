//
//  TXAddNewBusController.h
//  CARPeer

//添加车辆控制器

//  Created by yezejiang on 15-2-4.
//  Copyright (c) 2015年 ayctey. All rights reserved.
//

#import "TXModifyBusNumberController.h"
#import "TXBusTypeViewController.h"
#import "LoginDelegation.h"

@interface TXAddNewBusController : TXModifyBusNumberController<TXBusTypeDelegate>

@property (nonatomic,assign) BOOL isPrefect;

@end
