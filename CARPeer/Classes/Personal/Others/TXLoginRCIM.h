//
//  TXLoginRCIM.h
//  CARPeer
//
//  Created by ayctey on 15-4-10.
//  Copyright (c) 2015年 ayctey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCIM.h"

@interface TXLoginRCIM : NSObject
{
    @protected
    NSString *RCIMToken;
}

+(id)shareLoginRCIM;
-(void)connectRCIM;

@end
