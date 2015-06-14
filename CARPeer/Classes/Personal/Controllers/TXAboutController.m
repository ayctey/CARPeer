//
//  TXAboutController.m
//  CARPeer

//关于控制器

//  Created by yezejiang on 15-1-12.
//  Copyright (c) 2015年 ayctey. All rights reserved.
//

#import "TXAboutController.h"
#import "Common.h"

@interface TXAboutController ()
{
    UILabel *versionNumberLabel;
    UILabel *aboutUsLabel;
}
@end

@implementation TXAboutController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initViews];
    
}

- (void)initViews
{
    float scale = 0.7;
    UIImageView *teamImage = [[UIImageView alloc] init];
    teamImage.frame = CGRectMake(0, kNavigationH, kScreenWidth, kScreenWidth*0.7);
    teamImage.image = [UIImage imageNamed:@"tuanxiangtuan@2x"];
    [self.view addSubview:teamImage];
    
    UIView *bgView =[[UIView alloc] init];
    bgView.frame = CGRectMake(0, kScreenWidth*scale+kNavigationH, kScreenWidth, 40);
    bgView.backgroundColor = kBackgroundColor;
    [self.view addSubview:bgView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(10, 5, 80, 30);
    titleLabel.text = @"版本号";
    [bgView addSubview:titleLabel];
    
    versionNumberLabel = [[UILabel alloc] init];
    versionNumberLabel.frame = CGRectMake(kScreenWidth-80, 5, 80, 30);
    versionNumberLabel.text = @"v0.9.1";
    [bgView addSubview:versionNumberLabel];
    
    UIView *bgView2 =[[UIView alloc] init];
    bgView2.frame = CGRectMake(0, kScreenWidth*scale+kNavigationH+50, kScreenWidth, 40);
    bgView2.backgroundColor = kBackgroundColor;
    [self.view addSubview:bgView2];
    
    UILabel *titleLabel2 = [[UILabel alloc] init];
    titleLabel2.frame = CGRectMake(10, 5, 80, 30);
    titleLabel2.text = @"关于我们";
    [bgView2 addSubview:titleLabel2];
    
    UIButton *updateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    updateBtn.frame = CGRectMake(10, bgView2.frame.origin.y+60, kScreenWidth-20, 35);
    updateBtn.backgroundColor = [UIColor redColor];
    [updateBtn setTitle:@"检查更新" forState:UIControlStateNormal];
    [updateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [updateBtn addTarget:self action:@selector(updateClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:updateBtn];
    
}

- (void)updateClick
{
    
}


@end
