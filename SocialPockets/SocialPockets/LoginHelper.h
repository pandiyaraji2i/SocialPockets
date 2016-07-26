//
//  LoginHelper.h
//  SocialPockets
//
//  Created by Pandiyaraj on 19/07/16.
//  Copyright © 2016 Pandiyaraj. All rights reserved.
//

#import <Foundation/Foundation.h>
#define LOGINMACRO [LoginHelper sharedInstance]

@interface LoginHelper : NSObject

+ (LoginHelper *)sharedInstance;
- (void)validateUser:(NSString *)userName password:(NSString *)password completion:(void (^)(id obj))completionBlock;
- (void)forgotPasswordForUser:(NSString *)userName  completion:(void (^)(id obj))completionBlock;
- (void)sendPushAccessTokenToServer:(NSString *)pushAccessToken deviceId:(NSString *)deviceId compleiton:(void(^)(id obj))completionBlock;

@end
