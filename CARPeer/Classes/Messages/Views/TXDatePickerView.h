//
//  TXDatePickerView.h
//  CARPeer

//时间选择器

//  Created by yezejiang on 15-1-15.
//  Copyright (c) 2015年 ayctey. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TXDatePickerView;

@protocol TXDatePickerDelegate <NSObject>

@optional
- (void)pickerWithDate:(NSString *)dateString;


@end
@interface TXDatePickerView : UIView
{
    NSInteger fieldTag;
}
@property (assign, nonatomic) id <TXDatePickerDelegate> delegate;

- (void)showInView:(UIView *)view;
- (id)initWithTextFieldTag:(NSInteger)tag delegate:(id<TXDatePickerDelegate>)delegate;
@end
