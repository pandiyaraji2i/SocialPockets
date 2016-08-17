//
//  RegistrationViewController.m
//  SocialPockets
//
//  Created by Ideas2IT-GaneshM on 20/07/16.
//  Copyright © 2016 Pandiyaraj. All rights reserved.
//

#import "RegistrationViewController.h"
#import "SignatureViewController.h"
#import "VerifyAadharViewController.h"
#import "PANCardViewController.h"
#import "ProgressViewController.h"
@interface RegistrationViewController (){

}
//Aadhar card

@property (weak, nonatomic) IBOutlet UIButton *aadharCardBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *aadharViewHeightConstraimt;
@property (weak, nonatomic) IBOutlet UIView *aadharInnerView;
@property (weak, nonatomic) IBOutlet UIView *aadharUpdatedView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *aadharInnerViewHeightConstraint;

//Pancard

@property (weak, nonatomic) IBOutlet UIButton *pancardBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pancardViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *panCardInnerView;
@property (weak, nonatomic) IBOutlet UITextField *panNumberTF;

//SignatureView

@property (weak, nonatomic) IBOutlet UIButton *signatureBtn;

@end

@implementation RegistrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Registration";
    
    self.navigationController.navigationBar.tintColor  =[UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@" " style:UIBarButtonItemStylePlain target:self action:nil];
    
//#warning just for testing
//    firstNameTextField.text = @"kishore";
//    usernameTextField.text = @"kishore";
//    passwordTextField.text = @"kishore";
//    confirmPasswordTextField.text = @"kishore";
//    emailTextField.text = @"kishore@ideas2it.com";
//    phoneNumberTextField.text = @"9090909090";

    
    self.navigationController.navigationBarHidden = YES;
    [self updateRegView];
    [self.view updateConstraints];
    [self.view layoutIfNeeded];
    [self aadharBtnTapped:nil];
    [self pancardBtnTapped:nil];


//    self.aadharInnerView.hidden = NO;
//    self.aadharUpdatedView.hidden = YES;
    
    // Aadhar Card Gesture
    UITapGestureRecognizer *aadharCardTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(aadharCardImageTap:)];
    [self.aadharInnerView addGestureRecognizer:aadharCardTap];
    // PAN Card Gesture
    UITapGestureRecognizer *panCardTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(panCardImageTap:)];
    [self.panCardInnerView addGestureRecognizer:panCardTap];
    
    
    self.navigationController.navigationBarHidden = NO;
    profileImage = nil;
    self.profileImageBtn.layer.cornerRadius = (self.profileImageBtn.frame.size.height/2);
    self.profileImageBtn.layer.borderWidth = 3.0;
    self.profileImageBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.profileImageBtn.layer.masksToBounds = YES;
 
    self.userInfoView.layer.cornerRadius = 5.0;
    self.userInfoView.layer.masksToBounds = YES;
    
    self.nextBtn.layer.cornerRadius = 5;
    self.nextBtn.layer.masksToBounds = YES;
    if (TARGET_OS_SIMULATOR) {
        profileImage = [UIImage imageNamed:@"ProfileImage"];
    }
    
    //#-- Status Bar Color Change
    [self setNeedsStatusBarAppearanceUpdate];
    
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
    ProgressViewController *progressVc = [self.storyboard instantiateViewControllerWithIdentifier:@"ProgressVc"];
    [self.navigationController pushViewController:progressVc animated:YES];
    return;
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
            if ([obj isKindOfClass:[NSDictionary class]]) {
                // If success
                [NetworkHelperClass uploadImage:profileImage isUserOrLoan:1 userId:@"" sync:NO completion:^(id obj) {
                    if ([obj isKindOfClass:[NSDictionary class]]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            ProgressViewController *progressVc = [self.storyboard instantiateViewControllerWithIdentifier:@"progressVc"];
                            [self.navigationController pushViewController:progressVc animated:YES];
                        });
                    }
                }];
                //            // Call Otp
                //            [REGMACRO createOTPForPhoneNumber:phoneNumberTextField.text createdBy:@"userid" completion:^(id obj) {
                //                
                //            }];
            }
            else{
                ErrorMessageWithTitle(@"Message", obj);
            }
        }];
    }
}
- (IBAction)aadharBtnTapped:(id)sender {
    if (self.aadharCardBtn.selected) {
        self.aadharViewHeightConstraimt.constant = 300;
        self.aadharInnerView.hidden = NO;
        [self updateRegView];
    }else{
        self.aadharInnerView.hidden = YES;
        self.aadharUpdatedView.hidden = YES;
        self.aadharViewHeightConstraimt.constant = 40;
//        [self.view updateConstraints];
//        [self.view layoutIfNeeded];
        
    }
        self.aadharCardBtn.selected = !self.aadharCardBtn.selected;
}

- (IBAction)pancardBtnTapped:(id)sender {
    
    if (self.pancardBtn.selected) {
        self.pancardViewHeightConstraint.constant = 300;
        [self.view layoutIfNeeded];
        self.panCardInnerView.hidden = NO;
    }else{
        self.panCardInnerView.hidden = YES;
        self.pancardViewHeightConstraint.constant = 40;
        [self.view layoutIfNeeded];
    }
    self.pancardBtn.selected = !self.pancardBtn.selected;
}

- (IBAction)signatureBtnTapped:(id)sender {
    SignatureViewController *signatureVc = [self.storyboard instantiateViewControllerWithIdentifier:@"SignatureVc"];
    [self.navigationController pushViewController:signatureVc animated:YES];
    signatureVc.updateSignatureView = ^(void){
        [self updateRegView];
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Aadhar card image tapped

- (void)aadharCardImageTap:(UITapGestureRecognizer *)recognizer {
        VerifyAadharViewController *verifyAadharVc = [self.storyboard instantiateViewControllerWithIdentifier:@"VerifyAadharVc"];
        [self presentViewController:verifyAadharVc animated:YES completion:nil];
    verifyAadharVc.updateAadharView = ^(id obj){
        self.aadharUpdatedView.hidden = NO;
        self.aadharInnerView.hidden = YES;
        [self.aadharCardBtn setImage:[UIImage imageNamed:@"circleChecked"] forState:UIControlStateNormal];
        
    };
    
}
//PAN card image tapped

- (void)panCardImageTap:(UITapGestureRecognizer *)recognizer {
    PANCardViewController *verifyPanCardVc = [self.storyboard instantiateViewControllerWithIdentifier:@"PANCardVc"];
    [self presentViewController:verifyPanCardVc animated:YES completion:nil];
    verifyPanCardVc.updatePAN = ^(id obj){
        self.panNumberTF.text = obj;
        [self.pancardBtn setImage:[UIImage imageNamed:@"circleChecked"] forState:UIControlStateNormal];

    };
}

-(void)updateRegView{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"AadharCardUpdate"]){
        self.aadharInnerView.hidden = YES;
        self.aadharUpdatedView.hidden = NO;
          [self.aadharCardBtn setImage:[UIImage imageNamed:@"circleChecked"] forState:UIControlStateNormal];
    }else{
        self.aadharUpdatedView.hidden = YES;
    }
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"PanCardUpdate"]) {
        [self.pancardBtn setImage:[UIImage imageNamed:@"circleChecked"] forState:UIControlStateNormal];
    }
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"SignatureUpdate"]) {
                [self.signatureBtn setImage:[UIImage imageNamed:@"circleChecked"] forState:UIControlStateNormal];
            }
}

#pragma mark Status Bar Style
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

