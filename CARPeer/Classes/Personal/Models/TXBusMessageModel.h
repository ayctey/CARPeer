//
//  TXBusMessageModel.h
//  CARPeer
//
//  Created by yezejiang on 15-2-3.
//  Copyright (c) 2015年 ayctey. All rights reserved.
//

#import "TXBaseModel.h"

@interface TXBusMessageModel : TXBaseModel

@property (nonatomic,strong) NSNumber *vehicle_id;  //车辆ID
@property (nonatomic,copy) NSString *plate_number;  //车牌号
@property (nonatomic,copy) NSString *vehicle_type;  //车辆型号
@property (nonatomic,strong) NSNumber *seats;       //车辆的座位数

@end
