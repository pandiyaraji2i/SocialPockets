//
//  RegistrationViewController.h
//  SocialPockets
//
//  Created by Ideas2IT-GaneshM on 20/07/16.
//  Copyright © 2016 Pandiyaraj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistrationViewController : UIViewController
{
    IBOutlet UITextField *emailTextField, *usernameTextField, *phoneNumberTextField, *firstNameTextField, *passwordTextField, *confirmPasswordTextField;
    UIImage *profileImage;
    IBOutlet UIScrollView *listScrollView;
}
@property (weak, nonatomic) IBOutlet UIButton *profileImageBtn;
@property (weak, nonatomic) IBOutlet UIView *userInfoView;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIButton *termsCheckBoxButton;

- (IBAction)onRegisterAction:(id)sender;
@end
