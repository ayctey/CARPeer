//
//  APIManage.h
//  CARPeer
//
//  Created by yezejiang on 15-1-17.
//  Copyright (c) 2015年 ayctey. All rights reserved.
//

#ifndef CARPeer_APIManage_h
#define CARPeer_APIManage_h
//融云AppKey
#define RYAppKey @"mgb7ka1nbs6yg"
#define RYToken @"c3UjbkpoDaQ9rmlMeZ7Eh5VmQn2zMKHXoiTDcV96IdBapJvzJGVHEqZjkbTgcwpuNPWAWN3G/TCHTQ9NBIHxKxmPPd3ST+D0"

#define BASE_URL @"http://112.74.111.134:8080/"

//获取融云令牌
#define getToken @"tongxiang/trainman/getToken"

#define  _login @"tongxiang/trainman/login"
//注销登录
#define loginOut @"tongxiang/public/logout"
#define updatePass @"tongxiang/trainman/updatePass"
#define updateTel @"tongxiang/trainman/updateTel"
#define existTel @"tongxiang/trainman/existTel"
#define updateTrainmanName @"tongxiang/trainman/updateTrainmanName"
#define updateSex @"tongxiang/trainman/updateSex"
#define updateBirthday @"tongxiang/trainman/updateBirthday"
#define updateIntro @"tongxiang/trainman/updateIntro"
#define updateVehicleType @"tongxiang/trainman/updateVehicleType"
#define updatePlateNum @"tongxiang/trainman/updatePlateNum"
#define updateSeats @"tongxiang/trainman/updateSeats"
#define getDepartureTimetable @"tongxiang/trainman/getDepartureTimetable"
#define addDepartureTimetable @"tongxiang/trainman/addDepartureTimetable"

//删除时刻表
#define delDepartureTimetable @"tongxiang/trainman/delDepartureTimetable"
#define updateTimetableVehicle @"tongxiang/trainman/updateTimetableVehicle"
#define updateTimetableBeginAreaID @"tongxiang/trainman/updateTimetableBeginAreaID"
#define updateTimetableBeginArea @"tongxiang/trainman/updateTimetableBeginArea"
#define updateTimetableEndAreaID @"tongxiang/trainman/updateTimetableEndAreaID"
#define updateTimetableEndArea @"tongxiang/trainman/updateTimetableEndArea"
#define updateTimetablePrice @"tongxiang/trainman/updateTimetablePrice"
#define updateTimetableDepartureTime @"tongxiang/trainman/updateTimetableDepartureTime"
#define updateTimetableArriveTime @"tongxiang/trainman/updateTimetableArriveTime"
#define updateTimetableRemark @"tongxiang/trainman/updateTimetableRemark"
#define getVehicleType @"tongxiang/trainman/getVehicleType"
#define getVehicle @"tongxiang/trainman/getVehicle"
#define addVehicle @"tongxiang/trainman/addVehicle"

#define getProvince @"tongxiang/public/getProvince"
#define getCity @"tongxiang/public/getCity"
#define getArea @"tongxiang/public/getArea"

#endif
