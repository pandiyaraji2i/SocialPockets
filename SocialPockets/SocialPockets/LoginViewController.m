//
//  LoginViewController.m
//  SocialPockets
//
//  Created by Pandiyaraj on 21/07/16.
//  Copyright © 2016 Pandiyaraj. All rights reserved.
//

#import "LoginViewController.h"

@implementation LoginViewController

- (void)viewDidLoad
{
    self.navigationController.navigationBarHidden = NO;
}

- (IBAction)loginButtonAction:(id)sender
{
    if (!userNameTextField.text.length || !passwordTextField.text.length) {
        ErrorMessageWithTitle(@"Message", @"Please enter all the fields");
    }
    else {
        [LOGINMACRO validateUser:userNameTextField.text password:passwordTextField.text completion:^(id obj) {
            
        }];
    }
}

- (IBAction)forgotPasswordAction:(id)sender
{
    [LOGINMACRO forgotPasswordForUser:@"" completion:^(id obj) {
        
    }];
}
@end
