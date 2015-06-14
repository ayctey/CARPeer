//
//  TXDataService.m
//  CARPeer
//
//  Created by yezejiang on 15-1-17.
//  Copyright (c) 2015年 ayctey. All rights reserved.
//

#import "TXDataService.h"
#import "NSString+MD5.h"
#import "AFNetworkReachabilityManager.h"
#import "EGOCache.h"
#import "Common.h"

@implementation TXDataService

+ (void)POST:(NSString *)urlString param:(NSDictionary *)param isCache:(BOOL)isCache caChetime:(NSTimeInterval)withTimeoutInterval completionBlock:(CompletionBlock)block
{
    //获取缓存key
    NSString *key = [[EGOCache globalCache] getkey:urlString pramaters:param];
    key = [key MD5Hash];
    //是否有缓存
    BOOL isHascache =[[EGOCache globalCache] hasCacheForKey:key];
    if (isHascache) {
        NSData *data = [[EGOCache globalCache] dataForKey:key];
        NSArray *responseObject= [NSKeyedUnarchiver unarchiveObjectWithData:data];
        //返回数据
        block(responseObject,nil);
    }else
    {
        //检测网络
        if ([[Reachability reachabilityWithHostName:@"www.baidu.com"] isReachable]) {
             NSLog(@"网络已经连接");
            NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,urlString];
            AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
            
            [manager POST:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
                block(responseObject,nil);
                
                //是否缓存
                if (isCache) {
                    //缓存数据
                    EGOCache *cache = [[EGOCache globalCache] init];
                    
                    //拼接网址
                    NSString *allUrlString = [cache getkey:urlString pramaters:param];
                    allUrlString = [allUrlString MD5Hash];
                    [cache setObject:responseObject forKey:allUrlString withTimeoutInterval:withTimeoutInterval];
                    NSLog(@"缓存是否成功：%d",[[EGOCache globalCache] hasCacheForKey:allUrlString]);
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                block(nil,error);
                NSLog(@"%@",error);
            }];
        }else
        {
            UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络不佳，请稍后再试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alerView show];
        }
    }
}

+ (void)GET:(NSString *)urlString param:(NSDictionary *)param isCache:(BOOL)isCache caChetime:(NSTimeInterval)withTimeoutInterval completionBlock:(CompletionBlock)block
{
    //获取缓存key
    NSString *key = [[EGOCache globalCache] getkey:urlString pramaters:param];
    key = [key MD5Hash];
    //是否有缓存
   BOOL isHascache =[[EGOCache globalCache] hasCacheForKey:key];
    NSLog(@"ishascache:%d",isCache);
    if (isHascache) {
        NSData *data = [[EGOCache globalCache] dataForKey:key];
        NSArray *responseObject= [NSKeyedUnarchiver unarchiveObjectWithData:data];
        //返回数据
        block(responseObject,nil);
    }else
    {
        //检测网络
        if ([[Reachability reachabilityWithHostName:@"www.baidu.com"] isReachable]) {
            NSLog(@"网络已经连接");
            NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,urlString];
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            [manager GET:url parameters:param success:^(AFHTTPRequestOperation *operation, id    responseObject) {
                block(responseObject,nil);
                
                //是否缓存
                if (isCache) {
                    //缓存数据
                    EGOCache *cache = [[EGOCache globalCache] init];
                    
                    //拼接网址
                    NSString *allUrlString = [cache getkey:urlString pramaters:param];
                    allUrlString = [allUrlString MD5Hash];
                    [cache setObject:responseObject forKey:allUrlString withTimeoutInterval:withTimeoutInterval];
                    NSLog(@"缓存是否成功：%d",[[EGOCache globalCache] hasCacheForKey:allUrlString]);
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                block(nil,error);
            }];
        }else
        {
            UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络不佳，请稍后再试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alerView show];
        }
            }
}

+ (void)tongbuGET:(NSString *)urlString param:(id)param isCache:(BOOL)isCache caChetime:(NSTimeInterval)withTimeoutInterval completionBlock:(CompletionBlock)block
{
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,urlString];
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    NSMutableURLRequest *request = [requestSerializer requestWithMethod:@"GET" URLString:url parameters:param error:nil];
    
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    AFHTTPResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
    
    [requestOperation setResponseSerializer:responseSerializer];
    [requestOperation start];
    [requestOperation waitUntilFinished];
    block([requestOperation responseObject],nil);
}

@end
