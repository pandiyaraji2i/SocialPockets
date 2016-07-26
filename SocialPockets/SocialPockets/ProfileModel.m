//
//  ProfileModel.m
//  SocialPockets
//
//  Created by ideas2it-Kovendhan on 19/07/16.
//  Copyright © 2016 Pandiyaraj. All rights reserved.
//

#import "ProfileModel.h"
static ProfileModel* _sharedInstance = nil;


@implementation ProfileModel
/**
 *  Create Singleton instance of class
 *
 *  @return Self Class
 */
+ (ProfileModel *)sharedInstance
{
    @synchronized([ProfileModel class])
    {
        if (!_sharedInstance)
            _sharedInstance =  [[self alloc] init];
        
        return _sharedInstance;
    }
    
    return nil;
}

/**
 *  Update Profile Data
 *
 *  @param name            name of the user
 *  @param userName        username
 *  @param email           email of the user
 *  @param phoneNumber     phone number of the user
 *  @param completionBlock response block
 */

-(void)updateUserProfileWithName:(NSString *)name username:(NSString *)userName email:(NSString *)email phoneNumber:(NSString *)phoneNumber completion:(void (^)(id obj))completionBlock
{
    NSMutableDictionary *dict = [@{@"id":[[NSUserDefaults standardUserDefaults] valueForKey:@"userid"],@"name":name,@"username":userName,@"email":email,@"phone":phoneNumber} mutableCopy];
    id successObject = [NetworkHelperClass sendSynchronousRequestToServer:@"userregistration/updateProfile" httpMethod:POST requestBody:dict contentType:JSONCONTENTTYPE];
    if (successObject) {
        if (completionBlock) {
            completionBlock(successObject);
        }
    }

}

/**
 *  Check the eligibility status of the user
 *
 *  @param userId          id of the user
 *  @param completionBlock response block
 */
-(void)eligibityForUserId:(NSString *)userId completion:(void (^)(id obj))completionBlock
{
    if ([NetworkHelperClass getInternetStatus:YES]) {
        NSMutableDictionary *dict = [@{@"id":userId} mutableCopy];
        id successObject = [NetworkHelperClass sendSynchronousRequestToServer:@"loanrequest/checkEligibilityStatus" httpMethod:POST requestBody:dict contentType:JSONCONTENTTYPE];
        if (successObject) {
            if (completionBlock) {
                completionBlock(successObject);
            }
        }
    }
    else{
        if (completionBlock) {
            completionBlock(nil);
        }
    }

}


/**
 *  Change password
 *
 *  @param oldPassword     Old Password
 *  @param newPassword     New Password
 *  @param completionBlock response based on server either success or failure
 */
-(void)changePassword:(NSString *)oldPassword newPassword:(NSString *)newPassword completion:(void (^)(id obj))completionBlock
{
    
    if ([NetworkHelperClass getInternetStatus:YES])
    {
        NSMutableDictionary *dict = [@{@"userid":[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"],@"old_password":oldPassword,@"new_password":newPassword} mutableCopy];
        id successObject = [NetworkHelperClass sendSynchronousRequestToServer:@"/userregistration/changePassword" httpMethod:POST requestBody:dict contentType:JSONCONTENTTYPE];
        if (successObject) {
            if (completionBlock) {
                completionBlock(successObject);
            }
        }
    }
    else{
        if (completionBlock) {
            completionBlock(nil);
        }
    }
}



@end
