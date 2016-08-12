//
//  LoginHelper.m
//  SocialPockets
//
//  Created by Pandiyaraj on 19/07/16.
//  Copyright © 2016 Pandiyaraj. All rights reserved.
//

#import "LoginHelper.h"
static LoginHelper* _sharedInstance = nil;

@implementation LoginHelper

/**
 *  Create Singleton instance of class
 *
 *  @return Self Class
 */
+ (LoginHelper *)sharedInstance
{
    @synchronized([LoginHelper class])
    {
        if (!_sharedInstance)
            _sharedInstance =  [[self alloc] init];
        
        return _sharedInstance;
    }
    
    return nil;
}


/**
 *  Validating user with server
 *  @param userName        Entered Username
 *  @param password        Entered Password
 *  @param completionBlock response based on server either success or failure
 */
- (void)validateUser:(NSString *)userName password:(NSString *)password completion:(void (^)(id obj))completionBlock
{
    if ([NetworkHelperClass getInternetStatus:YES]) {
        NSMutableDictionary *dict = [@{@"username":userName,@"password":password} mutableCopy];
        id successObject = [NetworkHelperClass sendSynchronousRequestToServer:@"userregistration/login" httpMethod:POST requestBody:dict contentType:JSONCONTENTTYPE];
        if (successObject) {
            if (completionBlock) {
                completionBlock(successObject);
            }
        }
    }else{
        if (completionBlock) {
            completionBlock(nil);
        }
    }
}

/**
 *  Forgot password
 *
 *  @param userName        logged username
 *  @param completionBlock response based on server either success or failure
 */
-(void)forgotPasswordForUser:(NSString *)userName completion:(void (^)(id obj))completionBlock
{
    if ([NetworkHelperClass getInternetStatus:YES]) {
        NSMutableDictionary *dict = [@{@"username":userName} mutableCopy];
        id successObject = [NetworkHelperClass sendSynchronousRequestToServer:@"/userregistration/getForgetPassword" httpMethod:POST requestBody:dict contentType:JSONCONTENTTYPE];
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
 *  To Set Device Token & Device ID for the user
 *
 *  @param userId          User id
 *  @param completionBlock sends the device id and token in the serverfor userid
 */
- (void)setDeviceForId:(NSString *)userId completion:(void (^)(id obj))completionBlock
{
    if ([NetworkHelperClass getInternetStatus:YES]) {
        
        NSString *appDeviceToken = NULL_TO_NIL([[NSUserDefaults standardUserDefaults] objectForKey:@"appDeviceToken"]);
        NSString *deviceId = NULL_TO_NIL([[NSUserDefaults standardUserDefaults] objectForKey:@"deviceId"]);
        
        NSMutableDictionary *dict = [@{@"user_id":userId,@"device_type":@"1",@"device_id":(deviceId.length)?deviceId:@"",@"device_status":@"1",@"device_token":(appDeviceToken.length)?appDeviceToken:@"",@"created_by":userId,@"modified_by":userId} mutableCopy];
        [NetworkHelperClass sendAsynchronousRequestToServer:@"createdevice" httpMethod:POST requestBody:dict contentType:JSONCONTENTTYPE completion:^(id obj) {
            if (completionBlock) {
                completionBlock(obj);
            }
        }];
//        id successObject = [NetworkHelperClass sendSynchronousRequestToServer:@"createdevice" httpMethod:POST requestBody:dict contentType:JSONCONTENTTYPE];
//        if (successObject) {
//            if (completionBlock) {
//                completionBlock(successObject);
//            }
//        }
    }
    else{
        if (completionBlock) {
            completionBlock(nil);
        }
    }
}

/**
 *  Send Push Access token to server For PUSH NOTIFICAITONS
 *
 *  @param pushAccessToken push token from APNS
 *  @param deviceId        device id
 *  @param completionBlock response block
 */
- (void)sendPushAccessTokenToServer:(NSString *)pushAccessToken deviceId:(NSString *)deviceId compleiton:(void(^)(id obj))completionBlock{
    
}


@end
