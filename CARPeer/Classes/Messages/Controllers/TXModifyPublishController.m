//
//  TXModifyPublishController.m
//  CARPeer
//
//  Created by yezejiang on 15-2-6.
//  Copyright (c) 2015年 ayctey. All rights reserved.
//

#import "TXModifyPublishController.h"
#import "TXDepartureTimetableModel.h"
#import "TXPublishController.h"
#import "APIManage.h"
#import "TXDataService.h"
#import "Common.h"
#import "NSString+MD5.h"

@implementation TXModifyPublishController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"发布详情";
    
    //添加右button
    [self addRightBarButton];
    
    //设置textField的值
    [self setTextField];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    if ([indicatorView isAnimating]) {
        [indicatorView stopAnimating];
    }
}

// override设置textField的值
-(void)setTextField
{
    //出发日期
    NSString *departureDate =[_departureModel stringToDate:_departureModel.departure_time istime:NO];
    //出发时间
    NSString *departureTime = [_departureModel stringToDate:_departureModel.departure_time istime:YES];
    //到达日期
    NSString *arriveDate = [_departureModel stringToDate:_departureModel.arrive_time istime:NO];
    NSString *arriveTime = [_departureModel stringToDate:_departureModel.arrive_time istime:YES];
    
    atrribtes = @[departureDate,departureTime,arriveDate,arriveTime,_departureModel.begin_area,_departureModel.end_area,_departureModel.begin_area_detail,_departureModel.end_area_detail,[_departureModel.price stringValue],_departureModel.plate_number,_departureModel.remark];
    
    for (NSInteger i =11; i<22; i++) {
        [[self getFieldWithTag:i] setText:[atrribtes objectAtIndex:i-11]];
    }
}

//添加右button
-(void)addRightBarButton
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"重新发布" style:UIBarButtonItemStyleDone target:self action:@selector(rePublic)];
    item.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = item;
}

-(void)rePublic
{
    TXPublishController *publishController = [[TXPublishController alloc] init];
    publishController.buttonTitle = @"发  布";
    [publishController setTextField:_departureModel];
    [self.navigationController pushViewController:publishController animated:YES];
}

- (UITextField *)getFieldWithTag:(NSInteger)tag
{
    return (UITextField *)[self.view viewWithTag:tag];
}

//override method - (void)submitData
- (void)submitData
{
    //停止指示图
    if ([indicatorView isAnimating]) {
        [indicatorView stopAnimating];
    }
    else
    {
        [indicatorView startAnimating];
    }
    
    //出发日期
    NSMutableString *departureDate = [NSMutableString stringWithString:[self getFieldWithTag:11].text];
    
    //出发时间
    NSMutableString *departure_time = [NSMutableString stringWithString:departureDate];
    [departure_time appendFormat:@" %@:00",[self getFieldWithTag:12].text];
    
    if (![[_departureModel.departure_time substringToIndex:19] isEqualToString:departure_time]) {
        [self modifyDepartureTimeTable:1];
    }
    
    //到站日期
    NSMutableString *arriveDate = [NSMutableString stringWithString:[self getFieldWithTag:13].text];
    
    //到站时间
    NSMutableString *arrive_time = [NSMutableString stringWithString:arriveDate];
    [arrive_time appendFormat:@" %@:00",[self getFieldWithTag:14].text];
    
    if (![[_departureModel.arrive_time substringToIndex:19] isEqualToString:arrive_time]) {
        [self modifyDepartureTimeTable:3];
    }

    for (NSInteger i =15; i<22; i++) {
        //判断数据是否已经修改
        MyLog(@"%@,%@",[self getFieldWithTag:i].text,[atrribtes objectAtIndex:i-11]);
        BOOL isEaual = [[self getFieldWithTag:i].text isEqual:[atrribtes objectAtIndex:i-11]];
        if (!isEaual) {
            [self modifyDepartureTimeTable:i-11];
        }
    }
    
//    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 3ull*NSEC_PER_MSEC);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (ifShowBadAlertview>0) {
            [self badAlertviewShow];
        }
        else if (ifShowGoodAlertview>0)
        {
            [self goodAlertviewShow];
        }
    });
    
    if (ifShowBadAlertview>0) {
        [self badAlertviewShow];
    }
    else if (ifShowGoodAlertview>0)
    {
        [self goodAlertviewShow];
    }
}

//提交修改数据
-(void)modifyDepartureTimeTable:(NSInteger)fieldTag
{
    switch (fieldTag) {
//        case 0:[self modifyBeginTime];
//            
//               break;
        case 1:[self modifyBeginTime];
            
               break;
//        case 2:[self modifyEndTime];
//            
//               break;
        case 3:[self modifyEndTime];
            
               break;
        case 4:[self modifyDeparturePlace];
            
               break;
        case 5:[self modifyArrivePlace];
            
               break;
        case 6:[self modifyDepartureStation];
            
               break;
        case 7:[self modifyArriveStation];
            
               break;
        case 8:[self modifyPrice];
            
               break;
        case 9:[self modifyBusPlate];
            
               break;
        case 10:[self modifyRemark];
            
               break;
            
        default:
            break;
    }
}

//修改出发时间
-(void)modifyBeginTime
{
    //出发日期
    NSMutableString *departureDate = [NSMutableString stringWithString:[self getFieldWithTag:11].text];
    
    //出发时间
    NSMutableString *departure_time = [NSMutableString stringWithString:departureDate];
    [departure_time appendFormat:@" %@:00",[self getFieldWithTag:12].text];
    
    //参数
    NSDictionary *param = @{@"departure_Timetable_id":_departureModel.departure_Timetable_id,@"departure_time":departure_time};
    [TXDataService POST:updateTimetableDepartureTime param:param isCache:NO caChetime:0 completionBlock:^(id responseObject, NSError *error) {
       
        if (error == nil) {
            ifShowGoodAlertview++;
        }
        else
        {
            ifShowBadAlertview++;
        }
    }];
}

