//
//  TXLicensePlateListController.m
//  CARPeer

//  车牌列表控制器

//  Created by yezejiang on 15-1-12.
//  Copyright (c) 2015年 ayctey. All rights reserved.
//

#import "TXLicensePlateListController.h"
#import "LicensePlateListCell.h"
#import "TXModifyBusNumberController.h"
#import "TXAddNewBusController.h"
#import "TXDataService.h"
#import "TXBusMessageModel.h"
#import "TXBusTypeIDModel.h"
#import "Common.h"

#define TICK_IMAGE  [UIImage imageNamed:@"tick"]

@interface TXLicensePlateListController ()

@end

@implementation TXLicensePlateListController

- (id)init
{
    self = [super init];
    if (self) {
        canEdit = YES;
        self.title = @"车牌号码";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //初始化列表
    [self initTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //获取车辆信息
    [self getBusMessage];
}

#pragma mark - 加载数据
- (void)getBusMessage
{
    //获取所有车辆
    [TXDataService POST:getVehicle param:nil isCache:YES caChetime:24*60*60 completionBlock:^(id responseObject, NSError *error) {
        if (error == nil) {
            NSArray *data = [responseObject objectForKey:@"rows"];
            busArray = [NSMutableArray array];
            for (NSDictionary *row in data) {
                TXBusMessageModel *busModel = [[TXBusMessageModel alloc] initWithDataDic:row];
                [busArray addObject:busModel];
            }
            [_tableView reloadData];
        }
    }];
}

//初始化tableView
- (void)initTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 60;
    NSUserDefaults *defaults = [[NSUserDefaults standardUserDefaults] init];
    NSNumber *saveIndex = [defaults objectForKey:@"PlateNumber"];
    
    //数字对象转integer
    index = [saveIndex integerValue];
    [self.view addSubview:_tableView];
}

#pragma mark - 表视图协议
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return busArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentify = @"cell";
    LicensePlateListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (cell == nil) {
        cell = [[LicensePlateListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //cell.indicatorView.backgroundColor =  [UIColor redColor];
    cell.indicatorView.tag = indexPath.row;

    TXBusMessageModel *busModel = busArray[indexPath.row];
    [cell setLabelText:busModel];

    if (indexPath.row == index) {
        [cell.indicatorView setImage:TICK_IMAGE];
        index = indexPath.row;
        selectText = cell.busNumberLabel.text;;
        vehicle_id = [NSString stringWithFormat:@"%@",busModel.vehicle_id];
    }else
    {
        cell.indicatorView.image = nil;
    }
    
    return cell;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
////    return @"历史车牌号";
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TXBusMessageModel *busModel = busArray[indexPath.row];
    LicensePlateListCell *cell = (LicensePlateListCell *)[tableView cellForRowAtIndexPath:indexPath];
    //判断是否可编辑
    if (canEdit) {
        //可编辑状态
        TXModifyBusNumberController *modify = [[TXModifyBusNumberController alloc] init];
        modify.busModel = busModel;
        [self.navigationController pushViewController:modify animated:YES];
    }else
    {
        //不可编辑状态（选择状态）
        [cell.indicatorView setImage:TICK_IMAGE];
        selectText = cell.busNumberLabel.text;
        vehicle_id = [busModel.vehicle_id stringValue];
        
        //取消上一个Cell的打钩状态
        LicensePlateListCell *lastCell = (LicensePlateListCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:indexPath.section]];
        //如果两次点击的cell不一样，则修改选中的cell
        if (index != indexPath.row) {
            lastCell.indicatorView.image = nil;
            index = indexPath.row;
        }
        NSUserDefaults *defaults = [[NSUserDefaults standardUserDefaults] init];
        [defaults setValue:[NSNumber numberWithInteger:index] forKey:@"PlateNumber"];
        [self backSuperController];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    //添加新建车牌号button
    UIButton *label = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    label.frame = CGRectMake(10, 10, kScreenWidth-20, 30);
    label.backgroundColor = [UIColor lightGrayColor];
    [label setTitle:@"新建车牌号" forState:UIControlStateNormal];
    [label setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [label addTarget:self action:@selector(addNewBusMessage) forControlEvents:UIControlEventTouchUpInside];
        
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, kScreenWidth, 40);
    view.backgroundColor = kBackgroundColor;
    [view addSubview:label];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIButton *label = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    label.frame = CGRectMake(10, 10, kScreenWidth-20, 30);
    label.backgroundColor = [UIColor clearColor];
    [label setTitle:@"历史车牌号" forState:UIControlStateNormal];
    [label setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, kScreenWidth, 40);
    view.backgroundColor = kBackgroundColor;
    [view addSubview:label];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

//左滑删除
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (canEdit) {
        return UITableViewCellEditingStyleDelete;
    }else
        return UITableViewCellEditingStyleNone;
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

//删除车牌信息表某条数据
-(BOOL)deleteTimeTable:(NSIndexPath *)indexPath
{
    __block BOOL isSuccss;
    
    TXBusMessageModel *deleteModel = [busArray objectAtIndex:indexPath.row];
    NSDictionary *dic = @{@"vehicle_id":deleteModel.vehicle_id};
    [TXDataService POST:delDepartureTimetable param:dic isCache:NO caChetime:0 completionBlock:^(id responseObject, NSError *error) {
        if (error == nil) {
            isSuccss = YES;
            //删除数据源
            [busArray removeObjectAtIndex:indexPath.row];
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

//新增车牌号
- (void)addNewBusMessage
{
    TXAddNewBusController *addnew = [[TXAddNewBusController alloc] init];
    [self.navigationController pushViewController:addnew animated:YES];
}

- (void)setCanEdit:(BOOL)edit
{
    canEdit = edit;
}


//重写父类的返回方法
- (void)backSuperController
{
    if (!canEdit) {
        NSDictionary *info = @{@"vehicle_id":vehicle_id,@"text":selectText};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"busNumber" object:info userInfo:nil];
    }
    
    NSLog(@"setBackButton");
    [self.navigationController popViewControllerAnimated:YES];
}
@end
