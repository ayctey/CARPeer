//
//  TXBusTypeViewController.h
//  CARPeer

//  汽车类型选择

//  Created by ayctey on 15-3-19.
//  Copyright (c) 2015年 ayctey. All rights reserved.
//

#import "TXBaseViewController.h"
#import "TXBusTypeIDModel.h"

@protocol TXBusTypeDelegate;

@interface TXBusTypeViewController : TXBaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *dataArray;
    
}

@property (nonatomic,assign) id<TXBusTypeDelegate> delegate;

- (void)getData;

@end

@protocol TXBusTypeDelegate <NSObject>

@required

-(void)setBusType:(TXBusTypeIDModel *)BusTypeIDModel;

@end
