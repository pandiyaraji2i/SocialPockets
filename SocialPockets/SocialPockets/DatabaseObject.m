//
//  DatabaseObject.m
//  SocialPockets
//
//  Created by Pandiyaraj on 11/08/16.
//  Copyright © 2016 Pandiyaraj. All rights reserved.
//

#import "DatabaseObject.h"

@implementation DatabaseObject

@synthesize childManagedObjectContext = _childManagedObjectContext;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize dbPersistentConnection = _dbPersistentConnection;


static DatabaseObject * _sharedCoreDatabase = nil;

+ (DatabaseObject *)sharedCoreDatabase
{
    @synchronized([DatabaseObject class])
    {
        if (!_sharedCoreDatabase)
        {
            _sharedCoreDatabase=[[DatabaseObject alloc] init];
        }
        return _sharedCoreDatabase;
    }
    return nil;
}

// ********************************** Database Persistent Connection ************************************************** //

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"SocialPockets" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

//#-- Persistent Store Coordinator

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)dbPersistentConnection
{
    if (_dbPersistentConnection != nil) {
        return _dbPersistentConnection;
    }
    
    NSURL *storeURL = [DOCUMENT_DIRECTORY_URL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",@"SocialPockets"]];
    
    /*
     Set up the store.
     For the sake of illustration, provide a pre-populated default store.
     */
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // If the expected store doesn't exist, copy the default store.
    if (![fileManager fileExistsAtPath:[storeURL path]]) {
        NSURL *defaultStoreURL = [[NSBundle mainBundle] URLForResource:@"SocialPockets" withExtension:@"sqlite"];
        if (defaultStoreURL) {
            [fileManager copyItemAtURL:defaultStoreURL toURL:storeURL error:NULL];
        }
    }
    NSError *error = nil;
    _dbPersistentConnection = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_dbPersistentConnection addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _dbPersistentConnection;
}

// ********************************** Database Table Record Collection ************************************************** //

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self dbPersistentConnection];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedObjectContext setMergePolicy:NSMergeByPropertyStoreTrumpMergePolicy];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// ********************************** Database Get (Select) Query ************************************************** //

#pragma mark - Fetch

//#-- Search Object Entity

+(NSArray *)dbQuery:(NSString*)tableName withWhere:(NSPredicate *)where andSortKey:(NSString*)sortKey andSortAscending:(BOOL)sortAscending
{
    //    static NSString *fetchRequest = @"fetchRequest";
    __block NSArray *mutableFetchResults;
    //    @synchronized (fetchRequest){
    // Create fetch request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:tableName inManagedObjectContext:DATABASE.managedObjectContext];
    [request setEntity:entity];
    [request setFetchBatchSize:50];
    
    // If a predicate was specified then use it in the request
    if (where != nil)
        [request setPredicate:where];
    
    // If a sort key was passed then use it in the request
    if (sortKey != nil) {
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortKey ascending:sortAscending];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        [request setSortDescriptors:sortDescriptors];
    }
    
    // Execute the fetch request
    __block NSError *error = nil;
    
    [DATABASE.managedObjectContext performBlockAndWait:^{
        mutableFetchResults = [DATABASE.managedObjectContext executeFetchRequest:request error:&error];
    }];
    
    
    // If the returned array was nil then there was an error
    if (mutableFetchResults == nil)
        NSLog(@"Couldn't get objects for entity %@", tableName);
    //    }
    // Return the results
    return mutableFetchResults;
    
}

// ********************************** Database Transaction ************************************************** //

//#-- Save Context

#pragma mark - Core Data stack

- (void)dbSaveRecordContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    
    if (managedObjectContext != nil) {
        //[[NSNotificationCenter defaultCenter] postNotificationName:@"CoreDataBeforeSaveNotification" object:nil];
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            abort();
        }
    }
}

- (void)dbSaveRecordChildContext:(NSManagedObjectContext *)managedObjectContext
{
    //    @synchronized([managedObjectContext persistentStoreCoordinator]) {
    //dispatch_async(dispatch_get_current_queue(), ^{
    if (![managedObjectContext isEqual:DATABASE.managedObjectContext]) {
        [managedObjectContext performBlockAndWait:^{
            NSError *childError = nil;
            if ([managedObjectContext save:&childError]) {
                if (![managedObjectContext.parentContext isEqual:DATABASE.managedObjectContext]) {
                    [managedObjectContext.parentContext performBlockAndWait:^{
                        NSError *parentError = nil;
                        if (![managedObjectContext.parentContext save:&parentError]) {
                            NSLog(@"Error saving parent");
                        }
                    }];
                }
                [DATABASE.managedObjectContext performBlockAndWait:^{
                    NSError *parentError = nil;
                    if (![DATABASE.managedObjectContext save:&parentError]) {
                        NSLog(@"Error saving parent");
                    }
                }];
            } else {
                NSLog(@"Error saving child");
            }
        }];
    }
    else{
        NSError *error = nil;
        if (managedObjectContext != nil) {
            if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                abort();
            }
        }
    }
    //});
    //    }
    
}

@end
