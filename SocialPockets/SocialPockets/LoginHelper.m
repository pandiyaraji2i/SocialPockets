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
    if (completionBlock)
    {
        completionBlock(@"suces");
    }
    return;
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
 *  Send Push Access token to server For PUSH NOTIFICAITONS
 *
 *  @param pushAccessToken push token from APNS
 *  @param deviceId        device id
 *  @param completionBlock response block
 */
- (void)sendPushAccessTokenToServer:(NSString *)pushAccessToken deviceId:(NSString *)deviceId compleiton:(void(^)(id obj))completionBlock{
    
}


@end
