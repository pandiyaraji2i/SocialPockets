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
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:FB_LIKES];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:FB_NEW_LIKES];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:FB_FRIENDS];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:FB_NEW_FRIENDS];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:FB_COMMENTS];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:FB_NEW_COMMENTS];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:FB_POSTS ];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:FB_NEW_POSTS];
    
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:TWITTER_FOLLOWERS];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:TWITTER_NEW_FOLLOWERS];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:TWITTER_FRIENDS];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:TWITTER_NEW_FRIENDS];
    
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:INSTAGRAM_FOLLOWERS];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:INSTAGRAM_NEW_FOLLOWERS];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:INSTAGRAM_FOLLOWEDBY];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:INSTAGRAM_NEW_FOLLOWEDBY];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:INSTAGRAM_COMMENTS];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:INSTAGRAM_NEW_COMMENTS];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:INSTAGRAM_LIKES];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:INSTAGRAM_NEW_LIKES];
    
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:LINKEDIN_JOBS];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:LINKEDIN_NEW_JOBS];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:LINKEDIN_CONNECTIONS];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:LINKEDIN_NEW_CONNECTIONS];
        
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
        if ([key isEqualToString:@"local_file_name"]) {
            [tempUserInfo setValue:NULL_TO_NIL([userDictionary valueForKey:@"USER_PROFILE_FILENAME"]) forKey:keyValue];
        }
    }
    [DATABASE dbSaveRecordChildContext:tempUserInfo.managedObjectContext];
}

- (void)uploadImage:(UIImage *)image objectId:(NSManagedObjectID *)objectId withCompletionBlock:(void(^)(void))completionBlock
{
    UserDetails *userObj = (id)[DATABASE.managedObjectContext objectWithID:objectId];
    [NetworkHelperClass uploadImage:image isUserOrLoan:1 userId:USERINFO.userId sync:NO completion:^(id obj) {
        if ([obj isKindOfClass:[NSDictionary class]])
        {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                [self generateUserInfo:obj forUser:userObj.userId];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadAccountScreen" object:nil];
            });
        }
        if (completionBlock) {
            completionBlock ();
        }
    }];
}


- (void)downloadImage
{
    if (USERINFO.user_profile_filename.length) {
        __strong  NSManagedObjectID *objectId = USERINFO.objectID;
        NSString *fileName = [NSString stringWithFormat:@"http://128.199.150.145:8000/assets/uploads/profile/%@",USERINFO.user_profile_filename];
        [NetworkHelperClass downloadImage:[NSURL URLWithString:fileName] withUserId:USERINFO.userId completionBlock:^(id obj) {
            if (obj) {
                NSManagedObjectContext *saveContext = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSPrivateQueueConcurrencyType];
                [saveContext performBlockAndWait:^{
                    saveContext.parentContext = DATABASE.managedObjectContext;
                    UserDetails *tempDetails = (id)[saveContext objectWithID:objectId];
                    tempDetails.localImagePath = obj;
                    [DATABASE dbSaveRecordChildContext:saveContext];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadAccountScreen" object:nil];
                }];
            }
        }];
    }
}

- (UIImage *)getImageForUser
{
    if (USERINFO.localImagePath != nil) {
        return [UIImage imageWithData:USERINFO.localImagePath];
    }else{
        return [UIImage imageNamed:@"ProfileImage"];
    }
}
@end
