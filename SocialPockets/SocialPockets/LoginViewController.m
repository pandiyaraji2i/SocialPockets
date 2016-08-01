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
#import "AppDelegate.h"

@implementation LoginViewController

- (void)viewDidLoad
{
    self.navigationController.navigationBarHidden = NO;
    self.title = @"Login";
    
    userNameTextField.text = @"pandi@gmail.com";
    passwordTextField.text = @"pandi123";
}

- (IBAction)loginButtonAction:(id)sender
{
    if (!userNameTextField.text.length || !passwordTextField.text.length) {
        ErrorMessageWithTitle(@"Message", @"Please enter all the fields");
    }
    else {
        [LOGINMACRO validateUser:userNameTextField.text password:passwordTextField.text completion:^(id obj) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                
                [[NSUserDefaults standardUserDefaults] setObject:obj forKey:@"USERINFO"];
                [[NSUserDefaults standardUserDefaults] setObject:[obj valueForKey:@"USER_ID"] forKey:USERID];
                
                MFSideMenuContainerViewController *container =  [LoginViewController loginSuccessForIOS8:YES userId:[obj valueForKey:@"USER_ID"] fromClass:@"LoginViewController"];
                [self.navigationController presentViewController:container animated:YES completion:nil];
            }else{
                ErrorMessageWithTitle(@"Message", @"Invalid");
            }
          
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
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"USERINFO"];
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:USERID];
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
                if ([menuTitle isEqualToString:@"Terms & Conditions"] || [menuTitle isEqualToString:@"FAQ"] || [menuTitle isEqualToString:@"About SocialPocket"]) {
                    identifier = @"AboutUs";
                }
                else {
                    identifier = [menuTitle stringByReplacingOccurrencesOfString:@" " withString:@""];
                }
                id control = [storyboard instantiateViewControllerWithIdentifier:identifier];
                [controller popToRootViewControllerAnimated:NO];
                [controller pushViewController:control animated:YES];
                [container toggleLeftSideMenuCompletion:^{
                }];
                
                
            }
            @catch (NSException *exception) {
                NSLog(@"error");
            }
            @finally {
//                NSLog(@"err");
            }
        }
    };
    return container;
}

- (IBAction)forgotPasswordAction:(id)sender
{
    [LOGINMACRO forgotPasswordForUser:@"" completion:^(id obj) {
        
    }];
}
@end
