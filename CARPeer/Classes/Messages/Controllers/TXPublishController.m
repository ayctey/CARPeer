//
//  TXPublishController.m
//  CARPeer
//
//  Created by yezejiang on 15-1-7.
//  Copyright (c) 2015年 ayctey. All rights reserved.
//

#import "TXPublishController.h"
#import "HZAreaPickerView.h"
#import "TXDatePickerView.h"
#import "TXLicensePlateListController.h"
#import "TXDepartureTimetableModel.h"
#import "TXNoteController.h"
#import "Common.h"
#import "TXDataService.h"
#import "AppDelegate.h"
#import "TXProvinceController.h"
#import "TXCitiesController.h"
#import "TXAreaController.h"
#import "NSString+MD5.h"

@interface TXPublishController()

@property (strong, nonatomic) NSString *areaValue, *cityValue;
@property (strong, nonatomic) HZAreaPickerView *locatePicker;

@end

@implementation TXPublishController
@synthesize buttonTitle;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBackgroundColor;
    self.title = @"发布中心";
    
    itemsArr = @[@"发车日期:",@"出发时间:",@"到站日期:",@"预计到达时间:",@"出发地:",@"目的地:",@"出发车站:",@"目的地车站:",@"票 价:",@"车牌号:",@"备注:"];
    
    [self initViews];
    [self indicatorView];
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //停止指示图
    if ([indicatorView isAnimating]) {
        [indicatorView stopAnimating];
    }
    //接收通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getBusNmuber:) name:@"busNumber" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCityAndArea:) name:@"cityMessage" object:nil];
    
}

#pragma mark - 接收修改选中车牌号的通知
- (void)getBusNmuber:(NSNotification *)notifition
{
    //获取车牌号和车牌id
    NSDictionary *info = notifition.object;
    vehicle_id = [info objectForKey:@"vehicle_id"];
    NSString *text = [info objectForKey:@"text"];
    UITextField *busNumberField = (UITextField *)[self.view viewWithTag:20];
    busNumberField.text = text;
}

- (void)getCityAndArea:(NSNotification *)notifition
{
    //获取区域，区域id和城市名
    NSDictionary *info = notifition.object;
    NSString *area_id = [info objectForKey:@"area_id"];
    NSString *city = [info objectForKey:@"city"];
    NSString *area = [info objectForKey:@"area"];
    NSMutableString *text = [NSMutableString stringWithString:city];
    [text appendFormat:@" %@",[info objectForKey:@"area"]];
    
    NSLog(@"area_index:%ld",(long)area_index);
    UITextField *areaField = (UITextField *)[self.view viewWithTag:area_index];
    areaField.text = nil;
    NSLog(@"%@",areaField.text);
    areaField.text = text;
    
    if (area_index == 15) {
        begin_area_id = area_id;
        begin_area = area;
    }else
    {
        end_area_id = area_id;
        end_area = area;
    }
}

#pragma mark - 提交数据
- (void)submitData
{
    //itemsArr = @[@"发车日期:",@"出发时间:",@"预计到达时间:",@"出发地:",@"目的地:",@"16出发车站:",@"目的地车站:",@"票 价:",@"19车牌号:",@"电话1:",@"电话2:",@"22备注:",@"所属公司:"];
    
    //上传发布信息
    //1.将时间格式转为yyyy-MM-dd HH:mm:ss
    
    //停止和启动指示图
    if ([indicatorView isAnimating]) {
        [indicatorView stopAnimating];
    }else{
        [indicatorView startAnimating];
    }
    
    //数据是否完整
    BOOL iscomplete = YES;
    
    for (int i= 11; i<22; i++) {
        //判读输入值是否为空
        UITextField *textField = [self getFieldWithTag:i];
        if ([textField.text length] == 0) {
            UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请完善数据再发布！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alerView show];
            iscomplete = NO;
            break;
        }
    }
    
    if (iscomplete) {
        //出发日期
        NSMutableString *departureDate = [NSMutableString stringWithString:[self getFieldWithTag:11].text];
        
        //出发时间
        NSMutableString *departure_time = [NSMutableString stringWithString:departureDate];
        [departure_time appendFormat:@" %@:00",[self getFieldWithTag:12].text];
        
        //出发日期
        NSMutableString *arriveDate = [NSMutableString stringWithString:[self getFieldWithTag:13].text];
        //到站时间
        NSMutableString *arrive_time = [NSMutableString stringWithString:arriveDate];
        [arrive_time appendFormat:@" %@:00",[self getFieldWithTag:14].text];
        
        MyLog(@"出发时间：%@,到达时间：%@",departure_time,arrive_time);
        //2.设置请求参数
        NSDictionary *params = @{@"vehicle_id":vehicle_id,
                                 @"begin_area_id":begin_area_id,
                                 @"begin_area":[self getFieldWithTag:17].text,
                                 @"end_area_id":end_area_id,
                                 @"end_area":[self getFieldWithTag:18].text,
                                 @"price":[self getFieldWithTag:19].text,
                                 @"departure_time":departure_time,
                                 @"arrive_time":arrive_time,
                                 @"remark":[self getFieldWithTag:21].text};
        //3.发送请求
        [TXDataService POST:addDepartureTimetable param:params isCache:NO caChetime:0 completionBlock:^(id responseObject, NSError *error) {
            //停止指示图
            if ([indicatorView isAnimating]) {
                [indicatorView stopAnimating];
            }
            if (error == nil) {
                //获取缓存key
                NSString *key = [[EGOCache globalCache] getkey:getDepartureTimetable pramaters:nil];
                key = [key MD5Hash];
                //清空缓存
                [[EGOCache globalCache] removeCacheForKey:key];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发布成功！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
            }
        }];
    }
   }

