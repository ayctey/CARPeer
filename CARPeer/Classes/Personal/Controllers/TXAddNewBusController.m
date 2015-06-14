//
//  TXAddNewBusController.m
//  CARPeer
//
//  Created by yezejiang on 15-2-4.
//  Copyright (c) 2015年 ayctey. All rights reserved.
//

#import "TXAddNewBusController.h"
#import "TXBusTypeViewController.h"
#import "TXDataService.h"
#import "Common.h"
#import "NSString+MD5.h"

@implementation TXAddNewBusController
@synthesize isPrefect;

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (isPrefect) {
        self.title = @"完善汽车信息";
    }else
    {
    self.title = @"新增车牌号";
    }
}

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
    
    //活动指示器添加到window上面
    [[[UIApplication sharedApplication].delegate window] addSubview:indicatorView];
}

- (void)addNewBusMessage
{
    if ([indicatorView isAnimating]) {
        [indicatorView stopAnimating];
    }
    else
    {
        [indicatorView startAnimating];
    }
    
    UITextField *textField1 = (UITextField *)[self.view viewWithTag:10];
    UITextField *textField3 = (UITextField *)[self.view viewWithTag:12];
    //字符转NSNumber
    NSNumberFormatter *sitesNumber = [[NSNumberFormatter alloc] init];
     NSNumber *newSiteNumber = [sitesNumber numberFromString:textField3.text];
    NSDictionary *param = @{@"vehicle_type_id":busTypeIDModel.vehicle_type_id,@"plate_number":textField1.text,@"seats":newSiteNumber};
    [TXDataService POST:addVehicle param:param isCache:NO caChetime:0  completionBlock:^(id responseObject, NSError *error) {
        
        //停止活动指示
        if([indicatorView isAnimating])
        {
            [indicatorView stopAnimating];
        }
        
        if (error == nil) {
            //如果是第一次完善
            if(isPrefect)
            {
                id delegate = [[UIApplication sharedApplication] delegate];
                if ([delegate respondsToSelector:@selector(pushMaincomtroller)]) {
                    [delegate pushMaincomtroller];
                }
            }else
            {
                [self alertviewShow];
            }
        }else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"新增不成功，请稍后再试！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }
    }];
}

- (void)modifyClick
{
    [self addNewBusMessage];
}

-(void)alertviewShow
{
    //获取缓存key
    NSString *key = [[EGOCache globalCache] getkey:getVehicle pramaters:nil];
    key = [key MD5Hash];
    [[EGOCache globalCache] removeCacheForKey:key];
    UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"修改成功！" delegate:self cancelButtonTitle:@"好" otherButtonTitles: nil];
    [alerView show];
}

#pragma mark - UIalertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (isPrefect&&buttonIndex==0) {
        id delegate = [[UIApplication sharedApplication] delegate];
        if ([delegate respondsToSelector:@selector(pushMaincomtroller)]) {
            [delegate pushMaincomtroller];
        }
    }
    if (buttonIndex==0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
