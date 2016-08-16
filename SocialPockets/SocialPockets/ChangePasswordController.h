//
//  ChangePasswordController.h
//  SocialPockets
//
//  Created by Pandiyaraj on 20/07/16.
//  Copyright © 2016 Pandiyaraj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePasswordController : UIViewController
{
    IBOutlet UITextField *oldPasswordTxtField, *newPasswordTxtField, *confirmPasswordTxtField;
    IBOutlet UIImageView *bgImageView;
    IBOutlet UIButton *doneButton;
}

- (IBAction)onDoneAction:(id)sender;

@end
