//
//  TXMessagesController.h
//  CARPeer
//
//  Created by yezejiang on 15-1-4.
//  Copyright (c) 2015年 ayctey. All rights reserved.
//

#import "TXBaseViewController.h"

@interface TXMessagesController : TXBaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
}

@end
