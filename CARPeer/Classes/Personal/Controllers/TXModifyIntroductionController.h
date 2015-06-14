//
//  TXModifyIntroductionController.h
//  CARPeer

//修改个人简介控制器

//  Created by yezejiang on 15-1-14.
//  Copyright (c) 2015年 ayctey. All rights reserved.
//

#import "TXBaseViewController.h"

@interface TXModifyIntroductionController : TXBaseViewController
{
    NSString *intrString;
    UITextView *textView;
}


- (void)modifyClick;
- (void)getIntroduction:(NSString *)intr;

@end
