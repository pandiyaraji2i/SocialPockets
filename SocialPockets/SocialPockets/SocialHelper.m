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
            [[NSUserDefaults standardUserDefaults] setObject:[[result token] tokenString] forKey:@"FacebookAccessToken"];
            
            //                        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"FacebookLoggedIn"]) {
            //                            [SOCIALMACRO createSocialSite:FACEBOOK_ID details:@"Facebook" completion:^(id obj) {
            //                                [self getFaceBookDetails];
            //                            }];
            //                        }else{
            //                            [self getFaceBookDetails];
            //            }
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FacebookLoggedIn"];
            
            [self getFaceBookDetails];
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
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            
            //code to get followedBy count
            NSInteger followedByCount = [[NSString stringWithFormat:@"%@",[[[obj objectForKey:@"data"] objectForKey:@"counts"]objectForKey:@"followed_by"]] integerValue];
            
            NSInteger  serverSentfollowedByCount = 0;
            
            //code for likes Count
            if ([userDefaults integerForKey:INSTAGRAM_FOLLOWEDBY]>0) {
                NSInteger oldValue = [[NSUserDefaults standardUserDefaults] integerForKey:INSTAGRAM_FOLLOWEDBY];
                serverSentfollowedByCount = followedByCount - oldValue;
                if (serverSentfollowedByCount>0) {
                    [userDefaults setInteger:followedByCount forKey:INSTAGRAM_FOLLOWEDBY];
                    [userDefaults setInteger:serverSentfollowedByCount forKey:INSTAGRAM_NEW_FOLLOWEDBY];
                }else{
                    [userDefaults setInteger:serverSentfollowedByCount forKey:INSTAGRAM_NEW_FOLLOWEDBY];
                }
            }else{
                serverSentfollowedByCount = followedByCount;
                [userDefaults setInteger:followedByCount forKey:INSTAGRAM_FOLLOWEDBY];
                [userDefaults setInteger:serverSentfollowedByCount forKey:INSTAGRAM_NEW_FOLLOWEDBY];
                
            }
            [userDefaults synchronize];
            
            //code to get follows count
            NSInteger followsCount = [[NSString stringWithFormat:@"%@",[[[obj objectForKey:@"data"] objectForKey:@"counts"]objectForKey:@"follows"]] integerValue];
            
            NSInteger  serverSentfollowsCount = 0;
            
            //code for Follows Count
            if ([userDefaults integerForKey:INSTAGRAM_FOLLOWERS]>0) {
                NSInteger oldValue = [[NSUserDefaults standardUserDefaults] integerForKey:INSTAGRAM_FOLLOWERS];
                serverSentfollowsCount = followsCount - oldValue;
                if (serverSentfollowsCount>0) {
                    [userDefaults setInteger:followsCount forKey:INSTAGRAM_FOLLOWERS];
                    [userDefaults setInteger:serverSentfollowsCount forKey:INSTAGRAM_NEW_FOLLOWERS];
                }else{
                    [userDefaults setInteger:serverSentfollowsCount forKey:INSTAGRAM_NEW_FOLLOWERS];
                }
            }else{
                serverSentfollowsCount = followsCount;
                [userDefaults setInteger:followsCount forKey:INSTAGRAM_FOLLOWERS];
                [userDefaults setInteger:serverSentfollowsCount forKey:INSTAGRAM_NEW_FOLLOWERS];
            }
            [userDefaults synchronize];
            
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

