//
//  SocialHelper.m
//  SocialPockets
//
//  Created by ideas2it-Kovendhan on 21/07/16.
//  Copyright © 2016 Pandiyaraj. All rights reserved.
//

#import "SocialHelper.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <TwitterKit/TwitterKit.h>
static SocialHelper* _sharedInstance = nil;

@implementation SocialHelper

/**
 *  Create Singleton instance of class
 *
 *  @return Self Class
 */
+ (SocialHelper *)sharedInstance
{
    @synchronized([SocialHelper class])
    {
        if (!_sharedInstance)
            _sharedInstance =  [[self alloc] init];
        
        return _sharedInstance;
    }
    
    return nil;
}

#warning Need to remove this code.
- (void)createCreditScore:(void(^)(id obj))completionBlock
{
    if ([NetworkHelperClass getInternetStatus:NO]) {
        
        NSMutableDictionary *dict = [@{@"user_id":@"16",@"credit_score":@"99s",@"status":@"0",@"created_by":@"4",@"modified_by":@"3"} mutableCopy];
        id successObject = [NetworkHelperClass sendSynchronousRequestToServer:@"creditsave" httpMethod:POST requestBody:dict contentType:JSONCONTENTTYPE];
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
 *  create social site for userId
 *
 *  @param userId          id  of the user
 *  @param socialId        social id of the user
 *  @param details         details
 *  @param createdBy       created by
 *  @param completionBlock response block
 */
- (void)createSocialSite:(NSString *)socialId details:(NSString*)details createdBy:(NSString *)createdBy completion:(void (^)(id obj))completionBlock
{
    if ([NetworkHelperClass getInternetStatus:YES]) {
         NSMutableDictionary *dict = [@{@"user_id":[[NSUserDefaults standardUserDefaults] valueForKey:USERID],@"social_id":socialId,@"details":details,@"created_by":createdBy} mutableCopy];
//        NSMutableDictionary *dict = [@{@"user_id":[[NSUserDefaults standardUserDefaults]valueForKey:@"userid"],@"social_id":socialId,@"details":details,@"created_by":createdBy} mutableCopy];
        id successObject = [NetworkHelperClass sendSynchronousRequestToServer:@"createsocialsites" httpMethod:POST requestBody:dict contentType:JSONCONTENTTYPE];
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
 *  update socialsites for the userId
 *
 *  @param userId          id of the user
 *  @param socId           socid
 *  @param socialId        id of the social sites
 *  @param details         details
 *  @param modifiedBy      mdified By
 *  @param completionBlock response block
 */
- (void)updateSocialSite:(NSString *)socId socialId:(NSString *)socialId details:(NSString*)details modifiedBy:(NSString *)modifiedBy completion:(void (^)(id obj))completionBlock
{
    if ([NetworkHelperClass getInternetStatus:YES]) {
        NSMutableDictionary *dict = [@{@"user_id":[[NSUserDefaults standardUserDefaults]valueForKey:USERID],@"soc_id":socId,@"social_id":socialId,@"details":details,@"modified_by":modifiedBy} mutableCopy];
        id successObject = [NetworkHelperClass sendSynchronousRequestToServer:@"/updatesocialsites" httpMethod:POST requestBody:dict contentType:JSONCONTENTTYPE];
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
 *  View Social site
 *
 *  @param completionBlock response block
 */
- (void)viewSocialSiteWithCompletion:(void (^)(id obj))completionBlock
{
    if ([NetworkHelperClass getInternetStatus:YES]) {
        NSString *urlString = [NSString stringWithFormat:@"/viewsocialdetails?user_id=%@",[[NSUserDefaults standardUserDefaults] valueForKey:USERID]];
        id successObject = [NetworkHelperClass sendSynchronousRequestToServer:urlString httpMethod:GET requestBody:nil contentType:JSONCONTENTTYPE];
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

#pragma mark Helper Login Methods For Social Sites
#pragma mark FaceBook Methods

-(void)faceBookLoginButtonClickedWithCompletion:(void (^)(id obj))completionBlock
{
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions: @[@"public_profile"] fromViewController:[SharedMethods topMostController] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"Process error");
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
         } else {
             NSLog(@"Logged in");
             if (completionBlock) {
                 completionBlock(result);
             }
             //[self CreateSocialSiteWithSocialSite:@"1"];
         }
     }];
}

#pragma Twitter Methods

-(void)TwitterLoginBtnClickedWithCompletion:(void (^)(id obj))completionBlock{
    [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {
        if (session) {
            NSLog(@"signed in as %@", [session userName]);
            if (completionBlock) {
                completionBlock(session);
            }
            //[self CreateSocialSiteWithSocialSite:@"2"];
            
        } else {
            NSLog(@"error: %@", [error localizedDescription]);
        }
    }];
    
    
    // TODO: Change where the log in button is positioned in your view
    // logInButton.center = self.view.center;
    // [self.view addSubview:logInButton];
}



@end
