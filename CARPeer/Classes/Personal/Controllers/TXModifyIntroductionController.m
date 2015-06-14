//
//  TXModifyIntroductionController.m
//  CARPeer
//
//  Created by yezejiang on 15-1-14.
//  Copyright (c) 2015年 ayctey. All rights reserved.
//

#import "TXModifyIntroductionController.h"
#import "TXDataService.h"
#import "Common.h"
#import "TXindicatorView.h"

@interface TXModifyIntroductionController ()
{
    UIActivityIndicatorView *indicatorView;//活动指示图
}

@end

@implementation TXModifyIntroductionController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"简介";
    self.view.backgroundColor = kBackgroundColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initViews];
    
    //添加活动指示图
    indicatorView = [TXindicatorView IndicatorView:nil];
}

#pragma mark - 加载数据
- (void)submitData
{
    //停止和启动指示图
    if ([indicatorView isAnimating]) {
        [indicatorView stopAnimating];
    }
    else
    {
        if ([[Reachability reachabilityWithHostName:@"www.baidu.com"] isReachable]) {
            [indicatorView startAnimating];
        }
    }
    
    NSDictionary *introParam = @{@"intro":textView.text};
    [TXDataService POST:updateIntro param:introParam isCache:NO caChetime:0 completionBlock:^(id responseObject, NSError *error) {
        
        //停止指示图
        if ([indicatorView isAnimating]) {
            [indicatorView stopAnimating];
        }
        
        if(error != nil)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"修改不成功！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"好", nil];
            [alert show];
        }
        
        if ([responseObject objectForKey:@"success"]) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setValue:textView.text forKey:@"intro"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"intro" object:textView.text];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

#pragma mark -添加视图
- (void)initViews
{
    textView = [[UITextView alloc] initWithFrame:CGRectMake(20, kNavigationH+10,kScreenWidth-40, 80)];
    textView.backgroundColor = [UIColor whiteColor];
    textView.textContainerInset = UIEdgeInsetsMake(2, 2, 2, 2);
    textView.font = [UIFont systemFontOfSize:18.0f];
    if (intrString) {
        textView.text = intrString;
    }
    
    textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [textView becomeFirstResponder];
    [self.view addSubview:textView];
    
    //确认按钮
    UIButton *modifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [modifyBtn setFrame:CGRectMake(20, 100+kNavigationH, kScreenWidth-40, 35)];
    [modifyBtn setBackgroundColor:[UIColor redColor]];
    [modifyBtn setTitle:@"确  定" forState:UIControlStateNormal];
    [modifyBtn addTarget:self action:@selector(modifyClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:modifyBtn];

}

- (void)modifyClick
{
    [self submitData];
}

- (void)getIntroduction:(NSString *)intr;
{
    intrString = intr;
}

@end
