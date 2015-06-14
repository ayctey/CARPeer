//
//  TXDepartureTimetableModel.m
//  CARPeer
//
//  Created by yezejiang on 15-2-2.
//  Copyright (c) 2015年 ayctey. All rights reserved.
//

#import "TXDepartureTimetableModel.h"

@implementation TXDepartureTimetableModel

- (NSString *)stringToDate:(NSString *)date istime:(BOOL)isTime
{
    if (isTime) {
        NSString *departureTime =[date substringFromIndex:11];
        NSString *time = [departureTime substringToIndex:5];
        //返回时间
        return time;
    }else
    {
        NSString *myDate =[date substringToIndex:11];
        //返回日期
        return myDate;
    }
}

@end
