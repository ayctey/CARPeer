//
//  ViewController.m
//  CARPeer
//
//  Created by ayctey on 15-1-3.
//  Copyright (c) 2015年 ayctey. All rights reserved.
//

#import "ViewController.h"
#include "RCIM.h"
#import "RCChatViewController.h"
#import "Common.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button setTitle:@"单聊" forState:UIControlStateNormal];
    _button.frame = CGRectMake(100, 100, 60, 30);
    [_button addTarget:self action:@selector(danliao) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button];
}

- (void)danliao
{
    // 连接融云服务器。
    [RCIM connectWithToken:RYToken completion:^(NSString *userId) {
        // 此处处理连接成功。
        NSLog(@"Login successfully with userId: %@.", userId);
        
        // 创建单聊视图控制器。
        RCChatViewController *chatViewController = [[RCIM sharedRCIM]createPrivateChat:@"953041558" title:nil completion:^(){
            // 创建 ViewController 后，调用的 Block，可以用来实现自定义行为。
        }];
        
        // 把单聊视图控制器添加到导航栈。
        [self.navigationController pushViewController:chatViewController animated:YES];
        
    } error:^(RCConnectErrorCode status) {
        // 此处处理连接错误。
        NSLog(@"Login failed.");
    }];
}


@end
