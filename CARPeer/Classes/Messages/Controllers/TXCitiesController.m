//
//  TXCitierController.m
//  CARPeer
//
//  Created by yezejiang on 15-2-5.
//  Copyright (c) 2015年 ayctey. All rights reserved.
//

#import "TXCitiesController.h"
#import "TXDataService.h"
#import "TXAreaController.h"
#import "TXCitiesModel.h"
#import "NSString+MD5.h"
#import "EGOCache.h"
#import "Common.h"

@implementation TXCitiesController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)getData
{
    NSDictionary *param = @{@"province_id":_province_id};
    [TXDataService GET:getCity param:param isCache:YES caChetime:24*60*60 completionBlock:^(id responseObject, NSError *error) {
        cityData = responseObject;
        
        NSArray *data = responseObject;
        cityData = [NSMutableArray array];
        for (NSDictionary *row in data) {
            TXCitiesModel *cityModel = [[TXCitiesModel alloc] initWithDataDic:row];
            [cityData addObject:cityModel];
        }
        //刷新列表
        [_tableView reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return cityData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentify = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
        
    }
    TXCitiesModel *cityModel = cityData[indexPath.row];
    cell.textLabel.text = cityModel.city;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TXCitiesModel *cityModel = cityData[indexPath.row];
    TXAreaController *area = [[TXAreaController alloc] init];
    area.city_id = cityModel.city_id;
    area.city = cityModel.city;
    [self.navigationController pushViewController:area
                                         animated:YES];
}
@end