//修改出发时间
-(void)modifyEndTime
{
    
    //到站日期
    NSMutableString *arriveDate = [NSMutableString stringWithString:[self getFieldWithTag:13].text];
    
    //到站时间
    NSMutableString *arrive_time = [NSMutableString stringWithString:arriveDate];
    [arrive_time appendFormat:@" %@:00",[self getFieldWithTag:14].text];

    //参数
    NSDictionary *param = @{@"departure_Timetable_id":_departureModel.departure_Timetable_id,@"arrive_time":arrive_time};
    
    //提交修改数据到后台
    [TXDataService POST:updateTimetableArriveTime param:param isCache:NO caChetime:0 completionBlock:^(id responseObject, NSError *error) {
       
        if (error == nil) {
            ifShowGoodAlertview++;
        }
        else
        {
            ifShowBadAlertview++;
        }
    }];
}

//修改出发地
-(void)modifyDeparturePlace
{
    
    //参数
    NSDictionary *param = @{@"departure_Timetable_id":_departureModel.departure_Timetable_id,@"begin_area_id":begin_area_id};
    
    //提交修改数据到后台
    [TXDataService POST:updateTimetableBeginAreaID param:param isCache:NO caChetime:0 completionBlock:^(id responseObject, NSError *error) {
       
        if (error == nil) {
            ifShowGoodAlertview++;
        }
        else
        {
            ifShowBadAlertview++;
        }
    }];
}

//修改目的地
-(void)modifyArrivePlace
{
    //参数
    NSDictionary *param = @{@"departure_Timetable_id":_departureModel.departure_Timetable_id,@"end_area_id":end_area_id};
    
    //提交修改数据到后台
    [TXDataService POST:updateTimetableEndAreaID param:param isCache:NO caChetime:0 completionBlock:^(id responseObject, NSError *error) {
      
        if (error == nil) {
            ifShowGoodAlertview++;
        }
        else
        {
            ifShowBadAlertview++;
        }
    }];
}

//修改出发车站
-(void)modifyDepartureStation
{
    //参数
    NSDictionary *param = @{@"departure_Timetable_id":_departureModel.departure_Timetable_id,@"begin_area":[self getFieldWithTag:17].text};

    //提交修改数据到后台
    [TXDataService POST:updateTimetableBeginArea param:param isCache:NO caChetime:0 completionBlock:^(id responseObject, NSError *error) {
       
        if (error == nil) {
            ifShowGoodAlertview++;
        }
        else
        {
            ifShowBadAlertview++;
        }
    }];

}

//修改到达车站
-(void)modifyArriveStation
{
    //参数
    NSDictionary *param = @{@"departure_Timetable_id":_departureModel.departure_Timetable_id,@"end_area":[self getFieldWithTag:18].text};
    
    //提交修改数据到后台
    [TXDataService POST:updateTimetableEndArea param:param isCache:NO caChetime:0 completionBlock:^(id responseObject, NSError *error) {
        if (error == nil) {
            ifShowGoodAlertview++;
        }
        else
        {
            ifShowBadAlertview++;
        }
    }];
}

//修改票价
-(void)modifyPrice
{
    //参数
    NSDictionary *param = @{@"departure_Timetable_id":_departureModel.departure_Timetable_id,@"price":[self getFieldWithTag:19].text};
    
    //提交修改数据到后台
    [TXDataService POST:updateTimetablePrice param:param isCache:NO caChetime:0 completionBlock:^(id responseObject, NSError *error) {
       
        if (error == nil) {
            ifShowGoodAlertview++;
        }
        else
        {
            ifShowBadAlertview++;
        }
    }];
}

//修改车牌号
-(void)modifyBusPlate
{
    //参数
    NSDictionary *param = @{@"departure_Timetable_id":_departureModel.departure_Timetable_id,@"vehicle_id":vehicle_id};
    
    //提交修改数据到后台
    [TXDataService POST:updateTimetableVehicle param:param isCache:NO caChetime:0 completionBlock:^(id responseObject, NSError *error) {
       
        if (error == nil) {
            ifShowGoodAlertview++;
        }
        else
        {
            ifShowBadAlertview++;
        }
    }];

}

//修改备注
-(void)modifyRemark
{
    //参数
    NSDictionary *param = @{@"departure_Timetable_id":_departureModel.departure_Timetable_id,@"remark":[self getFieldWithTag:21].text};
    
    //提交修改数据到后台
    [TXDataService POST:updateTimetableRemark param:param isCache:NO caChetime:0 completionBlock:^(id responseObject, NSError *error) {
       
        if (error == nil) {
            ifShowGoodAlertview++;
        }
        else
        {
            ifShowBadAlertview++;
        }
    }];
}

-(void)goodAlertviewShow
{
    //停止指示图
    if ([indicatorView isAnimating]) {
        [indicatorView stopAnimating];
    }
    //获取缓存key
    NSString *key = [[EGOCache globalCache] getkey:getDepartureTimetable pramaters:nil];
    key = [key MD5Hash];
    [[EGOCache globalCache] removeCacheForKey:key];
    UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"修改成功！" delegate:self cancelButtonTitle:@"好" otherButtonTitles: nil];
    [alerView show];
}

-(void)badAlertviewShow
{
    //停止指示图
    if ([indicatorView isAnimating]) {
        [indicatorView stopAnimating];
    }
    UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"修改不成功！请稍后再试" delegate:self cancelButtonTitle:@"好" otherButtonTitles: nil];
    [alerView show];
}

@end
