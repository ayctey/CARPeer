//
//  TXBusTypeViewController.m
//  CARPeer
//
//  Created by ayctey on 15-3-19.
//  Copyright (c) 2015年 ayctey. All rights reserved.
//

#import "TXBusTypeViewController.h"
#import "TXDataService.h"
#import "Common.h"
#import "TXBusTypeIDModel.h"

@interface TXBusTypeViewController ()

@end

@implementation TXBusTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableView];
    [self getData];
}

- (void)initTableView
{
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

- (void)getData
{
    //获取数据
    [TXDataService GET:getVehicleType param:nil isCache:YES caChetime:15*24*60*60 completionBlock:^(id responseObject, NSError *error) {
        if(error == nil)
        {
            NSArray *data = [responseObject objectForKey:@"rows"];
            dataArray = [NSMutableArray array];
            for (NSDictionary *row in data) {
                TXBusTypeIDModel *provinceModel = [[TXBusTypeIDModel alloc] initWithDataDic:row];
                [dataArray addObject:provinceModel];
            }
            [_tableView reloadData];
        }
    }];
}

#pragma mark - 表视图协议

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentify = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
        
    }
    TXBusTypeIDModel *busTypeModel = dataArray[indexPath.row];
    cell.textLabel.text = busTypeModel.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TXBusTypeIDModel *busTypeModel = dataArray[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(setBusType:)]) {
        [self.delegate setBusType:busTypeModel];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

@end
