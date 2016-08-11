//
//  AppDelegate.m
//  SocialPockets
//
//  Created by Pandiyaraj on 18/07/16.
//  Copyright © 2016 Pandiyaraj. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //#-- For FaceBook
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    //#--  For Twitter
    [[Twitter sharedInstance] startWithConsumerKey:@"bMhvo4DTWbPg6lrSKATbFSMaq" consumerSecret:@"Ah0OxX9kWaTVZFFGOwFZRE5c1niQhrxHAU5glQdNri8rQhkdGr"];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isLoggedFirst"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLoggedFirst"];
    }else{
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"loanIsCompleted"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"loanIsProcessed"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLoggedFirst"];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSString *userId = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:USERID]];
    if (userId.length && ![userId isEqualToString:@"(null)"]) {
        // logged in
        MFSideMenuContainerViewController *container = [LoginViewController loginSuccessForIOS8:NO userId:userId fromClass:@"AppDelegate"];
        self.window.rootViewController = (UIViewController*)container;
    }else{
        // Not logged in
        self.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController];

      
    }
    
    UIUserNotificationSettings *settings =[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert |
                                           UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
  
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)])
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil]];
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                  openURL:url
                                                        sourceApplication:sourceApplication
                                                               annotation:annotation
                    ];
    // Add any custom logic here.
    return handled;
}


#pragma mark push notifications

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    //#-- 611730a67c67df645fd30688dbf485906a274a9111e7483ac336d58851990e4d iPhone 5
    //#-- b0c1b40bd9460d91febfd703b8ec0086cddb57a22d1963f31b1a3fa56b1eccc6 iPhone 6
    NSString * token = [NSString stringWithFormat:@"%@", deviceToken];
    //Format token as you need:
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
    
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"appDeviceToken"]; //save token to resend it if request fails
    //[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"apnsTokenSentSuccessfully"]; // set flag for request status
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSLog(@"Device ID %@",[[[UIDevice currentDevice]identifierForVendor]UUIDString]);
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"userInfo -- %@",userInfo);
//     NSString *pushMessage = [[[userInfo valueForKey:@"aps"] valueForKey:@"alert"] valueForKey:@"loc-key"];
//    NSLog(@"message --- %@",pushMessage );
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"error %@",[error description]);
}
@end