#pragma mark - 其他方法
-(void)setAreaValue:(NSString *)areaValue
{
    if (![_areaValue isEqualToString:areaValue]) {
        _areaValue = areaValue;
        UITextField *textField = (UITextField *)[self.view viewWithTag:textFieldTag];
        textField.text = areaValue;
    }
}

- (UITextField *)getFieldWithTag:(NSInteger)tag
{
    return (UITextField *)[self.view viewWithTag:tag];
}

//打开本地相册库
- (void)openLocalPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:^{
        
    }];
}

- (void)pickerWithDate:(NSString *)dateString
{
    UITextField *Field = (UITextField *)[self.view viewWithTag:textFieldTag];
    Field.text = dateString;
}

#pragma mark - 添加视图
- (void)initViews
{
    //添加scrollView
    UITapGestureRecognizer *rec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    scrollView = [[UIScrollView alloc] init];
    scrollView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight+400);
//    scrollView.bounces = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.backgroundColor = kBackgroundColor;
    [scrollView addGestureRecognizer:rec];
    self.view = scrollView;
    
    int i = 1;
    for (NSString *itemString in itemsArr) {
        UIView *bgView = [[UIView alloc] init];
        bgView.frame = CGRectMake(0, 1*i+(i-1)*50, kScreenWidth, 50);
        bgView.backgroundColor = [UIColor whiteColor];
        
        UILabel *item = [[UILabel alloc] init];
        item.text = itemString;
        item.font = [UIFont systemFontOfSize:16.0f];
        item.frame = CGRectMake(20, 5, 20*[itemString length], 40);
        [bgView addSubview:item];
        [self.view addSubview:bgView];
        
        float length = 20*[itemString length]+20;
        UITextField *textItem = [[UITextField alloc] init];
        textItem.frame = CGRectMake(length, 5, kScreenWidth-length-20, 40);
        textItem.tag = i+10;
        textItem.delegate = self;
        textItem.borderStyle = UITextBorderStyleNone;
        [bgView addSubview:textItem];
        if (i == itemsArr.count) {
            bgView_frame = bgView.frame;
        }
        i++;
    }
    for (int i = 0; i < 3; i++) {
        UIButton *imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        imageBtn.frame = CGRectMake((kScreenWidth-95*3)/2+95*i, bgView_frame.origin.y+40+30, 80, 80);
        [imageBtn setImage:[UIImage imageNamed:@"addBusImage"] forState:UIControlStateNormal];
        imageBtn.tag = i+101;
        [imageBtn addTarget:self action:@selector(addImage:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:imageBtn];
    }
    
    //发布按钮
    [self addButton];
}

//发布按钮
-(void)addButton
{
    //发布按钮
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake((kScreenWidth-200)/2, bgView_frame.origin.y+170, 200, 35);
    [submitBtn setTitle:buttonTitle  forState:UIControlStateNormal];
    submitBtn.backgroundColor = [UIColor redColor];
    [submitBtn addTarget:self action:@selector(submitData) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];
}