- (void)instagramDetailWithUserToken:(id)token WithCompletion:(void (^)(id obj))completionBlock
{
    if ([NetworkHelperClass getInternetStatus:YES]) {
        NSString *urlString = [NSString stringWithFormat:@"%@%@",INSTAGRAM_DETAILURL,token];
        [NetworkHelperClass sendAsynchronousRequestToServer:urlString httpMethod:GET requestBody:nil contentType:JSONCONTENTTYPE completion:^(id obj) {
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSArray *aray = [obj valueForKey:@"data"];
            if(aray){
                
                id recentObj = aray[0];
                
                //code to get comments count
                NSInteger commentsCount = [[NSString stringWithFormat:@"%@",[[recentObj valueForKey:@"comments"]valueForKey:@"count"]] integerValue];
                
                NSInteger  serverSentCommentsCount = 0;
                
                //code for comments Count
                if ([userDefaults integerForKey:INSTAGRAM_COMMENTS]>0) {
                    NSInteger oldValue = [[NSUserDefaults standardUserDefaults] integerForKey:INSTAGRAM_COMMENTS];
                    serverSentCommentsCount = commentsCount - oldValue;
                    if (serverSentCommentsCount>0) {
                        [userDefaults setInteger:commentsCount forKey:INSTAGRAM_COMMENTS];
                        [userDefaults setInteger:serverSentCommentsCount forKey:INSTAGRAM_NEW_COMMENTS];
                    }else{
                        [userDefaults setInteger:serverSentCommentsCount forKey:INSTAGRAM_NEW_COMMENTS];
                    }
                }else{
                    serverSentCommentsCount = commentsCount;
                    [userDefaults setInteger:commentsCount forKey:INSTAGRAM_COMMENTS];
                    [userDefaults setInteger:serverSentCommentsCount forKey:INSTAGRAM_NEW_COMMENTS];
                }
                [userDefaults synchronize];
                
                //code to get likes count
                NSInteger likesCount = [[NSString stringWithFormat:@"%@",[[recentObj valueForKey:@"likes"]valueForKey:@"count"]] integerValue];
                
                NSInteger  serverSentlikesCount = 0;
                
                //code for comments Count
                if ([userDefaults integerForKey:INSTAGRAM_LIKES]>0) {
                    NSInteger oldValue = [[NSUserDefaults standardUserDefaults] integerForKey:INSTAGRAM_LIKES];
                    serverSentlikesCount = likesCount - oldValue;
                    if (serverSentlikesCount>0) {
                        [userDefaults setInteger:likesCount forKey:INSTAGRAM_LIKES];
                        [userDefaults setInteger:serverSentlikesCount forKey:INSTAGRAM_NEW_LIKES];
                    }else{
                        [userDefaults setInteger:serverSentlikesCount forKey:INSTAGRAM_NEW_LIKES];
                    }
                }else{
                    serverSentlikesCount = likesCount;
                    [userDefaults setInteger:likesCount forKey:INSTAGRAM_LIKES];
                    [userDefaults setInteger:serverSentlikesCount forKey:INSTAGRAM_NEW_LIKES];
                }
                [userDefaults synchronize];
            }
            [self saveCreditScore:3];
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
    __block NSString *reqURL = [NSString stringWithFormat:@"https://api.linkedin.com/v1/people/~:(id,num-connections,picture-url,positions)?format=json"];
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
                                                                                  [[NSUserDefaults standardUserDefaults] setObject:authtoken forKey:@"LinkedInAccessToken"];
                                                                                  
                                                                                  
                                                                                  [self saveLinkedinConnections:response.data];
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

#pragma mark FACEBOOK LIST

-(void)getFaceBookDetails{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:@"/me"
                                  parameters:@{ @"fields": @"albums,friends,posts",}
                                  HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        
        //code to get friends count
        NSInteger friendsCount = [[[[result objectForKey:@"friends"] objectForKey:@"summary"] objectForKey:@"total_count"] intValue];
        
        NSInteger  serverSentFriendsCount = 0;
        
        //code for likes Count
        if ([userDefaults integerForKey:FB_FRIENDS]>0) {
            NSInteger oldValue = [[NSUserDefaults standardUserDefaults] integerForKey:FB_FRIENDS];
            serverSentFriendsCount = friendsCount - oldValue;
            if (serverSentFriendsCount>0) {
                //server API call
                [userDefaults setInteger:friendsCount forKey:FB_FRIENDS];
                [userDefaults setInteger:serverSentFriendsCount forKey:FB_NEW_FRIENDS];
            }else{
                [userDefaults setInteger:serverSentFriendsCount forKey:FB_NEW_FRIENDS];
            }
        }else{
            //API call with twitter friends Count
            serverSentFriendsCount = friendsCount;
            [userDefaults setInteger:friendsCount forKey:FB_FRIENDS];
            [userDefaults setInteger:serverSentFriendsCount forKey:FB_NEW_FRIENDS];
        }
        [userDefaults synchronize];
        
        
        //code to get posts count
        NSInteger postCount = [[[result objectForKey:@"posts"] objectForKey:@"data"] count];
        
        NSInteger  serverSentPostCount = 0;
        
        //code for likes Count
        if ([userDefaults integerForKey:FB_POSTS]>0) {
            NSInteger oldValue = [[NSUserDefaults standardUserDefaults] integerForKey:FB_POSTS];
            serverSentFriendsCount = friendsCount - oldValue;
            if (serverSentPostCount>0) {
                //server API call
                [userDefaults setInteger:postCount forKey:FB_POSTS];
                [userDefaults setInteger:serverSentPostCount forKey:FB_NEW_POSTS];
            }else{
                [userDefaults setInteger:serverSentPostCount forKey:FB_NEW_POSTS];
            }
        }else{
            //API call with twitter friends Count
            serverSentPostCount = postCount;
            [userDefaults setInteger:postCount forKey:FB_POSTS];
            [userDefaults setInteger:serverSentPostCount forKey:FB_NEW_POSTS];
        }
        [userDefaults synchronize];
        
        NSArray *dataArray = [[result objectForKey:@"albums"] objectForKey:@"data"];
        NSString *currentId;
        for (id item in dataArray) {
            if ([[item objectForKey:@"name"] isEqualToString:@"Mobile Uploads"]) {
                currentId = [item objectForKey:@"id"];
            }else if ([[item objectForKey:@"name"] isEqualToString:@"Timeline Photos"]){
                currentId = [item objectForKey:@"id"];
            }
        }
        
        
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                      initWithGraphPath:[NSString stringWithFormat:@"/%@",currentId]
                                      parameters:@{ @"fields": @"photos",}
                                      HTTPMethod:@"GET"];
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
            // Insert your code here
            FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                          initWithGraphPath:[NSString stringWithFormat:@"/%@",[[[[result objectForKey:@"photos"] objectForKey:@"data"] objectAtIndex:0] objectForKey:@"id"]]
                                          parameters:@{ @"fields": @"likes,comments",}
                                          HTTPMethod:@"GET"];
            [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                // Insert your code here
                NSInteger likesCount = [[[result objectForKey:@"likes"] objectForKey:@"data"] count];
                NSInteger commentsCount = [[[result objectForKey:@"comments"] objectForKey:@"data"] count];
                
                NSInteger  serverSentLikeCount = 0;
                NSInteger  serverSentcommentCount = 0;
                
                //code for likes Count
                if ([[NSUserDefaults standardUserDefaults] integerForKey:FB_LIKES]>0) {
                    NSInteger oldValue = [[NSUserDefaults standardUserDefaults] integerForKey:FB_LIKES];
                    serverSentLikeCount = likesCount - oldValue;
                    if (serverSentLikeCount>0) {
                        //server API call
                        [userDefaults setInteger:likesCount forKey:FB_LIKES];
                        [userDefaults setInteger:serverSentLikeCount forKey:FB_NEW_LIKES];
                    }else{
                        [userDefaults setInteger:serverSentLikeCount forKey:FB_NEW_LIKES];
                    }
                }else{
                    //API call with twitter friends Count
                    serverSentLikeCount = likesCount;
                    [userDefaults setInteger:likesCount forKey:FB_LIKES];
                    [userDefaults setInteger:serverSentLikeCount forKey:FB_NEW_LIKES];
                }
                [userDefaults synchronize];
                
                
                //code for comments count
                
                if ([[NSUserDefaults standardUserDefaults] integerForKey:FB_COMMENTS]>0) {
                    NSInteger oldValue = [[NSUserDefaults standardUserDefaults] integerForKey:FB_COMMENTS];
                    serverSentcommentCount = commentsCount - oldValue;
                    if (serverSentcommentCount>0) {
                        //server API call
                        [userDefaults setInteger:commentsCount forKey:FB_COMMENTS];
                        [userDefaults setInteger:serverSentcommentCount forKey:FB_NEW_COMMENTS];
                    }else{
                        [userDefaults setInteger:serverSentcommentCount forKey:FB_NEW_COMMENTS];
                    }
                }else{
                    //API call with twitter friends Count
                    serverSentcommentCount = commentsCount;
                    [userDefaults setInteger:commentsCount forKey:FB_COMMENTS];
                    [userDefaults setInteger:serverSentcommentCount forKey:FB_NEW_COMMENTS];
                }
                [userDefaults synchronize];
                [self saveCreditScore:1];
                
            }];
            
        }];
        
        // Insert your code here
    }];
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
            NSInteger   serverSentValue  = 0;
            
            if ([userDefaults integerForKey:userDefaultsKey]>0) {
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
                serverSentValue = twitterFriendsCount;
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

#pragma mark LINKEDIN METHODS

- (void)saveLinkedinConnections:(id)obj
{
    if (![[NSUserDefaults standardUserDefaults]boolForKey:@"LinkedInLogged"]) {
        [SOCIALMACRO createSocialSite:@"4" details:@"Linkedin" completion:^(id obj) {
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"LinkedInLogged"];
        }];
    }
    
    NSData* datum = [obj dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary* jDict = [NSJSONSerialization JSONObjectWithData:datum
                                                          options:kNilOptions
                                                            error:&error];
    NSInteger totalConnections = [[jDict objectForKey:@"numConnections"] integerValue];
    NSInteger totalPositions = [[[jDict objectForKey:@"positions"] objectForKey:@"_total"] integerValue];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger   serverSentValue  =0;
    
    if ([userDefaults integerForKey:LINKEDIN_CONNECTIONS]>0) {
        NSInteger   serverSentValue  =0;
        
        NSInteger oldValue = [userDefaults integerForKey:LINKEDIN_CONNECTIONS];
        serverSentValue = totalConnections - oldValue;
        if (serverSentValue>0) {
            [userDefaults setInteger:totalConnections forKey:LINKEDIN_CONNECTIONS];
            [userDefaults setInteger:serverSentValue forKey:LINKEDIN_NEW_CONNECTIONS];
        }else{
            [userDefaults setInteger:serverSentValue forKey:LINKEDIN_NEW_CONNECTIONS];
        }
    }else{
        serverSentValue = totalConnections;
        [userDefaults setInteger:serverSentValue forKey:LINKEDIN_NEW_CONNECTIONS];
        [userDefaults setInteger:totalConnections forKey:LINKEDIN_CONNECTIONS];
    }
    
    serverSentValue = 0;
    if ([userDefaults integerForKey:LINKEDIN_JOBS]>0) {
        
        NSInteger oldValue = [userDefaults integerForKey:LINKEDIN_JOBS];
        serverSentValue = totalPositions - oldValue;
        if (serverSentValue>0) {
            [userDefaults setInteger:totalPositions forKey:LINKEDIN_JOBS];
            [userDefaults setInteger:serverSentValue forKey:LINKEDIN_NEW_JOBS];
        }else{
            [userDefaults setInteger:serverSentValue forKey:LINKEDIN_NEW_JOBS];
        }
    }else{
        serverSentValue = totalPositions;
        [userDefaults setInteger:serverSentValue forKey:LINKEDIN_NEW_CONNECTIONS];
        [userDefaults setInteger:totalPositions forKey:LINKEDIN_JOBS];
    }
    [self saveCreditScore:4];
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
            socialDict = [@{@"PL":[NSNumber numberWithInteger:[[NSUserDefaults standardUserDefaults] integerForKey:FB_NEW_LIKES]],@"PC":[NSNumber numberWithInteger:[[NSUserDefaults standardUserDefaults] integerForKey:FB_NEW_COMMENTS]],@"CI":@"0",@"NF":[NSNumber numberWithInteger:[[NSUserDefaults standardUserDefaults] integerForKey:FB_NEW_FRIENDS]],@"NWP":[NSNumber numberWithInteger:[[NSUserDefaults standardUserDefaults] integerForKey:FB_NEW_POSTS]]}mutableCopy];
            socialKey = @"FB";
            break;
        }
        case 2:
        {
            socialDict = [@{@"NF":[NSNumber numberWithInteger:[userDefaults integerForKey:TWITTER_NEW_FRIENDS]],@"NFOL":[NSNumber numberWithInteger:[userDefaults integerForKey:TWITTER_NEW_FOLLOWERS]]}mutableCopy];
            socialKey = @"TW";
            break;
        }
        case 3:
        {
            socialDict = [@{@"NFOL":[NSNumber numberWithInteger:[userDefaults integerForKey:INSTAGRAM_NEW_FOLLOWERS]],@"PL":[NSNumber numberWithInteger:[userDefaults integerForKey:INSTAGRAM_NEW_LIKES]],@"PC":[NSNumber numberWithInteger:[userDefaults integerForKey:INSTAGRAM_NEW_COMMENTS]],@"NMF":[NSNumber numberWithInteger:[userDefaults integerForKey:INSTAGRAM_NEW_FOLLOWEDBY]]}mutableCopy];
            socialKey = @"IN";
            break;
        }
        case 4:
        {
            socialDict = [@{@"TC":[NSNumber numberWithInteger:[userDefaults integerForKey:LINKEDIN_NEW_CONNECTIONS]],@"JO":[NSNumber numberWithInteger:[userDefaults integerForKey:LINKEDIN_NEW_JOBS]],@"SAVG":@"0"}mutableCopy];
            socialKey = @"LI";
            break;
        }
        default:
            break;
    }
    [dict setValue:socialDict forKey:socialKey];
    NSLog(@"credit save dict %@",dict);
    return;
    [PROFILEMACRO saveCreditScore:dict completion:^(id obj) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            //#-- send post notification to update credit score
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
        }else{
            
        }
    }];
}

