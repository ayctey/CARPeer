//
//  NSManagedObject+BaseModel.h
//  CARPeer
//
//  Created by ayctey on 15-3-12.
//  Copyright (c) 2015年 ayctey. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (BaseModel)<NSCoding>

-(id)initWithDataDic:(NSDictionary*)data;
- (NSDictionary*)attributeMapDictionary;
- (void)setAttributes:(NSDictionary*)dataDic;
- (NSString *)customDescription;
- (NSString *)description;
- (NSData*)getArchivedData;

- (NSString *)cleanString:(NSString *)str;    //清除\n和\r的字符串


@end
