//
//  SocialHelper.h
//  SocialPockets
//
//  Created by ideas2it-Kovendhan on 21/07/16.
//  Copyright © 2016 Pandiyaraj. All rights reserved.
//

#import <Foundation/Foundation.h>
#define SOCIALMACRO [SocialHelper sharedInstance]

@interface SocialHelper : NSObject
+ (SocialHelper *)sharedInstance;


- (void)createSocialSite:(NSString *)socialId details:(NSString*)details createdBy:(NSString *)createdBy completion:(void (^)(id obj))completionBlock;

- (void)updateSocialSite:(NSString *)socId socialId:(NSString *)socialId details:(NSString*)details modifiedBy:(NSString *)modifiedBy completion:(void (^)(id obj))completionBlock;

- (void)viewSocialSiteWithCompletion:(void (^)(id obj))completionBlock;

- (void)facebookLoginWithCompletion:(void (^)(id obj))completionBlock;
- (void)twitterLoginWithCompletion:(void (^)(id obj))completionBlock;
- (void)linkedInLoginWithCompletion:(void (^)(id obj))completionBlock;
- (void)instagramLoginWithUserToken:(id)token WithCompletion:(void (^)(id obj))completionBlock;
- (void)getTwitterListFor:(NSString *)list WIthUserID:(NSString *)userid;
@end
