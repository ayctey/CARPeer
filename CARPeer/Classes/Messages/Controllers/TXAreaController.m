//
//  TXAreaController.m
//  CARPeer
//
//  Created by yezejiang on 15-2-5.
//  Copyright (c) 2015年 ayctey. All rights reserved.
//

#import "TXAreaController.h"
#import "TXPublishController.h"
#import "TXDataService.h"
#import "TXAreaModel.h"
#import "NSString+MD5.h"
#import "EGOCache.h"
#import "Common.h"

@implementation TXAreaController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

//获取数据
- (void)getData
{
    NSDictionary *param = @{@"city_id":_city_id};
    [TXDataService GET:getArea param:param isCache:YES caChetime:24*60*60 completionBlock:^(id responseObject, NSError *error) {
    NSArray *data = responseObject;
    areaData = [NSMutableArray array];
    //获取数据
    for (NSDictionary *row in data) {
       TXAreaModel *areaModel = [[TXAreaModel alloc] initWithDataDic:row];
        [areaData addObject:areaModel];
    }
    [_tableView reloadData];
   }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return areaData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentify = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
        
    }
    TXAreaModel *areaModel = areaData[indexPath.row];
    cell.textLabel.text = areaModel.area;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TXPublishController *secondViewController = self.navigationController.viewControllers[1];
    TXAreaModel *areaModel = areaData[indexPath.row];
    NSDictionary *info = @{@"area_id":areaModel.area_id,@"city":_city,@"area":areaModel.area};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cityMessage" object:info];
    [self.navigationController popToViewController:secondViewController animated:YES];
}

@end
