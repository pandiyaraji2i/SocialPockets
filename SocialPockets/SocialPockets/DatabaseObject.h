//
//  DatabaseObject.h
//  SocialPockets
//
//  Created by Pandiyaraj on 11/08/16.
//  Copyright © 2016 Pandiyaraj. All rights reserved.
//

#import <Foundation/Foundation.h>
#define DATABASE [DatabaseObject sharedCoreDatabase]

@interface DatabaseObject : NSObject


@property (readonly, strong, nonatomic) NSManagedObjectContext *childManagedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *dbPersistentConnection;


+ (DatabaseObject *)sharedCoreDatabase;
+ (NSArray *)dbQuery:(NSString*)tableName withWhere:(NSPredicate *)where andSortKey:(NSString*)sortKey andSortAscending:(BOOL)sortAscending;
+ (NSArray *)searchObjectsForEntityChild:(NSString*)entityName withPredicate:(NSPredicate *)predicate andSortKey:(NSString*)sortKey andSortAscending:(BOOL)sortAscending context:(NSManagedObjectContext*)managedContext;


- (void)dbSaveRecordContext;
- (void)dbSaveRecordChildContext:(NSManagedObjectContext *)managedObjectContext;
@end
