//
//  RegistrationModel.h
//  SocialPockets
//
//  Created by ideas2it-Kovendhan on 19/07/16.
//  Copyright © 2016 Pandiyaraj. All rights reserved.
//

#import <Foundation/Foundation.h>
#define REGMACRO [RegistrationModel sharedInstance]

@interface RegistrationModel : NSObject
+ (RegistrationModel *)sharedInstance;

-(void)registerWithName:(NSString *)name userName:(NSString *)username email:(NSString *)email password:(NSString *)password phoneNumber:(NSString *)phoneNumber completion:(void (^)(id obj))completionBlock;

- (void)createOTPForPhoneNumber:(NSString *)phoneNumber  createdBy:(NSString *)createdby completion:(void (^)(id obj))completionBlock;

- (void)verifyOTPForPhoneNumber:(NSString *)phoneNumber  generatedCode:(NSString *)generatedcode completion:(void (^)(id obj))completionBlock;

- (void)resendOTPForPhoneNumber:(NSString *)phoneNumber  createdBy:(NSString *)createdby completion:(void (^)(id obj))completionBlock;

- (void)verifyPANNumber:(NSString *)panNumber completion:(void(^)(id obj))completionBlock;

- (void)verifyAaadharNumber:(NSString *)aadharNumber enrollmentNumber:(NSString *)enrollNo name:(NSString *)name address:(NSString *)address completion:(void(^)(id obj))completionBlock;
@end
