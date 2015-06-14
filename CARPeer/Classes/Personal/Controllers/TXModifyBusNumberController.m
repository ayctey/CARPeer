//
//  TXModifyBusNumberController.m
//  CARPeer

//

//  Created by yezejiang on 15-1-13.
//  Copyright (c) 2015年 ayctey. All rights reserved.
//

#import "TXModifyBusNumberController.h"
#import "TXDataService.h"
#import "Common.h"
#import "NSString+MD5.h"

@interface TXModifyBusNumberController ()


@end

@implementation TXModifyBusNumberController
@synthesize busModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改车牌号";
    self.view.backgroundColor = [UIColor whiteColor];
    [self initViews];
    [self indicatorView];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    if ([indicatorView isAnimating]) {
        [indicatorView stopAnimating];
    }
}

#pragma mark - 修改车辆信息

//修改车牌号
- (void)modifyBusNumber:(NSString *)bus_number
{
    
    NSDictionary *param = @{@"vehicle_id":busModel.vehicle_id,@"plateNum":bus_number};
    [TXDataService POST:updatePlateNum param:param isCache:NO caChetime:0 completionBlock:^(id responseObject, NSError *error) {
        
        //停止活动指示器
        if ([indicatorView isAnimating]) {
            [indicatorView stopAnimating];
        }
        if (error == nil) {
            [self alertviewShow];
        }
        else
        {
            UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"修改不成功，请稍后再试！" delegate:self cancelButtonTitle:@"好" otherButtonTitles: nil];
            [alerView show];
        }
    }];
}

//修改车辆型号
-(void)modifyBusType:(NSNumber *)myBusType
{
    NSDictionary *param = @{@"vehicle_id":busModel.vehicle_id,@"vehicle_type_id":myBusType};
    MyLog(@"字典：%@",param);
    [TXDataService POST:updateVehicleType param:param isCache:NO caChetime:0  completionBlock:^(id responseObject, NSError *error) {
        
        //停止活动指示器
        if ([indicatorView isAnimating]) {
            [indicatorView stopAnimating];
        }
        
        if (error == nil) {
            [self alertviewShow];
        }
        else
        {
            UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"修改不成功，请稍后再试！" delegate:self cancelButtonTitle:@"好" otherButtonTitles: nil];
            [alerView show];
        }
    }];
}

//修改车辆座位数
-(void)modifyBusSiteNumber:(NSNumber *)busSiteNumber
{
    MyLog(@"busSitesNumber:%@",busSiteNumber);
    NSDictionary *param = @{@"vehicle_id":busModel.vehicle_id,@"seats":busSiteNumber};
    MyLog(@"字典：%@",param);
    [TXDataService POST:updateSeats param:param isCache:NO caChetime:0 completionBlock:^(id responseObject, NSError *error) {
        //停止活动指示器
        if ([indicatorView isAnimating]) {
            [indicatorView stopAnimating];
        }
        if (error == nil) {
            [self alertviewShow];
        }
        else
        {
            UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"修改不成功，请稍后再试！" delegate:self cancelButtonTitle:@"好" otherButtonTitles: nil];
            [alerView show];
        }
    }];
}

