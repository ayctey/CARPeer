//
//  TXindicatorView.m
//  CARPeer
//
//  Created by ayctey on 15-4-4.
//  Copyright (c) 2015年 ayctey. All rights reserved.
//

#import "TXindicatorView.h"
#import "common.h"

@implementation TXindicatorView

+(UIActivityIndicatorView *)IndicatorView:(NSString *)message
{
    
   UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [indicatorView setCenter:CGPointMake(kScreenWidth/2, kScreenHeight/2)];
    [indicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    indicatorView.backgroundColor = [UIColor blackColor];
    indicatorView.alpha = 0.5;
    //设置背景为圆角矩形
    indicatorView.layer.cornerRadius = 6;
    [[[UIApplication sharedApplication].delegate window] addSubview:indicatorView];
    return indicatorView;
}

@end
