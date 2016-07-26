//
//  RegistrationViewController.m
//  SocialPockets
//
//  Created by Ideas2IT-GaneshM on 20/07/16.
//  Copyright © 2016 Pandiyaraj. All rights reserved.
//

#import "RegistrationViewController.h"

@interface RegistrationViewController ()

@end

@implementation RegistrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    
    profileImage = nil;
    self.profileImageBtn.layer.cornerRadius = (self.profileImageBtn.frame.size.height/2);
    self.profileImageBtn.layer.borderWidth = 3.0;
    self.profileImageBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.profileImageBtn.layer.masksToBounds = YES;
 
    self.userInfoView.layer.cornerRadius = 5.0;
    self.userInfoView.layer.masksToBounds = YES;
    
    self.nextBtn.layer.borderColor = [UIColor grayColor].CGColor;
    self.nextBtn.layer.borderWidth = 1.0;
    self.nextBtn.layer.masksToBounds = YES;
    // Do any additional setup after loading the view.
    
}

- (IBAction)profileImageAction:(id)sender
{
//    CameraViewController *vc =[[CameraViewController alloc]initwithController];
//    [vc openCamera:0];
//    [self.navigationController presentViewController:vc animated:NO completion:nil];
//    vc.imageSelect = ^(id obj){
//        if (obj && [obj isKindOfClass:[UIImage class]]) {
//            profileImage = obj;
//            [self.profileImageBtn setImage:profileImage forState:UIControlStateNormal];
//        }
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self dismissViewControllerAnimated:NO completion:nil];
//        });
//    };
}

- (IBAction)termsCheckBoxTapped:(id)sender {
    _termsCheckBoxButton.selected = !_termsCheckBoxButton.selected;
  
}

- (IBAction)onRegisterAction:(id)sender {
    
    if(!firstNameTextField.text.length || !emailTextField.text.length || !phoneNumberTextField.text.length || !usernameTextField.text.length || !passwordTextField.text.length || !confirmPasswordTextField.text.length)
    {
        ErrorMessageWithTitle(@"Message",@"Please enter all fields");
    }
    else if (![emailTextField.text isValidEmail])
    {
        ErrorMessageWithTitle(@"Message",@"Pleas enter valid email");
    }
    else if (![phoneNumberTextField.text isValidPhoneNumber])
    {
        ErrorMessageWithTitle(@"Message",@"Pleas enter valid phone number");
    }
    else if (![passwordTextField.text isEqualToString:confirmPasswordTextField.text])
    {
        ErrorMessageWithTitle(@"Message",@"New password and confirm password is mismatched");
    }
    else if (!_termsCheckBoxButton.isSelected)
    {
        ErrorMessageWithTitle(@"Message",@"Please read terms and conditions");
    }
    else if (!profileImage)
    {
         ErrorMessageWithTitle(@"Message",@"Please select image");

    }
    else{
        [REGMACRO registerWithName:firstNameTextField.text userName:usernameTextField.text email:emailTextField.text password:passwordTextField.text phoneNumber:phoneNumberTextField.text completion:^(id obj) {
            
            
            // If success
            [NetworkHelperClass uploadImage:profileImage isUserOrLoan:1 userId:@"" sync:NO completion:^(id obj) {
                
            }];
            // Call Otp
            [REGMACRO createOTPForPhoneNumber:phoneNumberTextField.text createdBy:@"userid" completion:^(id obj) {
                
            }];
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
