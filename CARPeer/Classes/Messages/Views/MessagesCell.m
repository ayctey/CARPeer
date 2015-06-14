//
//  MessagesCell.m
//  CARPeer
//
//  Created by yezejiang on 15-1-7.
//  Copyright (c) 2015年 ayctey. All rights reserved.
//

#import "MessagesCell.h"
#import "TXDepartureTimetableModel.h"
#import "Common.h"

@implementation MessagesCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
   self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        [self initViews];

    }
    return self;
}

- (void)initViews
{
    UILabel *line = [[UILabel alloc] init];
    line.frame = CGRectMake(128, 42, 20, 1);
    line.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:line];
    
//    UILabel *line2 = [[UILabel alloc] init];
//    line2.frame = CGRectMake(115, 57, 20, 20);
//    line2.text = @"~";
//    line2.textColor = [UIColor grayColor];
//    [self.contentView addSubview:line2];
    
    UILabel *line3 = [[UILabel alloc] init];
    line3.frame = CGRectMake(20, 79, kScreenWidth-40, 0.5);
    line3.backgroundColor= [UIColor lightGrayColor];
    [self.contentView addSubview:line3];
}

- (UIImageView *)headIamge
{
    if (!_headIamge) {
        _headIamge = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 50, 50)];
        
        [self.contentView addSubview:_headIamge];
    }
    return _headIamge;
}

- (UILabel *)price
{
    if (!_price) {
        _price = [[UILabel alloc] initWithFrame:CGRectMake(155, 55, 60, 25)];
        _price.textColor = [UIColor redColor];
        _price.font = [UIFont systemFontOfSize:13.0f];
        _price.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_price];
    }
    return _price;
}

- (UILabel *)origin
{
    if (!_origin) {
        _origin = [[UILabel alloc] initWithFrame:CGRectMake(70, 22, 60, 40)];
        _origin.textColor = [UIColor blackColor];
        _origin.font = [UIFont systemFontOfSize:17.0f];
        _origin.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_origin];
    }
    return _origin;
}

- (UILabel *)destination
{
    if (!_destination) {
        _destination = [[UILabel alloc] initWithFrame:CGRectMake(155, 22, 60, 40)];
        _destination.textColor = [UIColor blackColor];
        _destination.font = [UIFont systemFontOfSize:17.0f];
        _destination.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_destination];
    }
    return _destination;
}

- (UILabel *)vehicleNumber
{
    if (!_vehicleNumber) {
        _vehicleNumber = [[UILabel alloc] initWithFrame:CGRectMake(70, 5, 180, 25)];
        _vehicleNumber.textColor = [UIColor grayColor];
        _vehicleNumber.font = [UIFont systemFontOfSize:13.0f];
        _vehicleNumber.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_vehicleNumber];
    }
    return _vehicleNumber;
}

- (UILabel *)departureTime
{
    if (!_departureTime) {
        _departureTime = [[UILabel alloc] initWithFrame:CGRectMake(70, 55, 60, 25)];
        _departureTime.textColor = [UIColor grayColor];
        _departureTime.font = [UIFont systemFontOfSize:13.0f];
        _departureTime.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_departureTime];
    }
    return _departureTime;
}

//- (UILabel *)arrivalTime
//{
//    if (!_arrivalTime) {
//        _arrivalTime = [[UILabel alloc] initWithFrame:CGRectMake(130, 55, 60, 25)];
//        _arrivalTime.textColor = [UIColor grayColor];
//        _arrivalTime.font = [UIFont systemFontOfSize:13.0f];
//        _arrivalTime.textAlignment = NSTextAlignmentLeft;
//        [self.contentView addSubview:_arrivalTime];
//    }
//    return _arrivalTime;
//}

- (UILabel *)departureDate
{
    if (!_departureDate) {
        _departureDate = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-90, 30, 80, 25)];
        _departureDate.textColor = [UIColor grayColor];
        _departureDate.font = [UIFont systemFontOfSize:15.0f];
        _departureDate.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_departureDate];
    }
    return _departureDate;
}

- (void)setDepartureModel:(TXDepartureTimetableModel *)departureModel
{
    _departureModel = departureModel;
    self.vehicleNumber.text = [NSString stringWithFormat:@"车牌号：%@",departureModel.plate_number];
    self.headIamge.image = [UIImage imageNamed:@"bus"];
    self.origin.text = departureModel.begin_area;
    self.destination.text = departureModel.end_area;
    self.price.text = [NSString stringWithFormat:@"￥%@",departureModel.price];
    
    
    //出发日期
    NSString *departure_date = [departureModel.departure_time substringToIndex:11];
    
    //出发时间
    NSString *departureTime =[departureModel.departure_time substringFromIndex:11];
    NSString *departure_time = [departureTime substringToIndex:5];
   
    
    self.departureTime.text = [NSString stringWithFormat:@"始：%@",departure_time];
    self.departureDate.text = departure_date;
 
}

-(NSDate *)stringToDate:(NSString*)date
{
    NSDateFormatter *inputFormatter= [[NSDateFormatter alloc] init];
    
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] ];
    [inputFormatter setTimeZone: [NSTimeZone timeZoneWithName:@"GMT"]];
    
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *inputDate = [inputFormatter dateFromString:date];
    
    NSLog(@"date= %@",inputDate);
    return inputDate;
}

@end