#pragma mark - 添加视图
- (void)initViews
{
    UIButton *addImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addImageBtn setFrame:CGRectMake((kScreenWidth-150)/2, kNavigationH+5, 150, 150)];
    addImageBtn.backgroundColor = [UIColor redColor];
    [addImageBtn addTarget:self action:@selector(addImageClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addImageBtn];
    
    NSArray *label_title = @[@"车牌号:",@"车辆类型:",@"座位数:"];
    NSArray *textField_placeholder = @[@"请输入车牌号",@"请输入车辆类型",@"请输入座位数"];
    for (int i = 0; i < label_title.count; i++) {
        UIView *busView = [[UIView alloc] init];
        busView.backgroundColor = kBackgroundColor;
        busView.userInteractionEnabled = YES;
        busView.frame = CGRectMake(5, addImageBtn.frame.size.height+10+kNavigationH+45*i, kScreenWidth-10, 40);
        [self.view addSubview:busView];
        
        UILabel *busLabel = [[UILabel alloc] init];
        busLabel.text = label_title[i];
        busLabel.backgroundColor = kBackgroundColor;
        busLabel.frame = CGRectMake(5, 5, 80, 30);
        [busView addSubview:busLabel];
        
        UITextField *busField = [[UITextField alloc] init];
        if (i!=0) {
            busField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        }
        busField.frame = CGRectMake(80, 5, kScreenWidth-100, 30);
        busField.placeholder = textField_placeholder[i];
        busField.tag = 10+i;
         busField.delegate = self;
        [busView addSubview:busField];
        
        if (busField.tag == 10) {
            busField.text = busModel.plate_number;
        }else if(busField.tag == 11)
        {
            busField.text = busModel.vehicle_type;
        }
        else if (busField.tag == 12)
        {
            busField.text = [busModel.seats stringValue];
        }
    }
    
    //保存修改按钮
    UIButton *modeifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [modeifyBtn setFrame:CGRectMake(5, 370, kScreenWidth-10, kNavigationH-20)];
    modeifyBtn.backgroundColor = [UIColor redColor];
    [modeifyBtn setTitle:@"保   存" forState:UIControlStateNormal];
    [modeifyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [modeifyBtn addTarget:self action:@selector(modifyClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:modeifyBtn];
    
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

#pragma mark - 保存修改
- (void)modifyClick
{
    //启动或停止活动指示器
    if([indicatorView isAnimating])
    {
        [indicatorView stopAnimating];
    }
    else{
        [indicatorView startAnimating];
    }
    
    [self.view endEditing:YES];
    UITextField *numberField = (UITextField *)[self.view viewWithTag:10];
    UITextField *typeField = (UITextField *)[self.view viewWithTag:11];
    UITextField *siteNumberField = (UITextField *)[self.view viewWithTag:12];
    if ((![numberField.text isEqualToString:busModel.plate_number])&([numberField.text length]!=0)) {
        //修改车牌号
        [self modifyBusNumber:numberField.text];
    }
    if ((![typeField.text isEqualToString:busModel.vehicle_type])&([typeField.text length]!=0)) {
        //修改车辆类型
        [self modifyBusType:busTypeIDModel.vehicle_type_id];
    }
    
    //字符转NSNumber
    NSString *sitesNumberStr;
    NSNumberFormatter *sitesNumber = [[NSNumberFormatter alloc] init];
    sitesNumberStr=[sitesNumber stringFromNumber:busModel.seats];
    if ((![siteNumberField.text isEqualToString:sitesNumberStr])&([siteNumberField.text length]!=0)) {
        //NSNumber转NSString
        NSNumber *newSiteNumber = [sitesNumber numberFromString:siteNumberField.text];
        //修改座位数
        [self modifyBusSiteNumber:newSiteNumber];
    }
}

- (void)addImageClick:(UIButton *)button
{
    
}

#pragma mark - touch事件
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - 获取需要修改的车辆的信息
- (void)setBusNumber:(NSString *)number type:(NSString *)type busID:(NSNumber *)busId row:(NSInteger)row mySiteNumber:(NSNumber *)mySiteNumber
{
    index = row;
}

//alertViewShow
-(void)alertviewShow
{
    //获取缓存key
    NSString *key = [[EGOCache globalCache] getkey:getVehicle pramaters:nil];
    key = [key MD5Hash];
    [[EGOCache globalCache] removeCacheForKey:key];
    UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"修改成功！" delegate:self cancelButtonTitle:@"好" otherButtonTitles: nil];
    [alerView show];
}

#pragma mark - UIAlertViewDelegation
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //返回上一个控制器
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - TXBusTypeModelDelgate
-(void)setBusType:(TXBusTypeIDModel *)BusTypeIDModel
{
    busTypeIDModel = BusTypeIDModel;
    UITextField *textField = [self getFieldWithTag:11];
    textField.text = busTypeIDModel.name;
    
}

- (UITextField *)getFieldWithTag:(NSInteger)tag
{
    return (UITextField *)[self.view viewWithTag:tag];
}

#pragma mark - TextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == 11) {
        TXBusTypeViewController *TXBusTypeContrller = [[TXBusTypeViewController alloc] init];
        TXBusTypeContrller.delegate = self;
        [self presentViewController:TXBusTypeContrller animated:YES completion:nil];
    }
    else
    {
        //注册通知
        if (iPhone4||iPhone5) {
            [self regNotification];
        }
    }
    return YES;
}

#pragma mark - reg & unreg notification

- (void)regNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)unregNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

#pragma mark - notification handler

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect beginKeyboardRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endKeyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat yOffset = (endKeyboardRect.origin.y - beginKeyboardRect.origin.y)/2;
    
    CGRect inputFieldRect = self.view.frame;
    inputFieldRect.origin.y += yOffset;
    [UIView animateWithDuration:duration animations:^{
        self.view.frame = inputFieldRect;
    }];
}

#pragma mark - UITextField delegate


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    //注册通知
    [self unregNotification];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    BOOL isresign = [textField resignFirstResponder];
    [self unregNotification];
    return isresign;
    
}

@end
