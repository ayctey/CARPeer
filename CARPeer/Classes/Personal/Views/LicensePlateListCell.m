//
//  LicensePlateListCell.m
//  CARPeer
//
//  Created by yezejiang on 15-1-13.
//  Copyright (c) 2015年 ayctey. All rights reserved.
//

#import "LicensePlateListCell.h"
#import "TXBusMessageModel.h"

@implementation LicensePlateListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.indicatorView.frame = CGRectMake(20, 20, 25, 25);
//        self.busNumberLabel.text = @"粤B372444";
//        self.typeLabel.text = @"卧铺";
        
    }
    return self;
}

//设置cell的label的text
-(void)setLabelText:(TXBusMessageModel *)busModel
{
    self.busNumberLabel.text = busModel.plate_number;
    self.typeLabel.text = busModel.vehicle_type;
}

- (UIImageView *)indicatorView
{
    if (!_indicatorView) {
        _indicatorView = [[UIImageView alloc] init];
        //_indicatorView.frame = CGRectMake(20, 20, 25, 25);
        //_indicatorView.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_indicatorView];
    }
    return _indicatorView;
}

- (UILabel *)busNumberLabel
{
    if (!_busNumberLabel) {
        _busNumberLabel = [[UILabel alloc] init];
        _busNumberLabel.frame = CGRectMake(75, 10, 120, 25);
        _busNumberLabel.font = [UIFont systemFontOfSize:16.0f];
        [self.contentView addSubview:_busNumberLabel];
    }
    return _busNumberLabel;
}

- (UILabel *)typeLabel
{
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.frame = CGRectMake(75, 5+25+5, 120, 20);
        _typeLabel.font = [UIFont systemFontOfSize:12.0f];
        _typeLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_typeLabel];
    }
    return _typeLabel;
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
