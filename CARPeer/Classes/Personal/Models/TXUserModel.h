//
//  TXUserModel.h
//  CARPeer
//
//  Created by yezejiang on 15-1-17.
//  Copyright (c) 2015年 ayctey. All rights reserved.
//

#import "TXBaseModel.h"

@interface TXUserModel : TXBaseModel

@property (nonatomic,copy) NSString *account;
@property (nonatomic,copy) NSString *password;
@property (nonatomic,copy) NSString *sex;
@property (nonatomic,copy) NSString *birthday;
@property (nonatomic,copy) NSString *tel;
@property (nonatomic,copy) NSString *motorcade_Name;
@property (nonatomic,copy) NSString *trainman_ID;
@property (nonatomic,copy) NSString *trainman_Name;
@property (nonatomic,copy) NSString *isValid;
@property (nonatomic,copy) NSString *protrait_Url;
@property (nonatomic,copy) NSString *intro;
@property (nonatomic,copy) NSString *code;

@end
