//
//  TXMessagesController.m
//  CARPeer
//
//  Created by yezejiang on 15-1-4.
//  Copyright (c) 2015年 ayctey. All rights reserved.
//

#import "TXMessagesController.h"
#import "TXPublishController.h"
#import "RCChatViewController.h"
#import "TXModifyPublishController.h"
#import "TXDepartureTimetableModel.h"
#import "MessagesCell.h"
#include "RCIM.h"
#import "Common.h"
#import "Reachability.h"
#import "TXDataService.h"
#import "NSString+MD5.h"

@interface TXMessagesController ()
{
    UIButton *button;
    NSMutableArray *dataArray;
    UIActivityIndicatorView *indicatorView;//活动指示图
}

@end

@implementation TXMessagesController

- (void)viewDidLoad {
    [super viewDidLoad];
    //去除返回button
    addBackItem = NO;
    self.view.backgroundColor = kBackgroundColor;
    //
    [self addBarButton];
    
    //实例列表
    [self initTableView];
    //添加活动指示图
    [self indicatorView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //启动或停止活动指示图
    if ([indicatorView isAnimating]) {
        [indicatorView stopAnimating];
    }
    else
    {
        [indicatorView startAnimating];
    }
    //加载数据
    [self getData];
    
}

- (void)addbackButton{}

//活动指示图
-(void)indicatorView
{
    indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [indicatorView setCenter:CGPointMake(kScreenWidth/2, kScreenHeight/2)];
    [indicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    indicatorView.backgroundColor = [UIColor blackColor];
    indicatorView.alpha = 0.5;
    //设置背景为圆角矩形
    indicatorView.layer.cornerRadius = 6;
    [self.view addSubview:indicatorView];
}

#pragma mark - 加载数据
- (void)getData
{
    
    //获取缓存key
    NSString *key = [[EGOCache globalCache] getkey:getDepartureTimetable pramaters:nil];
    key = [key MD5Hash];
    
    //检测网络
    Reachability *baidureachable = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    NSLog(@"网络状况：%d",baidureachable.isReachable);
    if (!baidureachable.isReachable) {
        //停止活动指示图
        if ([indicatorView isAnimating]) {
            [indicatorView stopAnimating];
        }
        BOOL iscache =[[EGOCache globalCache] hasCacheForKey:key];
        if (iscache) {
            NSData *data = [[EGOCache globalCache] dataForKey:key];
            NSDictionary *dicArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            
            NSArray *myDataArray = [dicArray objectForKey:@"rows"];
            dataArray = [NSMutableArray array];
            //获取数据
            for (NSDictionary *row in myDataArray) {
                TXDepartureTimetableModel *departureTimetableModel = [[TXDepartureTimetableModel alloc] initWithDataDic:row];
                [dataArray addObject:departureTimetableModel];
            }
            [_tableView reloadData];
        }
    }else
    {
        [TXDataService POST:getDepartureTimetable param:nil isCache:YES caChetime:24*60*60 completionBlock:^(id responseObject, NSError *error) {
            //停止活动指示图
            if ([indicatorView isAnimating]) {
                [indicatorView stopAnimating];
            }
            if (error == nil) {
                NSArray *data = [responseObject objectForKey:@"rows"];
                dataArray = [NSMutableArray array];
                for (NSDictionary *row in data) {
                    TXDepartureTimetableModel *model = [[TXDepartureTimetableModel alloc] initWithDataDic:row];
                    [dataArray addObject:model];
                }
                [_tableView reloadData];
            }
        }];
    }
}

#pragma mark - 添加视图
- (void)addBarButton
{
    UIButton *publishBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [publishBtn setImage:[UIImage imageNamed:@"plusSign@3x"] forState:UIControlStateNormal];
    [publishBtn addTarget:self action:@selector(publishClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [searchBtn setImage:[UIImage imageNamed:@"放大镜@3x"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(publishClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *publishItem = [[UIBarButtonItem alloc] initWithCustomView:publishBtn];
    NSArray *rightItems = @[publishItem];
    self.navigationItem.rightBarButtonItems = rightItems;
}

- (void)initTableView
{
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = kBackgroundColor;
    _tableView.rowHeight = 80;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

#pragma mark - 发布
- (void)publishClick
{
    TXPublishController *publish = [[TXPublishController alloc] init];
    publish.buttonTitle = @"发  布";
    publish.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:publish animated:YES];
}

#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentify = @"cell";
    MessagesCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (cell == nil) {
        cell = [[MessagesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
    }
    cell.backgroundColor = kBackgroundColor;
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    //将模型传给cell
    cell.departureModel = dataArray[indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TXModifyPublishController *publishVC = [[TXModifyPublishController alloc] init];
    publishVC.buttonTitle = @"保 存 修 改";
    publishVC.hidesBottomBarWhenPushed = YES;
    publishVC.departureModel = dataArray[indexPath.row];
    [self.navigationController pushViewController:publishVC animated:YES];
}

//左滑删除
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

//修改删除按钮文字
- (NSString*)tableView:(UITableView*)tableView
titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath*)indexpath {
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:
(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //删除后台数据库
        [self deleteTimeTable:indexPath];
    }
}

//删除时刻表某条数据
-(BOOL)deleteTimeTable:(NSIndexPath *)indexPath
{
    __block BOOL isSuccss;
    
    TXDepartureTimetableModel *deleteModel = [dataArray objectAtIndex:indexPath.row];
   
    NSDictionary *dic = @{@"departureTimetalbe_id":deleteModel.departure_Timetable_id};
    [TXDataService POST:delDepartureTimetable param:dic isCache:NO caChetime:0 completionBlock:^(id responseObject, NSError *error) {
        if (error == nil) {
            isSuccss = YES;
            //删除数据源
            [dataArray removeObjectAtIndex:indexPath.row];
            [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationAutomatic];
        }else
        {
          isSuccss = NO;
            UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络错误，请稍后再试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alerView show];
        }
    }];
    return isSuccss;
}

@end
