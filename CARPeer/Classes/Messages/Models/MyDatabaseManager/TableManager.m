//
//  TXDepatureTimeTableDatabaseManager.m
//  CoreData
//
//  Created by ayctey on 15-3-11.
//  Copyright (c) 2015年 ayctey. All rights reserved.
//

#import "TableManager.h"
#import "IQDatabaseManagerSubclass.h"

@interface TableManager ()
{
    NSString *sortingAttribute;
    NSArray *filteredRecords;
}

@end

@implementation TableManager

+(NSURL*)modelURL
{
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CARPeerModel" withExtension:IQ_MODEL_EXTENSION_momd];
    
    if (modelURL == nil)    modelURL = [[NSBundle mainBundle] URLForResource:@"CARPeerModel" withExtension:IQ_MODEL_EXTENSION_mom];
    
    return modelURL;
}

#pragma mark - RecordTable
- (NSArray *)allRecordsSortByAttribute:(NSString*)attribute talbel:(NSString *)table
{
    NSSortDescriptor *sortDescriptor = nil;
    
    if ([attribute length]) sortDescriptor = [[NSSortDescriptor alloc] initWithKey:attribute ascending:YES];
    
    return [self allObjectsFromTable:table sortDescriptor:sortDescriptor];
}

- (NSArray *)allRecordsSortByAttribute:(NSString*)attribute where:(NSString*)key contains:(id)value talbel:(NSString *)table
{
    NSSortDescriptor *sortDescriptor = nil;
    
    if ([attribute length]) sortDescriptor = [[NSSortDescriptor alloc] initWithKey:attribute ascending:YES];
    
    return [self allObjectsFromTable:table where:key contains:value sortDescriptor:sortDescriptor];
}

-(NSManagedObject *) insertRecordInRecordTable:(NSDictionary*)recordAttribute talbel:(NSString *)table
{
    return (NSManagedObject *)[self insertRecordInTable:table withAttribute:recordAttribute];
}

- (NSManagedObject *) insertUpdateRecordInRecordTable:(NSDictionary*)recordAttribute talbel:(NSString *)table
{
    return (NSManagedObject *)[self insertRecordInTable:table withAttribute:recordAttribute updateOnExistKey:nil equals:[recordAttribute objectForKey:nil]];
}

- (NSManagedObject*) updateRecord:(NSManagedObject *)record inRecordTable:(NSDictionary*)recordAttribute talbel:(NSString *)table
{
    return (NSManagedObject *)[self updateRecord:record withAttribute:recordAttribute];
}

- (BOOL) deleteTableRecord:(NSManagedObject *)record talbel:(NSString *)table
{
    return [self deleteRecord:record];
}

-(BOOL) deleteAllTableRecord:(NSString *)table
{
    return [self flushTable:table];
}

@end
