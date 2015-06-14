//
//  TXSessionControllerViewController.m
//  CARPeer
//
//  Created by ayctey on 15-3-19.
//  Copyright (c) 2015年 ayctey. All rights reserved.
//

#import "TXSessionController.h"
#import "RCChatViewController.h"

@interface TXSessionController ()

@end

@implementation TXSessionController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏左右按钮为空
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
    [self setNavigationTitle:@"消息列表" textColor:[UIColor blackColor]];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//overridde
//-(void)startPrivateChat:(RCUserInfo*)userInfo
//{
//    [super startPrivateChat:userInfo];
//    RCChatViewController *chatViewController = [[RCChatViewController alloc] init];
//    chatViewController.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:chatViewController animated:YES];
//}

//重载 TableView 表格点击事件
-(void)onSelectedTableRow:(RCConversation*)conversation{
    
    /*
     if(conversation.conversationType == ConversationType_GROUP)
     {
     DemoGroupListViewController* groupVC = [[DemoGroupListViewController alloc] init];
     self.currentGroupListView = groupVC;
     [self.navigationController pushViewController:groupVC animated:YES];
     return;
     }
     */
    // 该方法目的延长会话聊天 UI 的生命周期
    RCChatViewController* chat = [self getChatController:conversation.targetId conversationType:conversation.conversationType];
    
    if (nil == chat) {
        chat =[[RCChatViewController alloc]init];
        [self addChatController:chat];
    }
    chat.currentTarget = conversation.targetId;
    chat.conversationType = conversation.conversationType;
    //chat.currentTargetName = curCell.userNameLabel.text;
    chat.currentTargetName = conversation.conversationTitle;
    chat.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chat animated:YES];
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
