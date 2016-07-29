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

@implementation LoginViewController

- (void)viewDidLoad
{
    self.navigationController.navigationBarHidden = NO;
    self.title = @"Login";
    
    userNameTextField.text = @"test@gmail.com";
    passwordTextField.text = @"12345";
}

- (IBAction)loginButtonAction:(id)sender
{
    if (!userNameTextField.text.length || !passwordTextField.text.length) {
        ErrorMessageWithTitle(@"Message", @"Please enter all the fields");
    }
    else {
        [LOGINMACRO validateUser:userNameTextField.text password:passwordTextField.text completion:^(id obj) {
            RearViewController *rearVc = [self.storyboard instantiateViewControllerWithIdentifier:@"RearVc"];
            DashBoardViewController *dashboardVc = [self.storyboard instantiateViewControllerWithIdentifier:@"DashboardVc"];
            CustomNavigationController *controller=[[CustomNavigationController alloc]initWithRootViewController:dashboardVc];
            MFSideMenuContainerViewController *container = [MFSideMenuContainerViewController
                                                            containerWithCenterViewController:controller
                                                            leftMenuViewController:rearVc
                                                            rightMenuViewController:nil];
            rearVc.menu =^(NSString* menuTitle){
                
                NSLog(@"til %@",menuTitle);
                if ([menuTitle isEqualToString:@"Logout"]) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            };
            [self.navigationController presentViewController:container animated:YES completion:nil];
        }];
    }
}

- (IBAction)forgotPasswordAction:(id)sender
{
    [LOGINMACRO forgotPasswordForUser:@"" completion:^(id obj) {
        
    }];
}
@end
