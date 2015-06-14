//
//  TXDepartureTimetableModel.h
//  CARPeer
//
//  Created by yezejiang on 15-2-2.
//  Copyright (c) 2015年 ayctey. All rights reserved.
//

#import "TXBaseModel.h"

@interface TXDepartureTimetableModel : TXBaseModel

@property (nonatomic,strong) NSNumber *trainman_id;     //乘务员ID
@property (nonatomic,strong) NSNumber *departure_Timetable_id; //时刻表ID
@property (nonatomic,copy) NSString *end_area_id;       //到达区域ID
@property (nonatomic,copy) NSString *end_area;          //到达区域(如天河)
@property (nonatomic,copy) NSString *end_area_detail;   //到达详细区域(如天河客运站)
@property (nonatomic,copy) NSString *end_province_id;   //到达省份ID
@property (nonatomic,copy) NSString *end_province;       //到达省份
@property (nonatomic,copy) NSString *end_city_id;        //到达城市ID
@property (nonatomic,copy) NSString *end_city;           //到达城市
@property (nonatomic,copy) NSString *begin_area_id;     //出发区域ID
@property (nonatomic,copy) NSString *begin_area;        //出发区域
@property (nonatomic,copy) NSString *begin_area_detail; //出发详细区域
@property (nonatomic,copy) NSString *begin_province_id;  //出发省份ID
@property (nonatomic,copy) NSString *begin_province;     //出发省份
@property (nonatomic,copy) NSString *begin_city_id;      //出发城市ID
@property (nonatomic,copy) NSString *begin_city;         //出发城市
@property (nonatomic,copy) NSString *remark;            //备注
@property (nonatomic,copy) NSString *departure_time;    //发车时间
@property (nonatomic,copy) NSString *arrive_time;       //到达时间
@property (nonatomic,copy) NSString *vehicle_id;        //车辆ID
@property (nonatomic,copy) NSString *plate_number;      //车牌号
@property (nonatomic,strong) NSNumber *price;            //票价

- (NSString *)stringToDate:(NSString *)date istime:(BOOL)isTime;

@end
