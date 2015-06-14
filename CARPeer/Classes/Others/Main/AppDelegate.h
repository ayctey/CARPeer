//
//  AppDelegate.h
//  CARPeer
//
//  Created by ayctey on 15-1-3.
//  Copyright (c) 2015年 ayctey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) Reachability *rechable;

-(void)pushToLoginViewcontroller;
-(void)pushMaincomtroller;

@end

