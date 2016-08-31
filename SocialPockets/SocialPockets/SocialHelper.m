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
#import <linkedin-sdk/LISDK.h>
#import "AppDelegate.h"


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

/**
 *  create social site for userId
 *
 *  @param userId          id  of the user
 *  @param socialId        social id of the user
 *  @param details         details
 *  @param createdBy       created by
 *  @param completionBlock response block
 */
- (void)createSocialSite:(NSString *)socialId details:(NSString*)details completion:(void (^)(id obj))completionBlock
{
    if ([NetworkHelperClass getInternetStatus:YES]) {
        NSMutableDictionary *dict = [@{@"user_id":USERINFO.userId,@"social_id":socialId,@"details":details,@"created_by":USERINFO.userId} mutableCopy];
        //        NSMutableDictionary *dict = [@{@"user_id":[[NSUserDefaults standardUserDefaults]valueForKey:@"userid"],@"social_id":socialId,@"details":details,@"created_by":createdBy} mutableCopy];
        [NetworkHelperClass sendAsynchronousRequestToServer:@"createsocialsites" httpMethod:POST requestBody:dict contentType:JSONCONTENTTYPE completion:^(id obj) {
            if (completionBlock) {
                completionBlock(obj);
            }
        }];
       /* id successObject = [NetworkHelperClass sendSynchronousRequestToServer:@"createsocialsites" httpMethod:POST requestBody:dict contentType:JSONCONTENTTYPE];
        if (successObject) {
            if (completionBlock) {
                completionBlock(successObject);
            }
        }*/
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

- (void)facebookLoginWithCompletion:(void (^)(id obj))completionBlock
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

- (void)twitterLoginWithCompletion:(void (^)(id obj))completionBlock{
    [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {
        if (session) {
            NSLog(@"signed in as %@", [session userName]);
            [[NSUserDefaults standardUserDefaults] setObject:[session authTokenSecret] forKey:@"TwitterAccessToken"];
//            if (![[NSUserDefaults standardUserDefaults] boolForKey:@"TwitterLoggedIn"]) {
//                [SOCIALMACRO createSocialSite:TWITTER_ID details:@"Twitter" completion:^(id obj) {
//                    [self getTwitterListFor:@"friendsList" WIthUserID:[session userID]];
//                }];
//            }else{
                [self getTwitterListFor:@"friendsList" WIthUserID:[session userID]];
//            }
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"TwitterLoggedIn"];
            if (completionBlock) {
                completionBlock(session);
            }
            
        } else {
            NSLog(@"error: %@", [error localizedDescription]);
            if (completionBlock) {
                completionBlock(nil);
            }
        }
    }];
}

#pragma mark Instagram Methods
- (void)instagramLoginWithUserToken:(id)token WithCompletion:(void (^)(id obj))completionBlock
{
    if ([NetworkHelperClass getInternetStatus:YES]) {
        NSString *urlString = [NSString stringWithFormat:@"%@%@",INSTAGRAM_FETCHURL,token];
        [NetworkHelperClass sendAsynchronousRequestToServer:urlString httpMethod:GET requestBody:nil contentType:JSONCONTENTTYPE completion:^(id obj) {
            if(completionBlock){
                completionBlock(obj);
            }
        }];
    }else{
        if (completionBlock) {
            completionBlock(nil);
        }
    }
}

#pragma mark LinkedIn Methods

- (void)linkedInLoginWithCompletion:(void (^)(id obj))completionBlock
{
    __block NSString *reqURL = [NSString stringWithFormat:@"https://www.linkedin.com/v1/people/~:(id,first-name,last-name,headline,num-connections,picture-url,industry,summary,specialties,positions:(id,title,summary,start-date,end-date,is-current,company:(id,name,type,size,industry,ticker)),skills:(id,skill:(name)),three-current-positions,three-past-positions,volunteer)?format=json"];
    [LISDKSessionManager createSessionWithAuth:[NSArray arrayWithObjects:LISDK_BASIC_PROFILE_PERMISSION,LISDK_EMAILADDRESS_PERMISSION,nil]
                                         state:@"some state"
                        showGoToAppStoreDialog:YES
                                  successBlock:^(NSString *returnState) {
                                      
                                      NSLog(@"%s","success called!");
                                      LISDKSession *session = [[LISDKSessionManager sharedInstance] session];
                                      NSString *authtoken = [[[LISDKSessionManager sharedInstance] session].accessToken accessTokenValue];
                                      NSLog(@"%@",authtoken);
                                      if(session)
                                      {
                                          [[LISDKAPIHelper sharedInstance] apiRequest:reqURL
                                                                               method:@"GET"
                                                                                 body:[@"" dataUsingEncoding:NSUTF8StringEncoding]
                                                                              success:^(LISDKAPIResponse *response) {
                                                                                  //NSLog(@"2nd success called %@", response.data);
                                                                                  if (completionBlock) {
                                                                                      completionBlock(response.data);
                                                                                  }
                                                                              }
                                                                                error:^(LISDKAPIError *apiError) {
                                                                                    if (completionBlock) {
                                                                                        completionBlock(nil);
                                                                                    }
                                                                                }];
                                      }
                                  }
                                    errorBlock:^(NSError *error) {
                                        NSLog(@"%s %@","error called! ", [error description]);
                                        if (completionBlock) {
                                            completionBlock(nil);
                                        }
                                        
                                    }
     ];
}


#pragma mark TWITTER FOLLOWERS LIST

# pragma Mark Get followers list

- (void)getTwitterListFor:(NSString *)list WIthUserID:(NSString *)userid
{
    NSString *statusesShowEndpoint;
    NSString *userDefaultsKey,*serverUserDefaultsKey;
    int updateFollower;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([list isEqualToString:@"friendsList"]) {
        statusesShowEndpoint = @"https://api.twitter.com/1.1/friends/ids.json?count=4999";
        userDefaultsKey = TWITTER_FRIENDS;
        serverUserDefaultsKey = TWITTER_NEW_FRIENDS;
        updateFollower = 1;
    }else if([list isEqualToString:@"followersList"]){
        statusesShowEndpoint = @"https://api.twitter.com/1.1/followers/ids.json?count=4999";
        userDefaultsKey = TWITTER_FOLLOWERS;
        serverUserDefaultsKey = TWITTER_NEW_FOLLOWERS;
        updateFollower = 2;
    }
    NSDictionary *params = @{@"id" : userid};
    NSError *clientError;
    TWTRAPIClient *client = [[TWTRAPIClient alloc] initWithUserID:userid];
    NSURLRequest *request = [client URLRequestWithMethod:@"GET" URL:statusesShowEndpoint parameters:params error:&clientError];
    // if (request) {
    [client sendTwitterRequest:request completion:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data) {
            NSError *jsonError;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            NSInteger twitterFriendsCount = [[json valueForKey:@"ids"] count];
            NSInteger   serverSentValue  =0;
            if ([userDefaults integerForKey:userDefaultsKey]) {
                NSInteger oldValue = [userDefaults integerForKey:userDefaultsKey];
                serverSentValue = twitterFriendsCount - oldValue;
                if (serverSentValue>0) {
                    //server API call
                    [userDefaults setInteger:twitterFriendsCount forKey:userDefaultsKey];
                    [userDefaults setInteger:serverSentValue forKey:serverUserDefaultsKey];
                }else{
                    [userDefaults setInteger:serverSentValue forKey:serverUserDefaultsKey];
                }
            }else{
                //API call with twitter friends Count
                [userDefaults setInteger:serverSentValue forKey:serverUserDefaultsKey];
                [userDefaults setInteger:twitterFriendsCount forKey:userDefaultsKey];
            }
            [userDefaults synchronize];
            
            if (updateFollower == 1) {
                [self getTwitterListFor:@"followersList" WIthUserID:userid];
            }else{
                [self saveCreditScore:2];
            }
        }
        else {
            NSLog(@"Error: %@", connectionError);
        }
    }];
}

