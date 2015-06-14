//
//  TXTokenModel.h
//  CARPeer
//
//  Created by ayctey on 15-4-9.
//  Copyright (c) 2015年 ayctey. All rights reserved.
//

#import "TXBaseModel.h"

@interface TXTokenModel : TXBaseModel

@property (nonatomic,copy) NSString *code;   //状态代码
@property (nonatomic,copy) NSString *useId;  //融云ID
@property (nonatomic,copy) NSString *token;  //融云令牌

@end