#pragma Instagram helper methods

- (void)saveInstagramConnections:(id)obj
{
//    if (![[NSUserDefaults standardUserDefaults]boolForKey:@"InstagramInLogged"]) {
//        [SOCIALMACRO createSocialSite:@"3" details:@"Instagram" completion:^(id obj) {
//            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"InstagramInLogged"];
//        }];
//    }
//    
//    NSData* datum = [obj dataUsingEncoding:NSUTF8StringEncoding];
//    NSError *error;
//    NSDictionary* jDict = [NSJSONSerialization JSONObjectWithData:datum
//                                                          options:kNilOptions
//                                                            error:&error];
//    NSInteger totalConnections = [[jDict objectForKey:@"numConnections"] integerValue];
//    NSInteger totalPositions = [[[jDict objectForKey:@"positions"] objectForKey:@"_total"] integerValue];
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSInteger   serverSentValue  =0;
//    
//    if ([userDefaults integerForKey:LINKEDIN_CONNECTIONS]>0) {
//        NSInteger   serverSentValue  =0;
//        
//        NSInteger oldValue = [userDefaults integerForKey:LINKEDIN_CONNECTIONS];
//        serverSentValue = totalConnections - oldValue;
//        if (serverSentValue>0) {
//            [userDefaults setInteger:totalConnections forKey:LINKEDIN_CONNECTIONS];
//            [userDefaults setInteger:serverSentValue forKey:LINKEDIN_NEW_CONNECTIONS];
//        }else{
//            [userDefaults setInteger:serverSentValue forKey:LINKEDIN_NEW_CONNECTIONS];
//        }
//    }else{
//        [userDefaults setInteger:serverSentValue forKey:LINKEDIN_NEW_CONNECTIONS];
//        [userDefaults setInteger:totalConnections forKey:LINKEDIN_CONNECTIONS];
//    }
//    
//    serverSentValue = 0;
//    if ([userDefaults integerForKey:LINKEDIN_JOBS]>0) {
//        
//        NSInteger oldValue = [userDefaults integerForKey:LINKEDIN_JOBS];
//        serverSentValue = totalPositions - oldValue;
//        if (serverSentValue>0) {
//            [userDefaults setInteger:totalPositions forKey:LINKEDIN_JOBS];
//            [userDefaults setInteger:serverSentValue forKey:LINKEDIN_NEW_JOBS];
//        }else{
//            [userDefaults setInteger:serverSentValue forKey:LINKEDIN_NEW_JOBS];
//        }
//    }else{
//        [userDefaults setInteger:serverSentValue forKey:LINKEDIN_NEW_CONNECTIONS];
//        [userDefaults setInteger:totalPositions forKey:LINKEDIN_JOBS];
//    }
//    [self saveCreditScore:4];
}



@end
