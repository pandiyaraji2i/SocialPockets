//
//  Constants.h
//  NetworkHelper
//
//  Created by Pandiyaraj on 14/07/16.
//  Copyright © 2016 Pandiyaraj. All rights reserved.
//

#ifndef Constants_h
#define Constants_h


//#-- BASE URLS

//#define BASEURL @"http://192.168.1.185:8000"
#define BASEURL @"http://128.199.150.145:8000"
#define PRODUCTIONMODE NO


//#-- Device Types
#define IS_OS_8_OR_LATER    ([[[UIDevice currentDevice] systemVersion] integerValue] >= 8.0)
#define IS_IPHONE [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone
#define IPHONE4 [[UIScreen mainScreen] bounds].size.height == 480
#define IPHONE5 (IS_IPHONE && ([[UIScreen mainScreen] bounds].size.height == 568.0) && ( [UIScreen mainScreen].nativeScale == [UIScreen mainScreen].scale))
#define IPHONE6_STANDARD (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 667.0  && IS_OS_8_OR_LATER && [UIScreen mainScreen].nativeScale == [UIScreen mainScreen].scale)
#define IPHONE6_ZOOMED (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0 && IS_OS_8_OR_LATER && [UIScreen mainScreen].nativeScale > [UIScreen mainScreen].scale)
#define IPHONE6PLUS_STANDARD (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 736.0)
#define IPHONE6PLUS_ZOOMED (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 667.0 && IS_OS_8_OR_LATER && [UIScreen mainScreen].nativeScale < [UIScreen mainScreen].scale)


#define DATEFORMAT @"dd MMM, yy"
#define LOCALDATETIMEFORMAT @"yyyy-MM-dd HH:mm:ss +0000"
#define FONT [UIFont fontWithName:@"Roboto-Regular" size:15.0]

// ***** Document Directory Constants ***** //
#define DOCUMENT_DIRECTORY NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]
#define DOCUMENT_DIRECTORY_WITHPATH(path) [SharedMethods documentPathWithPath:path]
#define DOCUMENT_DIRECTORY_WITHPATHWITHOUTUSERID(path) [DOCUMENT_DIRECTORY stringByAppendingPathComponent:path]
#define DOCUMENT_DIRECTORY_URL [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]


//#--  HTTP HEADERS
#define GET     @"GET"
#define POST    @"POST"
#define PUT     @"PUT"
#define DELETE  @"DELETE"

//#--  HTTP CONTENT TYPES
#define URLENCODEDCONTENTTYPE @"application/x-www-form-urlencoded"
#define JSONCONTENTTYPE       @"application/json"
#define MULTIPARTFORMDATA     @"application/"

#define MAX_ACCOUNT             3
#define INDIANRUPEES_UNICODE    @"\u20B9"
#define SAND_CLOCK              @"\u231B"


//#-- USERDEFAULTS

#define USERID                         @"User_ID"
#define USERNAME                       @"User_Name"
#define USEREMAIL                      @"User_Email"
#define USER_PREV_ID                   @"User_prev_id"

#define FB_LIKES                        @"FBLikesCount"
#define FB_NEW_LIKES                    @"FBLikesServerCount"
#define FB_FRIENDS                      @"FBFriendsCount"
#define FB_NEW_FRIENDS                  @"FBFriendsServerCount"
#define FB_COMMENTS                     @"FBCommentsCount"
#define FB_NEW_COMMENTS                 @"FBCommentsServerCount"
#define FB_POSTS                        @"FBPostCount"
#define FB_NEW_POSTS                    @"FBPostServerCount"

#define TWITTER_FOLLOWERS              @"twitterFollowersCount"
#define TWITTER_FRIENDS                @"twitterFriendsCount"
#define TWITTER_NEW_FOLLOWERS          @"followersServerListCount"
#define TWITTER_NEW_FRIENDS            @"friendsServerListCount"

