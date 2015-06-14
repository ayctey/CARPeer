//
//  TXModifyPublishController.h
//  CARPeer

//修改发布信息控制器

//  Created by yezejiang on 15-2-6.
//  Copyright (c) 2015年 ayctey. All rights reserved.
//

#import "TXPublishController.h"

@class TXDepartureTimetableModel;

@interface TXModifyPublishController : TXPublishController<UIAlertViewDelegate>
{
    NSArray *atrribtes;
    int ifShowGoodAlertview;
    int ifShowBadAlertview;
}

@property (nonatomic,strong) TXDepartureTimetableModel *departureModel;
@property (nonatomic,assign) BOOL isFinsh;          //班次是否已经完成发车

@end
