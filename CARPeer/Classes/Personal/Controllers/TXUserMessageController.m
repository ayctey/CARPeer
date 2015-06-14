//
//  TXUserMessageController.m
//  CARPeer

//乘务员信息控制器

//  Created by yezejiang on 15-1-12.
//  Copyright (c) 2015年 ayctey. All rights reserved.
//

#import "TXUserMessageController.h"
#import "TXMessageAuthenticationController.h"
#import "TXMoodifyUserNameController.h"
#import "TXModifyIntroductionController.h"
#import "TXModifyPhoneNumber.h"
#import "TXAddNewBusController.h"
#import "TXDataService.h"
#import "Common.h"
@interface TXUserMessageController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *titleArray;
    NSArray *dataArray;
}
@end

@implementation TXUserMessageController
@synthesize isPrefectData;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //是资料完善页还是用户资料页
    if (isPrefectData) {
        self.title = @"请完善个人资料";
        UIBarButtonItem *rightIem = [[UIBarButtonItem alloc] initWithTitle:@"下一步"style:UIBarButtonItemStylePlain target:self action:@selector(newPlate)];
        self.navigationItem.rightBarButtonItem = rightIem;
    }else
    {
    self.title = @"个人资料";
    }
    
    self.view.backgroundColor = kBackgroundColor;
    titleArray = @[@"账号:",@"姓名:",@"性别:",@"绑定电话:",@"电话2:",@"简介:",@"所属车队:"];
    
    [self initTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [_tableView reloadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(modifyUserName:) name:@"userName" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(modifyTel:) name:@"tel" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(modifyIntro:) name:@"intro" object:nil];
}

#pragma mark - 通知
- (void)modifyUserName:(NSNotification *)notification
{
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    cell.detailTextLabel.text = notification.object;
}

- (void)modifyTel:(NSNotification *)notification
{
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    cell.detailTextLabel.text = notification.object;
}

- (void)modifyIntro:(NSNotification *)notification
{
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
    cell.detailTextLabel.text = notification.object;
}

#pragma mark - 加载数据
- (void)submitSeXData:(NSString *)sexString
{
    //修改性别
    NSDictionary *sexDic = @{@"sex":sexString};
    [TXDataService POST:updateSex param:sexDic isCache:NO caChetime:0 completionBlock:^(id responseObject, NSError *error) {
        NSLog(@"是否完成：%@",[responseObject objectForKey:@"success"]);
        if ([responseObject objectForKey:@"success"]) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
            cell.detailTextLabel.text = sexString;
            [defaults setValue:sexString forKey:@"sex"];
            [_tableView reloadData];
        }
    }];
}

- (void)getUserDefaultData:(UITableViewCell *)cell indexPath:(NSIndexPath *)indepath
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *key = @[@"account",@"trainman_Name",@"sex",@"tel",@"nil",@"intro",@"motorcade_Name"];
    cell.detailTextLabel.text = [defaults objectForKey:key[indepath.row]];
}

- (UITableViewCell *)cellForRow:(NSInteger)row
{
    return [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
}

//初始化列表
- (void)initTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, titleArray.count*53.2) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.bounces = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.separatorColor = [UIColor grayColor];
    [self.view addSubview:_tableView];
}

#pragma mark - 表视图协议
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentify = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentify];
    }
    if (indexPath.row !=0 ) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.backgroundColor = kBackgroundColor;
    cell.textLabel.text = titleArray[indexPath.row];
    [self getUserDefaultData:cell indexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    switch (indexPath.row) {
        case 1:{
            //修改用户名
            TXMoodifyUserNameController *modifyUserName = [[TXMoodifyUserNameController alloc] init];
            [modifyUserName getName:cell.detailTextLabel.text];
            [self.navigationController pushViewController:modifyUserName animated:YES];
        }break;
        case 5:{
            //修改简介
            TXModifyIntroductionController *introduction = [[TXModifyIntroductionController alloc] init];
            [introduction getIntroduction:cell.detailTextLabel.text];
            [self.navigationController pushViewController:introduction animated:YES];
        }break;
        case 3:
        {
            //判断电话号码是否为空
           NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *phoneNumber = [defaults objectForKey:@"tel"];
            if (phoneNumber) {
                TXModifyPhoneNumber *modifyVC = [[TXModifyPhoneNumber alloc] init];
                [self.navigationController pushViewController:modifyVC animated:YES];
            }
        }
            break;
        case 4:
            [self pushToAuthen:tableView indexPath:indexPath];
            break;
        case 2:
            //修改性别
            [self modifySex];
            break;
            
        default:
            break;
    }
}

- (void)modifySex
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"性别" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"男" otherButtonTitles:@"女", nil];
    [actionSheet showInView:self.view];
}

//push到安全验证界面
- (void)pushToAuthen:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    TXMessageAuthenticationController *authentication = [[TXMessageAuthenticationController alloc] init];
    [authentication setPhoneText:cell.detailTextLabel.text];
    [authentication pushTo:VCChangePhoneNumberController];
    [self.navigationController pushViewController:authentication animated:YES];
}

//actionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
        if (buttonIndex == 0) {
        [self submitSeXData:@"男"];
        
    }else{
        [self submitSeXData:@"女"];
    }
}

//完善车牌号码
-(void)newPlate
{
    TXAddNewBusController *addNewController = [[TXAddNewBusController alloc] init];
    addNewController.isPrefect = YES;
    [self.navigationController pushViewController:addNewController animated:YES];
}

@end