#define INSTAGRAM_FOLLOWERS            @"Instagramfollows"
#define INSTAGRAM_NEW_FOLLOWERS        @"InstagramfollowsNew"
#define INSTAGRAM_FOLLOWEDBY           @"Instagramfollowedby"
#define INSTAGRAM_NEW_FOLLOWEDBY       @"InstagramfollowedbyNew"
#define INSTAGRAM_COMMENTS             @"InstagramCommentsCount"
#define INSTAGRAM_NEW_COMMENTS         @"InstagramCommentsCountNew"
#define INSTAGRAM_LIKES                @"InstagramLikesCount"
#define INSTAGRAM_NEW_LIKES            @"InstagramLikesCountNew"


#define LINKEDIN_CONNECTIONS           @"LiConnections"
#define LINKEDIN_JOBS                  @"LiPositions"
#define LINKEDIN_NEW_CONNECTIONS       @"LiConnectionsNew"
#define LINKEDIN_NEW_JOBS              @"LiPositionsNew"

//#-- Constant Variables

#define FACEBOOK_ID   @"1"
#define TWITTER_ID    @"2"
#define INSTAGRAM_ID  @"3"
#define LINKEDIN_ID   @"4"

//#-- APP Ids

#define INSTAGRAM_APPID @"15ee4b177c6d4817aa9a82fac4b6b955"
#define FACEBOOK_APPID @"141207379639575"
#define TWITTER_APPID @""


//#-- Citrus Merchant Constants

#define SignInId (PRODUCTIONMODE)?@"sqmkxzxq32-signin":@"bkhy5lnqsg-signin"
#define SignInSecretKey (PRODUCTIONMODE)?@"4566e38c28d66cb3eb9281e100df1666":@"3a26f6d622c193407578a12e1ec1ee62"
#define SubscriptionId (PRODUCTIONMODE)?@"sqmkxzxq32-signup":@"bkhy5lnqsg-signup"
#define SubscriptionSecretKey (PRODUCTIONMODE)?@"5e916a30a8294019ff8d58502acdfab4":@"85884d51524b8465811766d902201508"
#define VanityUrl (PRODUCTIONMODE)?@"sqmkxzxq32":@"bkhy5lnqsg"
#define LoadWalletReturnUrl (PRODUCTIONMODE)?@"http://128.199.150.145:8000/production/returnData.php":@"http://128.199.150.145:8000/dev/returnData.php"
#define BillUrl (PRODUCTIONMODE)?@"http://128.199.150.145:8000/production/billurl.php":@"http://128.199.150.145:8000/dev/billurl.php"

/*#define SignInId @"bkhy5lnqsg-signin"
#define SignInSecretKey @"3a26f6d622c193407578a12e1ec1ee62"
#define SubscriptionId @"bkhy5lnqsg-signup"
#define SubscriptionSecretKey @"85884d51524b8465811766d902201508"
#define VanityUrl @"bkhy5lnqsg"

#define LoadWalletReturnUrl @"http://128.199.150.145:8000/dev/returnData.php"
#define BillUrl @"http://128.199.150.145:8000/dev/billurl.php"*/



//#define LoadWalletReturnUrl @"https://salty-plateau-1529.herokuapp.com/redirectURL.sandbox.php"
//#define BillUrl @"https://salty-plateau-1529.herokuapp.com/billGenerator.sandbox.php"
//#define BillUrl @"http://localhost/BillGenerator.php"
//#define LoadWalletReturnUrl @"http://localhost/RetunUrl.php"
//#define LoadWalletReturnUrl (PRODUCTIONMODE)?@"http://128.199.150.145:8000/production/returnData.php":@"http://128.199.150.145:8000/dev/returnData.php"
//#define BillUrl (PRODUCTIONMODE)?@"http://128.199.150.145:8000/production/billurl.php":@"http://128.199.150.145:8000/dev/billurl.php"


#endif /* Constants_h */
