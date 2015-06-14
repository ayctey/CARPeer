//
//  MessagesCell.h
//  CARPeer

//发布信息Cell

//  Created by yezejiang on 15-1-7.
//  Copyright (c) 2015年 ayctey. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TXDepartureTimetableModel;
@interface MessagesCell : UITableViewCell

@property (nonatomic,strong) UILabel *vehicleNumber; //车辆编号
@property (nonatomic,strong) UILabel *origin;        //出发地
@property (nonatomic,strong) UILabel *destination;   //目的地
@property (nonatomic,strong) UILabel *price;         //票价
@property (nonatomic,strong) UILabel *departureTime; //出发时间
@property (nonatomic,strong) UILabel *arrivalTime;   //预计到达时间
@property (nonatomic,strong) UIImageView *headIamge; //图片
@property (nonatomic,strong) UILabel *departureDate; //出发日期
@property (nonatomic,strong) TXDepartureTimetableModel *departureModel;
@end