#pragma mark - 添加事件
- (void)addImage:(UIButton *)sender
{
    buttonTag = sender.tag;
    [self openLocalPhoto];
}

- (void)tapGesture:(UITapGestureRecognizer *)rec
{
    [self.view endEditing:YES];
}

#pragma mark - PickViewController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    UIButton *button = (UIButton *)[self.view viewWithTag:buttonTag];
    [button setImage:image forState:UIControlStateNormal];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//#pragma mark - HZAreaPicker delegate
//-(void)pickerDidChaneStatus:(HZAreaPickerView *)picker
//{
//    
//    self.areaValue = [NSString stringWithFormat:@"%@ %@ %@", picker.locate.state, picker.locate.city, picker.locate.district];
//}

-(void)cancelLocatePicker
{
    [self.locatePicker cancelPicker];
    self.locatePicker.delegate = nil;
    self.locatePicker = nil;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self cancelLocatePicker];
}

#pragma mark - alertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TextField delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //设置不能响应点击事件
    textField.enabled = NO;
    [self performSelector:@selector(textFieldCanEndite:) withObject:textField afterDelay:1.0];
    
    textFieldTag = textField.tag;
    NSInteger textField_tag = textField.tag;
    //如果是日期和时间输入框
    if (textField_tag == 11 || textField_tag == 12 || textField_tag == 13 || textField_tag == 14) {
        [self cancelLocatePicker];
        [self.view endEditing:YES];
        if (textField_tag == 13 || textField_tag == 14) {
            UITextField *dateField = (UITextField *)[self.view viewWithTag:11];
            UITextField *timeField = (UITextField *)[self.view viewWithTag:12];
            if ([dateField.text  isEqual: @""] || [timeField.text  isEqual: @""]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先填写发车日期和出发时间" delegate:self cancelButtonTitle:@"确 定" otherButtonTitles:nil];
                [alert show];
                return NO;
            }
        }
        TXDatePickerView *datePicker = [[TXDatePickerView alloc] initWithTextFieldTag:textField_tag delegate:self];
        [datePicker showInView:self.view];
        return NO;
        
    }else if (textField_tag == 15 || textField_tag == 16)
    {
        [self cancelLocatePicker];
        [self.view endEditing:YES];
        TXProvinceController *province = [[TXProvinceController alloc] init];
        area_index = textField_tag;
        [self.navigationController pushViewController:province animated:YES];
        return NO;
    }else if (textField_tag == 19)
    {
        textField.keyboardType = UIKeyboardTypePhonePad;
    }
    else if (textField_tag == 20)
    {
        
        TXLicensePlateListController *license = [[TXLicensePlateListController alloc] init];
        [license setCanEdit:NO];
        
        [self.navigationController pushViewController:license animated:YES];
        return NO;
    }else if (textField_tag == 21)
    {
        TXNoteController *note = [[TXNoteController alloc] init];
        note.delegate = self;
        [self.navigationController pushViewController:note animated:YES];
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    //上移ScrollView
    [scrollView setContentOffset: CGPointMake(0,250) animated:YES];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    //下移ScrollView
    [scrollView setContentOffset: CGPointMake(0,0) animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
   
    BOOL isresign = [textField resignFirstResponder];
    return isresign;
    
}

//设置textfield响应点击
-(void)textFieldCanEndite:(UITextField *)texitField
{
    texitField.enabled = YES;
}

#pragma mark - TXNpteControllerDelegate
-(void)getTextViewText:(NSString *)Note
{
     NSLog(@"viewContrllers:%@",self.navigationController.viewControllers);
    [self getFieldWithTag:21].text =Note;
}


// override设置textField的值
-(void)setTextField:(TXDepartureTimetableModel *)departureTimetableModel
{
    vehicle_id = departureTimetableModel.vehicle_id;
    begin_area_id = departureTimetableModel.begin_area_id;
    begin_area = departureTimetableModel.begin_area;
    end_area_id = departureTimetableModel.end_area_id;
    end_area = departureTimetableModel.end_area;
    NSArray *atrribtes = @[departureTimetableModel.begin_area,departureTimetableModel.end_area,departureTimetableModel.begin_area_detail,departureTimetableModel.end_area_detail,[departureTimetableModel.price stringValue],departureTimetableModel.plate_number,departureTimetableModel.remark];
    for (NSInteger i =15; i<22; i++) {
        [[self getFieldWithTag:i] setText:[atrribtes objectAtIndex:i-15]];
    }
}


@end
