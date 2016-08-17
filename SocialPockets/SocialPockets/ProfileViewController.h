//
//  ProfileViewController.h
//  SocialPockets
//
//  Created by ideas2it-Kovendhan on 19/07/16.
//  Copyright © 2016 Pandiyaraj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController
{
    IBOutlet NSLayoutConstraint *nameTextFieldTopConstraint, *btnBottomConstraint;
    IBOutlet UITextField *nameTextField, *emailTextField, *phoneNumberTextField, *userNameTextField;
}
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIButton *editProfileBtn, *changePasswordBtn,*profileImageBtn;

@end
