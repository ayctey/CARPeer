//
//  TXLicensePlateListController.h
//  CARPeer

//车牌号控制器

//  Created by yezejiang on 15-1-12.
//  Copyright (c) 2015年 ayctey. All rights reserved.
//

#import "TXBaseViewController.h"

@class TXBusTypeIDModel;

@interface TXLicensePlateListController : TXBaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    BOOL canEdit;
    UITableView *_tableView;
    NSInteger index;
    NSString *selectText;    //选中的车牌号
    NSString *vehicle_id;    //选中的车牌号ID
    NSMutableArray *busArray;
    TXBusTypeIDModel *busTypeModel;
    NSInteger  _index;
}

- (void)setCanEdit:(BOOL)edit;

@end
