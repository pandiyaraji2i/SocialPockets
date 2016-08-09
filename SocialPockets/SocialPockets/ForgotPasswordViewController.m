//
//  ResetPasswordViewController.m
//  SocialPockets
//
//  Created by ideas2it-Kovendhan on 08/08/16.
//  Copyright © 2016 Pandiyaraj. All rights reserved.
//

#import "ForgotPasswordViewController.h"

@interface ForgotPasswordViewController ()

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Forgot Password";
}

- (IBAction)resetPasswordButtonAction:(id)sender
{
    if (!userNameTextField.text.length || !userEmailAddressField.text.length) {
        ErrorMessageWithTitle(@"Message", @"Please enter all the fields");
    }
    else {
        [LOGINMACRO forgotPasswordForUser:userEmailAddressField.text completion:^(id obj) {
            [self.navigationController popViewControllerAnimated:true];
            ErrorMessageWithTitle(@"Message", @"Please check your mail for new password");
        }];
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
