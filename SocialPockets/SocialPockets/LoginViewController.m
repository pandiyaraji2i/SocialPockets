//
//  LoginViewController.m
//  SocialPockets
//
//  Created by Pandiyaraj on 21/07/16.
//  Copyright © 2016 Pandiyaraj. All rights reserved.
//

#import "LoginViewController.h"
#import "DashBoardViewController.h"
#import "RearViewController.h"
#import "ForgotPasswordViewController.h"
#import "AppDelegate.h"

@implementation LoginViewController

- (void)viewDidLoad
{
    self.navigationController.navigationBarHidden = NO;
    self.title = @"Login";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];

    userNameTextField.text = @"pandi@i2it.com";
    passwordTextField.text = @"test1234";
}

- (IBAction)loginButtonAction:(id)sender
{
    if (!userNameTextField.text.length || !passwordTextField.text.length) {
        ErrorMessageWithTitle(@"Message", @"Please enter all the fields");
    }
    else {
        [ACTIVITY showActivity:@"Loading..."];
        [self performSelector:@selector(login) withObject:nil afterDelay:1.0];
    }
}

- (void)login
{
    [LOGINMACRO validateUser:userNameTextField.text password:passwordTextField.text completion:^(id obj) {
        [ACTIVITY performSelectorOnMainThread:@selector(hideActivity) withObject:nil waitUntilDone:YES];
        
        if ([obj isKindOfClass:[NSDictionary class]]) {
            [self updateObjectToDatabase:obj];
//            MFSideMenuContainerViewController *container =  [LoginViewController loginSuccessForIOS8:YES userId:[obj valueForKey:@"USER_ID"] fromClass:@"LoginViewController"];
//            [self.navigationController presentViewController:container animated:YES completion:nil];
        }else{
            ErrorMessageWithTitle(@"Message", obj);
        }
    }];
}

- (void)updateObjectToDatabase:(id)obj
{
    [[NSUserDefaults standardUserDefaults] setObject:obj forKey:@"USERINFO"];
    [[NSUserDefaults standardUserDefaults] setObject:[obj valueForKey:@"USER_ID"] forKey:USERID];
    [[NSUserDefaults standardUserDefaults] setObject:[obj valueForKey:@"USER_NAME"] forKey:USERNAME];
    [[NSUserDefaults standardUserDefaults] setObject:[obj valueForKey:@"USER_EMAIL"] forKey:USEREMAIL];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSString *userId = [NSString stringWithFormat:@"%@",[obj valueForKey:@"USER_ID"]];
    if (userId.length)
    {
        if (USERINFO.userId.length && ![USERINFO.userId isEqualToString:userId]) {
            [DBPROFILE clearForNewUser];
            [DATABASE.managedObjectContext deleteObject:USERINFO];
            DBPROFILE.userInfo=nil;
        }
        USERINFO;
        NSManagedObjectContext *profileContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [profileContext performBlockAndWait:^{
            profileContext.parentContext = DATABASE.managedObjectContext;
            UserDetails *tempUser = (id)[profileContext objectWithID:USERINFO.objectID];
            tempUser.userId = userId;
            [DBPROFILE generateUserInfo:obj forUser:tempUser.userId];
            [DATABASE dbSaveRecordChildContext:profileContext];
            [DBPROFILE downloadImage];
            MFSideMenuContainerViewController *container = [LoginViewController loginSuccessForIOS8:YES userId:USERINFO.userId fromClass:@"LoginViewController"];
            [self.navigationController presentViewController:container animated:YES completion:nil];
        }];
    }
}

+(MFSideMenuContainerViewController*)loginSuccessForIOS8:(BOOL)animated  userId:(NSString *)userId fromClass:(NSString*)className
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    RearViewController *rearVc = [storyboard instantiateViewControllerWithIdentifier:@"RearVc"];
    DashBoardViewController *dashboardVc = [storyboard instantiateViewControllerWithIdentifier:@"DashboardVc"];
    CustomNavigationController *controller=[[CustomNavigationController alloc]initWithRootViewController:dashboardVc];
    MFSideMenuContainerViewController *container = [MFSideMenuContainerViewController
                                                    containerWithCenterViewController:controller
                                                    leftMenuViewController:rearVc
                                                    rightMenuViewController:nil];
    rearVc.menu =^(NSString* menuTitle){
        if ([menuTitle isEqualToString:@"Logout"]) {
            
            [[NSUserDefaults standardUserDefaults] setObject:USERID forKey:USER_PREV_ID];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"USERINFO"];
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:USERID];
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"FacebookAccessToken"];
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"TwitterAccessToken"];
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"InstagramAccessToken"];
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"LinkedInAccessToken"];
            
            AppDelegate *appDelegateTemp = (AppDelegate*)[UIApplication sharedApplication].delegate;
            appDelegateTemp.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
        }
        else if ([menuTitle isEqualToString:@"Dashboard"])
        {
            [container toggleLeftSideMenuCompletion:^{
            }];
        }
        else{
            @try {
                // Push navigation
                NSString *identifier;
                if ([menuTitle isEqualToString:@"Terms & Conditions"] || [menuTitle isEqualToString:@"FAQ"] || [menuTitle isEqualToString:@"About Social Pocket"]) {
                    identifier = @"AboutUs";
                }
                else {
                    identifier = [menuTitle stringByReplacingOccurrencesOfString:@" " withString:@""];
                }
                id control = [storyboard instantiateViewControllerWithIdentifier:identifier];
                [control setTitle:menuTitle];
                [controller popToRootViewControllerAnimated:NO];
                [controller pushViewController:control animated:YES];
                [container toggleLeftSideMenuCompletion:^{
                }];
                
                
            }
            @catch (NSException *exception) {
                NSLog(@"error");
            }
            @finally {
                //NSLog(@"err");
            }
        }
    };
    return container;
}

- (IBAction)forgotPasswordAction:(id)sender
{
    ForgotPasswordViewController *forgotPasswordVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ForgotPasswordVc"];
    //    [self presentViewController:forgotPasswordVC animated:YES completion:nil];
    [self.navigationController pushViewController:forgotPasswordVC animated:YES];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan) {
        [self.view endEditing:YES];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}
#pragma mark Status Bar Style
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
@end
