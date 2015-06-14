//
//  TXDatePickerView.m
//  CARPeer
//
//  Created by yezejiang on 15-1-15.
//  Copyright (c) 2015年 ayctey. All rights reserved.
//

#import "TXDatePickerView.h"
#import "Common.h"

@implementation TXDatePickerView

- (id)initWithTextFieldTag:(NSInteger)tag delegate:(id<TXDatePickerDelegate>)delegate
{
    CGRect frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self = [super initWithFrame:frame];
    if (self) {
        fieldTag = tag;
        self.delegate = delegate;
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        [self addGestureRecognizer:tap];
        
        UIView *bgView = [[UIView alloc] init];
        bgView.frame  =CGRectMake(0, kScreenHeight-216, kScreenWidth, 216);
        bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bgView];
        
        //添加pickerView
        UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 216)];
        datePicker.tag = 100;

        //添加toolbar
        [self addToolbar];
        
        if (tag == 11 || tag == 13) {
            datePicker.maximumDate = [NSDate dateWithTimeIntervalSinceNow:60*60*24*15];
            datePicker.minimumDate = [NSDate date];
            datePicker.date = [NSDate dateWithTimeIntervalSinceNow:0];
            datePicker.datePickerMode = UIDatePickerModeDate;
        }else{
            datePicker.datePickerMode = UIDatePickerModeTime;
        }
        
        [datePicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
        [bgView addSubview:datePicker];
    }
    
    return self;
    
}

-(void)addToolbar
{
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, kScreenHeight-216-44, kScreenWidth, 44)];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(tapClick:)];
      UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    NSArray *items = [[NSArray alloc]initWithObjects:flexibleSpace,barItem,nil];
    toolbar.items = items;
    [self addSubview:toolbar];
}

- (void)tapClick:(UIGestureRecognizer *)tap
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.frame = CGRectMake(0, self.frame.origin.y+self.frame.size.height, self.frame.size.width, self.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         if([self.delegate respondsToSelector:@selector(pickerWithDate:)]) {
                             UIDatePicker *datePicker = (UIDatePicker *)[self.window viewWithTag:100];
                             NSDate *date = datePicker.date;
                             
                             NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                             if (fieldTag == 11 || fieldTag == 13) {
                                 [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                             }else{
                                 [dateFormatter setDateFormat:@"HH:mm"];
                             }
                             
                             NSString *dateString = [dateFormatter stringFromDate:date];
                             //NSString *dateString = [NSString stringWithFormat:@"%@",date];
                             [self.delegate pickerWithDate:dateString];
                         }

                         [self removeFromSuperview];
                         
                     }];
    }

- (void)showInView:(UIView *) view
{
    self.frame = CGRectMake(0, view.frame.size.height, self.frame.size.width, self.frame.size.height);
    [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, view.frame.size.height - self.frame.size.height, self.frame.size.width, self.frame.size.height);
    }];
    
}

@end
