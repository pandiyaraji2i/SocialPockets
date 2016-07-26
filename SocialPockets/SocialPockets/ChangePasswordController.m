//
//  ChangePasswordController.m
//  SocialPockets
//
//  Created by Pandiyaraj on 20/07/16.
//  Copyright © 2016 Pandiyaraj. All rights reserved.
//

#import "ChangePasswordController.h"

@implementation ChangePasswordController


- (IBAction)onDoneAction:(id)sender
{
    if (!oldPasswordTxtField.text.length || !newPasswordTxtField.text.length || !confirmPasswordTxtField.text.length) {
        // Enter all fields
    }
    else if (![newPasswordTxtField.text isEqualToString:confirmPasswordTxtField.text])
    {
        // New and confirm passwords are mismatched
    }
    else{
       [PROFILEMACRO changePassword:oldPasswordTxtField.text newPassword:newPasswordTxtField.text completion:^(id obj) {
           
       }];
    }
}
@end
