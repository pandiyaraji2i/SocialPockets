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
#import "QRScanViewController.h"
#import "SocialSiteViewController.h"
@interface RegistrationViewController ()<UITextFieldDelegate>{
    
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
@property (weak, nonatomic) IBOutlet UIView *panCardUpdateView;
@property (weak, nonatomic) IBOutlet UILabel *typeYourPANLbl;

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
        profileImage = [UIImage imageNamed:@"rating.jpg"];
    }
    
    [self setStatusBarBackgroundColor:[UIColor blackColor]];
    
    //#-- Status Bar Color Change
    [self setNeedsStatusBarAppearanceUpdate];
    // Do any additional setup after loading the view.
    if (IPHONE6_STANDARD || IPHONE6_ZOOMED || IPHONE6PLUS_STANDARD || IPHONE6PLUS_ZOOMED) {
        [self.aadharCardBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,-245, 0, 0)];
        [self.aadharCardBtn setImageEdgeInsets:UIEdgeInsetsMake(0,280, 0, 0)];
        
        [self.pancardBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,-260, 0, 0)];
        [self.pancardBtn setImageEdgeInsets:UIEdgeInsetsMake(0,280, 0, 0)];
        
        [self.signatureBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,-246, 0, 0)];
        [self.signatureBtn setImageEdgeInsets:UIEdgeInsetsMake(0,280, 0, 0)];
    }
    
}

- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
    [[UIApplication  sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
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
    SocialSiteViewController *socialVc =[self.storyboard instantiateViewControllerWithIdentifier:@"SocialVc"];
    [self.navigationController pushViewController:socialVc animated:YES];
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
        [ACTIVITY showActivity:@"Loading..."];
        [self performSelector:@selector(registerAction) withObject:nil afterDelay:1.0];
    }
}
- (void)registerAction
{
    
    [REGMACRO registerWithName:firstNameTextField.text userName:usernameTextField.text email:emailTextField.text password:passwordTextField.text phoneNumber:phoneNumberTextField.text completion:^(id obj) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            // If success
            [self updateObjectToDatabase:obj];
            [NetworkHelperClass uploadImage:profileImage isUserOrLoan:1 userId:[obj valueForKey:@"USER_ID"] sync:NO completion:^(id obj) {
                if ([obj isKindOfClass:[NSDictionary class]]) {
#warning need to change user.
                    [self updateObjectToDatabase:[obj valueForKey:@"user"]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        ProgressViewController *progressVc = [self.storyboard instantiateViewControllerWithIdentifier:@"ProgressVc"];
                        [self.navigationController pushViewController:progressVc animated:YES];
                    });
                }else{
                    ErrorMessageWithTitle(@"Message", obj);
                }
                [ACTIVITY performSelectorOnMainThread:@selector(hideActivity) withObject:nil waitUntilDone:YES];
            }];
            //            // Call Otp
            //            [REGMACRO createOTPForPhoneNumber:phoneNumberTextField.text createdBy:@"userid" completion:^(id obj) {
            //
            //            }];
        }
        else{
            [ACTIVITY performSelectorOnMainThread:@selector(hideActivity) withObject:nil waitUntilDone:NO];
            ErrorMessageWithTitle(@"Message", obj);
        }
    }];
    
}
- (void)updateObjectToDatabase:(id)obj
{
    [[NSUserDefaults standardUserDefaults] setObject:obj forKey:@"USERINFO"];
    [[NSUserDefaults standardUserDefaults] setObject:[obj valueForKey:@"USER_ID"] forKey:USERID];
    [[NSUserDefaults standardUserDefaults] setObject:[obj valueForKey:@"USER_NAME"] forKey:USERNAME];
    [[NSUserDefaults standardUserDefaults] setObject:[obj valueForKey:@"USER_EMAIL"] forKey:USEREMAIL];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSString *userId = [NSString stringWithFormat:@"%@",[obj valueForKey:@"USER_ID"]];
    if (userId.length)
    {
        if (USERINFO.userId.length && ![USERINFO.userId isEqualToString:userId]) {
            [DBPROFILE clearForNewUser];
            [DATABASE.managedObjectContext deleteObject:USERINFO];
            DBPROFILE.userInfo=nil;
        }
        USERINFO;
        NSManagedObjectContext *profileContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [profileContext performBlockAndWait:^{
            profileContext.parentContext = DATABASE.managedObjectContext;
            UserDetails *tempUser = (id)[profileContext objectWithID:USERINFO.objectID];
            tempUser.userId = userId;
            [DBPROFILE generateUserInfo:obj forUser:tempUser.userId];
            [DATABASE dbSaveRecordChildContext:profileContext];
            [DBPROFILE downloadImage];
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
        self.panCardUpdateView.hidden = YES;
        self.typeYourPANLbl.hidden = NO;
        self.pancardViewHeightConstraint.constant = 40;
        [self.view layoutIfNeeded];
    }
    self.pancardBtn.selected = !self.pancardBtn.selected;
}

- (IBAction)signatureBtnTapped:(id)sender {
    SignatureViewController *signatureVc = [self.storyboard instantiateViewControllerWithIdentifier:@"SignatureVc"];
    [self.navigationController pushViewController:signatureVc animated:YES];
    signatureVc.updateSignatureView = ^(void){
        self.aadharCardBtn.selected = !self.aadharCardBtn.selected;
        [self updateRegView];
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Aadhar card image tapped

- (void)aadharCardImageTap:(UITapGestureRecognizer *)recognizer {
    
//    QRScanViewController *QRScanVc = [self.storyboard instantiateViewControllerWithIdentifier:@"QRScanVc"];
//    [self.navigationController pushViewController:QRScanVc animated:YES];
    
//    QRScanVc.updateAadharView = ^(id obj){
//        self.aadharUpdatedView.hidden = NO;
//        self.aadharInnerView.hidden = YES;
//        [self updateLabelsWithDict:obj];
//        [self.aadharCardBtn setImage:[UIImage imageNamed:@"circleChecked"] forState:UIControlStateNormal];
//        
//    };
    
    //    [self presentViewController:QRScanVc animated:YES completion:nil];
    
    
    
    //        VerifyAadharViewController *verifyAadharVc = [self.storyboard instantiateViewControllerWithIdentifier:@"VerifyAadharVc"];
    //        [self presentViewController:verifyAadharVc animated:YES completion:nil];
    //    verifyAadharVc.updateAadharView = ^(id obj){
    //        self.aadharUpdatedView.hidden = NO;
    //        self.aadharInnerView.hidden = YES;
    //        [self.aadharCardBtn setImage:[UIImage imageNamed:@"circleChecked"] forState:UIControlStateNormal];
    //
    //    };
    
}
//PAN card image tapped

- (void)panCardImageTap:(UITapGestureRecognizer *)recognizer {
    PANCardViewController *verifyPanCardVc = [self.storyboard instantiateViewControllerWithIdentifier:@"PANCardVc"];
    [self presentViewController:verifyPanCardVc animated:YES completion:nil];
    verifyPanCardVc.updatePAN = ^(id obj){
        self.panNumberTF.text = obj;
        self.panCardUpdateView.hidden = NO;
        self.typeYourPANLbl.hidden  = YES;
        [self.pancardBtn setImage:[UIImage imageNamed:@"circleChecked"] forState:UIControlStateNormal];
        
    };
}

-(void)updateRegView{
    if (self.aadharCardBtn.selected) {
        self.aadharViewHeightConstraimt.constant = 300;
        self.aadharInnerView.hidden = NO;
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"AadharCardUpdate"]){
        self.aadharInnerView.hidden = YES;
        self.aadharUpdatedView.hidden = NO;
        [self.aadharCardBtn setImage:[UIImage imageNamed:@"circleChecked"] forState:UIControlStateNormal];
    }else{
        self.aadharUpdatedView.hidden = YES;
    }
    }else{
        self.aadharInnerView.hidden = YES;
        self.aadharUpdatedView.hidden = YES;
        self.aadharViewHeightConstraimt.constant = 40;
    }
    
        
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"PanCardUpdate"]) {
        self.panCardUpdateView.hidden = NO;
        self.typeYourPANLbl.hidden = YES;
        [self.pancardBtn setImage:[UIImage imageNamed:@"circleChecked"] forState:UIControlStateNormal];
    }
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"SignatureUpdate"]) {
        [self.signatureBtn setImage:[UIImage imageNamed:@"circleChecked"] forState:UIControlStateNormal];
    }
}
# pragma Textfield validation

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    // verify the text field you wanna validate
    if (!(textField == NULL)) {
        
        // do not allow the first character to be space | do not allow more than one space
        if ([string isEqualToString:@" "]) {
            if (!textField.text.length)
                return NO;
            if ([[textField.text stringByReplacingCharactersInRange:range withString:string] rangeOfString:@"  "].length)
                return NO;
        }
        
        // allow backspace
        if ([textField.text stringByReplacingCharactersInRange:range withString:string].length < textField.text.length) {
            return YES;
        }
        
        // in case you need to limit the max number of characters
        if ([textField.text stringByReplacingCharactersInRange:range withString:string].length > 10) {
            return NO;
        }
        return YES;
    }
    
    return YES;
}

