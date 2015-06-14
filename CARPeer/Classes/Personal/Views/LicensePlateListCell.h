//
//  LicensePlateListCell.h
//  CARPeer
//
//  Created by yezejiang on 15-1-13.
//  Copyright (c) 2015年 ayctey. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TXBusMessageModel;
@interface LicensePlateListCell : UITableViewCell

@property (nonatomic,strong) UIImageView *indicatorView;
@property (nonatomic,strong) UILabel *busNumberLabel;
@property (nonatomic,strong) UILabel *typeLabel;
@property (nonatomic,strong) TXBusMessageModel *busModel;

//设置cell的label的text
-(void)setLabelText:(TXBusMessageModel *)busModel;

@end
