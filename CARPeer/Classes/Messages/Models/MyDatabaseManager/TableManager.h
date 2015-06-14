//
//  TXDepatureTimeTableDatabaseManager.h
//  CoreData
//
//  Created by ayctey on 15-3-11.
//  Copyright (c) 2015年 ayctey. All rights reserved.
//

#import "IQDatabaseManager.h"

@interface TableManager : IQDatabaseManager


- (NSArray *)allRecordsSortByAttribute:(NSString*)attribute talbel:(NSString *)table;
- (NSArray *)allRecordsSortByAttribute:(NSString*)attribute where:(NSString*)key contains:(id)value talbel:(NSString *)table;

- (NSManagedObject*) insertRecordInRecordTable:(NSDictionary*)recordAttributes talbel:(NSString *)table;
- (NSManagedObject*) insertUpdateRecordInRecordTable:(NSDictionary*)recordAttributes talbel:(NSString *)table;
- (NSManagedObject*) updateRecord:(NSManagedObject*)record inRecordTable:(NSDictionary*)recordAttributes talbel:(NSString *)table;
- (BOOL) deleteTableRecord:(NSManagedObject*)record talbel:(NSString *)table;


- (BOOL) deleteAllTableRecord:(NSString *)table;

@end