/**
 *  save and send credit score to server
 *
 *  @param socialMediaType social media type 1 - Facebook, 2 -  Twitter , 3 - Instagram , 4 - Linkedin
 */
- (void)saveCreditScore:(int)socialMediaType
{
    NSMutableDictionary *dict = [@{@"user_id":USERINFO.userId,@"modified_by":USERINFO.userId,@"created_by":USERINFO.userId} mutableCopy];
    NSMutableDictionary *socialDict;
    NSString *socialKey;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    switch (socialMediaType) {
        case 1:
        {
            socialDict = [@{@"photolikes":[NSNumber numberWithInt:10],@"photocomments":[NSNumber numberWithInt:15],@"newfriends":[NSNumber numberWithInt:15],@"newallpost":[NSNumber numberWithInt:15]}mutableCopy];
            socialKey = @"facebook";
            break;
        }
        case 2:
        {
            socialDict = [@{@"newfriends":[NSNumber numberWithInteger:[userDefaults integerForKey:TWITTER_NEW_FRIENDS]],@"newfollowers":[NSNumber numberWithInteger:[userDefaults integerForKey:TWITTER_NEW_FOLLOWERS]]}mutableCopy];
            socialKey = @"twitter";
            break;
        }
        case 3:
        {
            socialDict = [@{@"newfollowers":[NSNumber numberWithInt:10],@"photolikes":[NSNumber numberWithInt:15],@"photocomments":[NSNumber numberWithInt:15]}mutableCopy];
            socialKey = @"instagram";
            break;
        }
        case 4:
        {
            socialDict = [@{@"totalconnection":[NSNumber numberWithInt:10],@"jobs":[NSNumber numberWithInt:15]}mutableCopy];
            socialKey = @"linkedin";
            break;
        }
        default:
            break;
    }
    [dict setValue:socialDict forKey:socialKey];
    [PROFILEMACRO saveCreditScore:dict completion:^(id obj) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            //#-- send post notification to update credit score
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
        }else{
            
        }
    }];
}


@end
