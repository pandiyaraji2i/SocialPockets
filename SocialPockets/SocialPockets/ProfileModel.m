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
 *  Get User Information
 *
 *  @param completionBlock response block
 */
- (void)getUserInformation:(void(^)(id obj))completionBlock
{
    if ([NetworkHelperClass getInternetStatus:NO]) {
        NSString *urlString = [NSString stringWithFormat:@"userregistration/%@",[[NSUserDefaults standardUserDefaults] valueForKey:USERID]];
        [NetworkHelperClass sendAsynchronousRequestToServer:urlString httpMethod:GET requestBody:nil contentType:JSONCONTENTTYPE completion:^(id obj) {
            if (completionBlock) {
                completionBlock(obj);
            }
            
        }];
    }
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
    NSMutableDictionary *dict = [@{@"id":[[NSUserDefaults standardUserDefaults] valueForKey:USERID],@"name":name,@"username":userName,@"email":email,@"phone":phoneNumber} mutableCopy];
    
    [NetworkHelperClass sendAsynchronousRequestToServer:@"userregistration/updateProfile" httpMethod:POST requestBody:dict contentType:JSONCONTENTTYPE completion:^(id obj) {
        if (completionBlock) {
            completionBlock(obj);
        }
    }];
   /* id successObject = [NetworkHelperClass sendSynchronousRequestToServer: httpMethod:POST requestBody:dict contentType:JSONCONTENTTYPE];
    if (successObject) {
        if (completionBlock) {
            completionBlock(successObject);
        }
    }*/

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
        NSMutableDictionary *dict = [@{@"userid":[[NSUserDefaults standardUserDefaults] valueForKey:USERID],@"old_password":oldPassword,@"new_password":newPassword} mutableCopy];
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

/**
 *  Password validation
 *
 *  @param passWord        password
 *  @param completionBlock response block
 */
- (void)passWordValidation:(NSString *)passWord completion:(void(^)(id obj))completionBlock{
    NSMutableDictionary *dict = [@{@"userid":[[NSUserDefaults standardUserDefaults] valueForKey:USERID],@"password":passWord} mutableCopy];
    id successObject = [NetworkHelperClass sendSynchronousRequestToServer:@"userregistration/passwordVerification" httpMethod:POST requestBody:dict contentType:JSONCONTENTTYPE];
    if (successObject) {
        if (completionBlock) {
            completionBlock(successObject);
        }
    }
}

#pragma mark credid score
/**
 *  Get user credit score
 *
 *  @param completionBlock response block
 */
- (void)getUserCreditScore:(void (^)(id))completionBlock
{
    NSString *urlString =[NSString stringWithFormat:@"getCreditScore?user_id=%@",[[NSUserDefaults standardUserDefaults] valueForKey:USERID]];
    [NetworkHelperClass sendAsynchronousRequestToServer:urlString httpMethod:GET requestBody:nil contentType:JSONCONTENTTYPE completion:^(id obj) {
        if (completionBlock) {
            completionBlock(obj);
        }
    }];
}

- (void)saveCreditScore:(NSDictionary *)dict completion:(void(^)(id obj))completionBlock
{
    [NetworkHelperClass sendAsynchronousRequestToServer:@"CalculateCreditScoreAlgorithm" httpMethod:POST requestBody:dict contentType:JSONCONTENTTYPE completion:^(id obj) {
        if (completionBlock) {
            completionBlock(obj);
        }
    }];
}


@end
