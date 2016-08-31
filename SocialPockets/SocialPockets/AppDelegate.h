//
//  AppDelegate.h
//  SocialPockets
//
//  Created by Pandiyaraj on 18/07/16.
//  Copyright © 2016 Pandiyaraj. All rights reserved.
//

#import <UIKit/UIKit.h>



#define INSTAGRAM_AUTHURL                               @"https://api.instagram.com/oauth/authorize/"
#define INSTAGRAM_FETCHURL                              @"https://api.instagram.com/v1/users/self/?access_token="
#define INSTAGRAM_DETAILURL                             @"https://api.instagram.com/v1/users/self/media/recent?access_token="
#define INSTAGRAM_APIURl                                @"https://api.instagram.com/v1/users/"
#define INSTAGRAM_CLIENT_ID                             @"f022329242d14ec1a51c3649a6895f25"
#define INSTAGRAM_CLIENTSERCRET                         @"efd82f80a477461ca5d0d357d40566b5"
#define INSTAGRAM_REDIRECT_URI                          @"http://www.google.co.in"
#define INSTAGRAM_ACCESS_TOKEN                          @"access_token"
#define INSTAGRAM_SCOPE                                 @"likes+comments+relationships+follower_list+comments+basic"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

