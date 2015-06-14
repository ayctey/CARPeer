//
//  TXCitierController.h
//  CARPeer

//城市选择控制器

//  Created by yezejiang on 15-2-5.
//  Copyright (c) 2015年 ayctey. All rights reserved.
//

#import "TXProvinceController.h"

@interface TXCitiesController : TXProvinceController
{
    NSMutableArray *cityData;
    
}
@property (nonatomic,strong) NSString *province_id;

@end
