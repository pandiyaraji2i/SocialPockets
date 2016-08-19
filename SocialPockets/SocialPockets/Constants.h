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

#define MAX_ACCOUNT  3
#define INDIANRUPEES_UNICODE @"\u20B9"
#define SAND_CLOCK @"\u231B"


//#-- USERDEFAULTS

#define USERID @"User_ID"
#define USERNAME @"User_Name"
#define USEREMAIL @"User_Email"

#endif /* Constants_h */
