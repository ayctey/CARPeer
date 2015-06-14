//
//  YCYBaseViewController.h
//  YCYmall
//
//  Created by ayctey on 14-10-27.
//  Copyright (c) 2014年 ayctey. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface TXBaseViewController : UIViewController
{
    BOOL addBackItem;

}


- (void)backSuperController;

//添加导航栏button
-(void)addbackButton;

//设置导航栏返回按钮样式
-(void)setBackButton;

@end
