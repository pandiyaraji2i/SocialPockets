//
//  ProfileModel.h
//  SocialPockets
//
//  Created by ideas2it-Kovendhan on 19/07/16.
//  Copyright © 2016 Pandiyaraj. All rights reserved.
//

#import <Foundation/Foundation.h>
#define PROFILEMACRO [ProfileModel sharedInstance]

@interface ProfileModel : NSObject
+ (ProfileModel *)sharedInstance;

- (void)getUserInformation:(void(^)(id obj))completionBlock;
- (void)getUserCreditScore:(void(^)(id obj))completionBlock;

- (void)updateUserProfileWithName:(NSString *)name username:(NSString *)userName email:(NSString *)email phoneNumber:(NSString *)phoneNumber completion:(void (^)(id obj))completionBlock;

- (void)changePassword:(NSString *)oldPassword newPassword:(NSString *)newPassword completion:(void (^)(id obj))completionBlock;

- (void)passWordValidation:(NSString *)passWord completion:(void(^)(id obj))completionBlock;

- (void)saveCreditScore:(NSDictionary *)dict completion:(void(^)(id obj))completionBlock;
@end
