//
//  LoginViewController.h
//  SocialPockets
//
//  Created by Pandiyaraj on 21/07/16.
//  Copyright © 2016 Pandiyaraj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
{
    IBOutlet UITextField *userNameTextField, *passwordTextField;

}

+(MFSideMenuContainerViewController*)loginSuccessForIOS8:(BOOL)animated  userId:(NSString *)userId fromClass:(NSString*)className;
@end
