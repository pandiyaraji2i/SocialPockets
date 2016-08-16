//
//  ChangePasswordController.m
//  SocialPockets
//
//  Created by Pandiyaraj on 20/07/16.
//  Copyright © 2016 Pandiyaraj. All rights reserved.
//

#import "ChangePasswordController.h"

@implementation ChangePasswordController

- (void)viewDidLoad
{
    self.title = @"Change Password";
    if (IPHONE6PLUS_STANDARD){
        bgImageView.image = [UIImage imageNamed:@"NotificationBG6Splus.png"];
        
    }else if (IPHONE5){
        bgImageView.image = [UIImage imageNamed:@"NotificationBG.png"];
        
    }else if(IPHONE6_STANDARD){
        bgImageView.image = [UIImage imageNamed:@"NotificationBG6S.png"];
        
    }else{
        bgImageView.image = [UIImage imageNamed:@"NotificationBG4S.png"];
            }
}

- (IBAction)onDoneAction:(id)sender
{
    if (!oldPasswordTxtField.text.length || !newPasswordTxtField.text.length || !confirmPasswordTxtField.text.length) {
        // Enter all fields
        ErrorMessageWithTitle(@"Message", @"Please enter all fields");
    }
    else if (![newPasswordTxtField.text isEqualToString:confirmPasswordTxtField.text])
    {
        // New and confirm passwords are mismatched
        ErrorMessageWithTitle(@"Message", @"New password and confirm password are different");
    }
    else{
       [PROFILEMACRO changePassword:oldPasswordTxtField.text newPassword:newPasswordTxtField.text completion:^(id obj) {
           if ([obj isKindOfClass:[NSDictionary class]]) {
               [self showAlertView:[obj valueForKey:@"message"]];
           }else{
                ErrorMessageWithTitle(@"Message", obj);
           }
       }];
    }
}

- (void)showAlertView:(NSString *)message
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Message"
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    //We add buttons to the alert controller by creating UIAlertActions:
    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action){
                                                         [self.navigationController popViewControllerAnimated:YES];
                                                     }] ;
    [alertController addAction:actionOk];
    [self presentViewController:alertController animated:YES completion:nil];

}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
@end
