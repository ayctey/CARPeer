//
//  TXDataService.h
//  CARPeer
//
//  Created by yezejiang on 15-1-17.
//  Copyright (c) 2015年 ayctey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void(^CompletionBlock)(id responseObject,NSError *error);

@interface TXDataService : NSObject

+ (void)POST:(NSString *)urlString param:(NSDictionary *)param isCache:(BOOL)isCache caChetime:(NSTimeInterval)withTimeoutInterval completionBlock:(CompletionBlock)block;
+ (void)GET:(NSString *)urlString param:(NSDictionary *)param isCache:(BOOL)isCache caChetime:(NSTimeInterval)withTimeoutInterval completionBlock:(CompletionBlock)block;
+ (void)tongbuGET:(NSString *)urlString param:(id)param isCache:(BOOL)isCache caChetime:(NSTimeInterval)withTimeoutInterval completionBlock:(CompletionBlock)block;

@end
