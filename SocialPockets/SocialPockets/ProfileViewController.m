//
//  ProfileViewController.m
//  SocialPockets
//
//  Created by ideas2it-Kovendhan on 19/07/16.
//  Copyright © 2016 Pandiyaraj. All rights reserved.
//

#import "ProfileViewController.h"
#import "ChangePasswordController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"My Account";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAccount) name:@"ReloadAccountScreen" object:nil];

    if (IPHONE6PLUS_STANDARD){
        self.backgroundImage.image = [UIImage imageNamed:@"NotificationBG6Splus.png"];
        
    }else if (IPHONE5){
        self.backgroundImage.image = [UIImage imageNamed:@"NotificationBG.png"];
        
    }else if(IPHONE6_STANDARD){
        self.backgroundImage.image = [UIImage imageNamed:@"NotificationBG6S.png"];
        
    }else{
        self.backgroundImage.image = [UIImage imageNamed:@"NotificationBG4S.png"];
        
    }
    
    if (IPHONE5 || IPHONE4) {
        nameTextFieldTopConstraint.constant = 10;
        btnBottomConstraint.constant = 20;
    }else{
        nameTextFieldTopConstraint.constant =50;
        btnBottomConstraint.constant = 20;
    }
    
    [self updateUserFields];
 
    self.editProfileBtn.layer.borderColor = [UIColor colorWithRed:30.0/255.0 green:159.0/255.0 blue:39.0/255.0 alpha:1.0].CGColor;
    self.changePasswordBtn.layer.borderColor = [UIColor colorWithRed:30.0/255.0 green:159.0/255.0 blue:39.0/255.0 alpha:1.0].CGColor;
    self.editProfileBtn.layer.borderWidth = 1.5;
    self.changePasswordBtn.layer.borderWidth = 1.5;
    
    self.editProfileBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
     self.changePasswordBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    self.profileImageBtn.layer.cornerRadius = 57.5;
    self.profileImageBtn.layer.masksToBounds =YES;
    [self.profileImageBtn setImage:[DBPROFILE getImageForUser] forState:UIControlStateNormal];
    
    profileImage = [UIImage imageNamed:@"TrackImage"];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@" " style:UIBarButtonItemStylePlain target:self action:nil];

    // Do any additional setup after loading the view.
}
- (void)reloadAccount
{
    [self.profileImageBtn setImage:[DBPROFILE getImageForUser] forState:UIControlStateNormal];
}
- (void)updateUserFields
{
    nameTextField.text = USERINFO.name;
    userNameTextField.text = USERINFO.user_name;
    emailTextField.text = USERINFO.user_email;
    phoneNumberTextField.text = USERINFO.user_phone_number;
    [self textFieldEnabled:NO];
}
- (void)textFieldEnabled:(BOOL)isEditable
{
    nameTextField.userInteractionEnabled = userNameTextField.userInteractionEnabled = emailTextField.userInteractionEnabled = phoneNumberTextField.userInteractionEnabled = isEditable;
    if (isEditable) {
        nameTextField.clearButtonMode = userNameTextField.clearButtonMode = emailTextField.clearButtonMode = phoneNumberTextField.clearButtonMode = UITextFieldViewModeAlways;
    }else{
         nameTextField.clearButtonMode = userNameTextField.clearButtonMode = emailTextField.clearButtonMode = phoneNumberTextField.clearButtonMode = UITextFieldViewModeNever;
    }
}

#pragma mark UIButton Actions
- (IBAction)editProfileAction:(id)sender
{
    UIButton *btn = sender;
    if (!btn.selected) {
        [self textFieldEnabled:YES];
        btn.selected = !btn.selected;
    }else{
        if (!nameTextField.text.length || !emailTextField.text.length || !phoneNumberTextField.text.length || !userNameTextField.text.length) {
            ErrorMessageWithTitle(@"Message", @"Please enter all fields");
            return;
        }else if (![emailTextField.text isValidEmail]){
            ErrorMessageWithTitle(@"Message", @"Enter valid email");
            return;
        }else if(![phoneNumberTextField.text isValidPhoneNumber]){
            ErrorMessageWithTitle(@"Message", @"Enter valid phone number");
            return;
        }
        else{
            [ACTIVITY showActivity:@"Updating..."];
            [PROFILEMACRO updateUserProfileWithName:nameTextField.text username:userNameTextField.text email:emailTextField.text phoneNumber:phoneNumberTextField.text completion:^(id obj) {
                [ACTIVITY performSelectorOnMainThread:@selector(hideActivity) withObject:nil waitUntilDone:YES];
                if ([obj isKindOfClass:[NSDictionary class]]) {
                    [DBPROFILE generateUserInfo:[obj valueForKey:@"user"] forUser:USERINFO.userId];
                }else{
                    ErrorMessageWithTitle(@"Message", obj);
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    btn.selected = !btn.selected;
                    [self updateUserFields];
                });
              
            }];
        }
    }
}
- (IBAction)changePasswordAction:(id)sender {
    ChangePasswordController *changePasswordVc =[self.storyboard instantiateViewControllerWithIdentifier:@"ChangePasswordVc"];
    [self.navigationController pushViewController:changePasswordVc animated:YES];
}

- (IBAction)profileImageAction:(id)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Open camera"
                                                                             message:@"Do you want to change your profile picture"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    //We add buttons to the alert controller by creating UIAlertActions:
    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action){
                                                         [self openCamera];
                                                     }] ;
    
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                       style:UIAlertActionStyleCancel
                                                     handler:^(UIAlertAction * _Nonnull action){
                                                     }] ;
    [alertController addAction:actionOk];
    [alertController addAction:actionCancel];
    [self presentViewController:alertController animated:YES completion:nil];

    
}
- (void)openCamera
{
//    [self uploadImage];
     CameraViewController *vc =[[CameraViewController alloc]initwithController];
     [vc openCamera:0];
     [self.navigationController presentViewController:vc animated:NO completion:nil];
     vc.imageSelect = ^(id obj){
     if (obj && [obj isKindOfClass:[UIImage class]]) {
     profileImage = obj;
     [self.profileImageBtn setImage:profileImage forState:UIControlStateNormal];
         [self uploadImage];
     }
     dispatch_async(dispatch_get_main_queue(), ^{
     [self dismissViewControllerAnimated:NO completion:nil];
     });
     };
}
- (void)uploadImage
{
    [DBPROFILE uploadImage:profileImage objectId:USERINFO.objectID withCompletionBlock:^{
        [DBPROFILE downloadImage];
    }];
//    [NetworkHelperClass uploadImage:profileImage isUserOrLoan:1 userId:USERINFO.userId sync:NO completion:^(id obj) {
//        
//    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
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