-(void)updateLabelsWithDict:(NSDictionary *)dict{
    self.nameLbl.text = [[[dict objectForKey:@"_name"] componentsSeparatedByString:@" "] objectAtIndex:0];
    self.fatherLbl.text = [[[dict objectForKey:@"_co"] componentsSeparatedByString:@" "] objectAtIndex:1];
    if ([[dict objectForKey:@"_gender"] isEqualToString:@"M"]) {
        self.genderLbl.text = @"Male";
    }else{
        self.genderLbl.text = @"Female";
    }
    self.genderLbl.text = [dict objectForKey:@"_gender"];
    self.dobLbl.text = [dict objectForKey:@"_yob"];
    self.addressLbl.text = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@",[dict objectForKey:@"_street"],[dict objectForKey:@"_lm"],[dict objectForKey:@"_loc"],[dict objectForKey:@"_dist"],[dict objectForKey:@"_state"],[dict objectForKey:@"_pc"]];
    
    self.aadharNumderLbl.text = [self aadharNumberWithFormat: [dict objectForKey:@"_uid"]];
    
}
- (NSString *)aadharNumberWithFormat:(NSString*)originalString {
    NSMutableString *resultString = [NSMutableString string];
    
    for(int i = 0; i<[originalString length]/4; i++)
    {
        NSUInteger fromIndex = i * 4;
        NSUInteger len = [originalString length] - fromIndex;
        if (len > 4) {
            len = 4;
        }
        
        [resultString appendFormat:@"%@    ",[originalString substringWithRange:NSMakeRange(fromIndex, len)]];
    }
    return resultString;
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

