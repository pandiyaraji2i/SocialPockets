//
//  RegistrationModel.m
//  SocialPockets
//
//  Created by ideas2it-Kovendhan on 19/07/16.
//  Copyright © 2016 Pandiyaraj. All rights reserved.
//

#import "RegistrationModel.h"
static RegistrationModel* _sharedInstance = nil;

@implementation RegistrationModel
/**
 *  Create Singleton instance of class
 *
 *  @return Self Class
 */
+ (RegistrationModel *)sharedInstance
{
    @synchronized([RegistrationModel class])
    {
        if (!_sharedInstance)
            _sharedInstance =  [[self alloc] init];
        
        return _sharedInstance;
    }
    
    return nil;
}

/**
 *  Register a new user
 *
 *  @param username        entered username
 *  @param email           entered email
 *  @param password        entered password
 *  @param phoneNumber     entered phonenumber
 *  @param completionBlock response based on server either success or failure
 */
-(void)registerWithName:(NSString *)name userName:(NSString *)username email:(NSString *)email password:(NSString *)password phoneNumber:(NSString *)phoneNumber completion:(void (^)(id obj))completionBlock
{
    if ([NetworkHelperClass getInternetStatus:YES]) {
        NSMutableDictionary *dict = [@{@"id":[NSNull null],@"name":name,@"username":username,@"email":email,@"password":password,@"phone":phoneNumber} mutableCopy];
        id successObject = [NetworkHelperClass sendSynchronousRequestToServer:@"/userregistration" httpMethod:POST requestBody:dict contentType:JSONCONTENTTYPE];
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
 *  creation of OTP
 *
 *  @param userId          id of the user
 *  @param phoneNumber     phonenumber of the user
 *  @param createdby       created by
 *  @param completionBlock response block
 */
-(void)createOTPForPhoneNumber:(NSString *)phoneNumber  createdBy:(NSString *)createdby completion:(void (^)(id obj))completionBlock{
    if ([NetworkHelperClass getInternetStatus:YES]) {
        NSMutableDictionary *dict = [@{@"user_id":[[NSUserDefaults standardUserDefaults] valueForKey:USERID],@"phone":phoneNumber,@"created_by":createdby} mutableCopy];
        id successObject = [NetworkHelperClass sendSynchronousRequestToServer:@"createotp" httpMethod:POST requestBody:dict contentType:JSONCONTENTTYPE];
        if (successObject) {
            if (completionBlock) {
                completionBlock(successObject);
            }
        }
    }
}
/**
 *  verify OTP
 *
 *  @param userId          id of the user
 *  @param phoneNumber     phone number of the user
 *  @param generatedcode   OTP received by the user
 *  @param completionBlock response block
 */
-(void)verifyOTPForPhoneNumber:(NSString *)phoneNumber  generatedCode:(NSString *)generatedcode completion:(void (^)(id obj))completionBlock{
    if ([NetworkHelperClass getInternetStatus:YES]) {
        NSMutableDictionary *dict = [@{@"user_id":[[NSUserDefaults standardUserDefaults] valueForKey:USERID],@"phone":phoneNumber,@"generated_code":generatedcode} mutableCopy];
        id successObject = [NetworkHelperClass sendSynchronousRequestToServer:@"verifyotp" httpMethod:POST requestBody:dict contentType:JSONCONTENTTYPE];
        if (successObject) {
            if (completionBlock) {
                completionBlock(successObject);
            }
        }
    }
  
}

/**
 *  Resend OTP
 *
 *  @param userId          id of the user
 *  @param phoneNumber     phonenumber of the user
 *  @param createdby       created by
 *  @param completionBlock response block
 */
-(void)resendOTPForPhoneNumber:(NSString *)phoneNumber  createdBy:(NSString *)createdby completion:(void (^)(id obj))completionBlock{
    if ([NetworkHelperClass getInternetStatus:YES]) {
        NSMutableDictionary *dict = [@{@"user_id":[[NSUserDefaults standardUserDefaults] valueForKey:USERID],@"phone":phoneNumber,@"created_by":createdby} mutableCopy];
        id successObject = [NetworkHelperClass sendSynchronousRequestToServer:@"resendotp" httpMethod:POST requestBody:dict contentType:JSONCONTENTTYPE];
        if (successObject) {
            if (completionBlock) {
                completionBlock(successObject);
            }
        }
    }
    
}

/**
 *  Verify Pan Number
 *
 *  @param panNumber       pan Number
 *  @param completionBlock response block
 */
- (void)verifyPANNumber:(NSString *)panNumber completion:(void(^)(id obj))completionBlock
{
    if ([NetworkHelperClass getInternetStatus:YES]) {
        NSMutableDictionary *dict = [@{@"panno":panNumber} mutableCopy];
        id successObject = [NetworkHelperClass sendSynchronousRequestToServer:@"userregistration/pannoVerification" httpMethod:POST requestBody:dict contentType:JSONCONTENTTYPE];
        if (successObject) {
            if (completionBlock) {
                completionBlock(successObject);
            }
        }
    }
}


/**
 *  Verify Aaadhar Number
 *
 *  @param aadharNumber    aadhar Number
 *  @param enrollNo        Enrollment Number
 *  @param name            name
 *  @param address         address
 *  @param completionBlock response block
 */
- (void)verifyAaadharNumber:(NSString *)aadharNumber enrollmentNumber:(NSString *)enrollNo name:(NSString *)name address:(NSString *)address completion:(void(^)(id obj))completionBlock
{
    if ([NetworkHelperClass getInternetStatus:YES]) {
        NSMutableDictionary *dict = [@{@"aadhaar_name":name,@"aadhaar_enrollno":enrollNo,@"aadhaar_no":aadharNumber,@"aadhaar_address":address} mutableCopy];
        id successObject = [NetworkHelperClass sendSynchronousRequestToServer:@"userregistration/adhaarVerification" httpMethod:POST requestBody:dict contentType:JSONCONTENTTYPE];
        if (successObject) {
            if (completionBlock) {
                completionBlock(successObject);
            }
        }
    }
}
@end
