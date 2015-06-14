//
//  TXProvinceController.h
//  CARPeer

//省份选择控制器

//  Created by yezejiang on 15-2-5.
//  Copyright (c) 2015年 ayctey. All rights reserved.
//

#import "TXBaseViewController.h"

@interface TXProvinceController : TXBaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *dataArray;
    
}

- (void)getData;
@end
