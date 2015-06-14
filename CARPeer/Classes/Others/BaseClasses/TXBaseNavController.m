//
//  YCYBaseNavController.m
//  YCYmall
//
//  Created by ayctey on 14-10-27.
//  Copyright (c) 2014年 ayctey. All rights reserved.
//

#import "TXBaseNavController.h"
#import "Common.h"
@interface TXBaseNavController ()

@end

@implementation TXBaseNavController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.barTintColor = [UIColor redColor];
    
    //UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"hello" style:UIBarButtonItemStyleDone target:self action:nil];
    //backItem.title = @"< 返回";
    //backItem.tintColor = [UIColor blackColor];

    //self.navigationItem.backBarButtonItem = backItem;
    //self.navigationItem.backBarButtonItem.tintColor = [UIColor blackColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
