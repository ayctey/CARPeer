//
//  TXMoodifyUserNameController.h
//  CARPeer

//修改姓名控制器

//  Created by yezejiang on 15-1-14.
//  Copyright (c) 2015年 ayctey. All rights reserved.
//

#import "TXBaseViewController.h"

@interface TXMoodifyUserNameController : TXBaseViewController
{
    UITextField *userNameField;
    NSString *nameString;
}
- (void)getName:(NSString *)name;
@end
