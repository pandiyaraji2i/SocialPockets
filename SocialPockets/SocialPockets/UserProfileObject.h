//
//  UserProfileObject.h
//  SocialPockets
//
//  Created by Pandiyaraj on 11/08/16.
//  Copyright © 2016 Pandiyaraj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserDetails.h"
#define DBPROFILE [UserProfileObject sharedProfile]
#define USERINFO [DBPROFILE userInfo]

@interface UserProfileObject : NSObject
@property (nonatomic,strong) UserDetails *userInfo;
+ (UserProfileObject *)sharedProfile;
- (void)clearForNewUser;
- (void)generateUserInfo:(NSDictionary*)userDictionary forUser:(NSString*)userId;
- (void)uploadImage:(UIImage *)image objectId:(NSManagedObjectID *)objectId withCompletionBlock:(void(^)(void))completionBlock;
- (void)downloadImage;
- (UIImage *)getImageForUser;
@end
