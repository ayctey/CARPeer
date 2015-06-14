//
//  TXProvinceController.m
//  CARPeer
//
//  Created by yezejiang on 15-2-5.
//  Copyright (c) 2015年 ayctey. All rights reserved.
//

#import "TXProvinceController.h"
#import "TXDataService.h"
#import "TXProvinceModel.h"
#import "TXCitiesController.h"
#import "TXAreaController.h"
#import "NSString+MD5.h"
#import "Common.h"

@implementation TXProvinceController

- (void)viewDidLoad
{
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
    [TXDataService GET:getProvince param:nil isCache:YES caChetime:24*60*60 completionBlock:^(id responseObject, NSError *error) {
        NSArray *data = responseObject;
        dataArray = [NSMutableArray array];
        for (NSDictionary *row in data) {
            TXProvinceModel *provinceModel = [[TXProvinceModel alloc] initWithDataDic:row];
            [dataArray addObject:provinceModel];
        }
        [_tableView reloadData];
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
    TXProvinceModel *provinceModel = dataArray[indexPath.row];
    cell.textLabel.text = provinceModel.province;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TXProvinceModel *provinceModel = dataArray[indexPath.row];
    TXCitiesController *cities = [[TXCitiesController alloc] init];
    cities.province_id = provinceModel.province_id;
    [self.navigationController pushViewController:cities animated:YES];
}

@end
