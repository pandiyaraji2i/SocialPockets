//
//  AppDelegate.h
//  SocialPockets
//
//  Created by Pandiyaraj on 18/07/16.
//  Copyright © 2016 Pandiyaraj. All rights reserved.
//

#import <UIKit/UIKit.h>



#define INSTAGRAM_AUTHURL                               @"https://api.instagram.com/oauth/authorize/"
#define INSTAGRAM_FETCHURL                              @"https://api.instagram.com/v1/users/self?access_token="
#define INSTAGRAM_APIURl                                @"https://api.instagram.com/v1/users/"
#define INSTAGRAM_CLIENT_ID                             @"5114b1aa048048c49227c96bc45797bd"
#define INSTAGRAM_CLIENTSERCRET                         @"04da6909d27b43a8beaff4eb45187f6e"
#define INSTAGRAM_REDIRECT_URI                          @"http://www.google.co.in"
#define INSTAGRAM_ACCESS_TOKEN                          @"access_token"
#define INSTAGRAM_SCOPE                                 @"likes+comments+relationships+follower_list+comments+basic"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

