//
//  TXNoteController.m
//  CARPeer
//
//  Created by yezejiang on 15-1-17.
//  Copyright (c) 2015年 ayctey. All rights reserved.
//

#import "TXNoteController.h"
#import "TXPublishController.h"

@interface TXNoteController ()

@end

@implementation TXNoteController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"备注";
}

- (void)modifyClick
{
    if ([self.delegate respondsToSelector:@selector(getTextViewText:)]) {
        [self.delegate getTextViewText:textView.text];
         NSLog(@"viewContrllers:%@",self.navigationController.viewControllers);
        [self.navigationController popViewControllerAnimated:YES];
        NSLog(@"viewContrllers:%@",self.navigationController.viewControllers);
    }
}

@end
