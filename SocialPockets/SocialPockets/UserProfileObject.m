//
//  UserProfileObject.m
//  SocialPockets
//
//  Created by Pandiyaraj on 11/08/16.
//  Copyright © 2016 Pandiyaraj. All rights reserved.
//

#import "UserProfileObject.h"

@implementation UserProfileObject
@synthesize userInfo = _userInfo;

+ (UserProfileObject *)sharedProfile
{
    @synchronized([UserProfileObject class])
    {
        static UserProfileObject *_sharedProfile;
        if (!_sharedProfile)
        {
            _sharedProfile=[[UserProfileObject alloc] init];
        }
        return _sharedProfile;
    }
    return nil;
}

-(UserDetails*)userInfo {
    if (_userInfo) {
        return _userInfo;
    }
    NSArray *userArr=[DatabaseObject dbQuery:@"UserDetails" withWhere:nil andSortKey:nil andSortAscending:YES];
    if (userArr.count) {
        _userInfo=userArr[0];
        [DATABASE.childManagedObjectContext reset];
        return _userInfo;
    }
    _userInfo = [NSEntityDescription insertNewObjectForEntityForName:@"UserDetails" inManagedObjectContext:DATABASE.managedObjectContext];
    [DATABASE dbSaveRecordContext];
    [DATABASE.childManagedObjectContext reset];
    return _userInfo;
}

-(void)clearForNewUser {
    //Clear all group agenda calendar from previous user
    if (USERINFO.userId.length) {
        [[NSFileManager defaultManager] removeItemAtPath:DOCUMENT_DIRECTORY_WITHPATH(USERINFO.userId) error:nil];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)generateUserInfo:(NSDictionary*)userDictionary forUser:(NSString*)userId{
    if (USERINFO.userId) {
        if (![USERINFO.userId isEqualToString:userId]) {
            [self clearForNewUser];
            [DATABASE.managedObjectContext deleteObject:self.userInfo];
            _userInfo=nil;
            [DATABASE dbSaveRecordContext];
        }
    }
    NSManagedObjectContext *profileContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [profileContext performBlockAndWait:^{
        profileContext.parentContext = DATABASE.managedObjectContext;
        UserDetails *tempUser = (id)[profileContext objectWithID:USERINFO.objectID];
        tempUser.userId=userId;
        [self updateUserInfo:userDictionary forUser:tempUser];
    }];
}

- (void)updateUserInfo:(NSDictionary*)userDictionary forUser:(UserDetails*)tempUserInfo {
    NSArray *userKeys = [[tempUserInfo.entity attributesByName] allKeys];
    for (id key in userKeys) {
        NSString *keyValue = key;
         if ([userDictionary valueForKey:[keyValue uppercaseString]]) {
             [tempUserInfo setValue:NULL_TO_NIL([userDictionary valueForKey:[keyValue uppercaseString]]) forKey:keyValue];
         }
    }
    [DATABASE dbSaveRecordChildContext:tempUserInfo.managedObjectContext];
}

@end
