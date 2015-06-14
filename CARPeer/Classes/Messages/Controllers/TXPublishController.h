//
//  TXPublishController.h
//  CARPeer
//
//  Created by yezejiang on 15-1-7.
//  Copyright (c) 2015年 ayctey. All rights reserved.
//

#import "TXBaseViewController.h"
#import "HZAreaPickerView.h"
#import "TXDatePickerView.h"
#import "TXNoteController.h"

@class TXDepartureTimetableModel;

@interface TXPublishController : TXBaseViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate,HZAreaPickerDelegate,TXDatePickerDelegate,TXNoteControllerDelegate>

{
@protected
    NSArray *itemsArr;
    NSInteger buttonTag;
    UIScrollView *scrollView;
    CGRect bgView_frame;
    NSInteger textFieldTag;
    NSInteger area_index;
    NSString *begin_area_id;
    NSString *end_area_id;
    NSString *begin_area;
    NSString *end_area;
    NSString *vehicle_id;
    UIActivityIndicatorView *indicatorView;//活动指示图
}

@property (nonatomic,strong) NSString *rmark;
@property (nonatomic,strong) NSString *buttonTitle; //button Tittle


-(void)setTextField:(TXDepartureTimetableModel *)departureTimetableModel;

@end
