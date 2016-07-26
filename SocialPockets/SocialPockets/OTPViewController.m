//
//  OTPViewController.m
//  SocialPockets
//
//  Created by ideas2it-Kovendhan on 20/07/16.
//  Copyright © 2016 Pandiyaraj. All rights reserved.
//

#import "OTPViewController.h"

@interface OTPViewController ()

@end

@implementation OTPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    resendOTP.hidden = YES;
    [self start];
    self.navigationController.navigationBarHidden = NO;
    // Do any additional setup after loading the view.
}
//- (IBAction)CreateOTPBtnTapped:(id)sender {
//    [REGMACRO createOTPForPhoneNumber:self.phoneNumber createdBy:@"25" completion:^(id obj) {
//        NSLog(@"creates OTP: %@",obj);
//    }];
//}
- (IBAction)VerifyOTPBtnTapped:(id)sender {
    if (!otpTextField.text.length) {
       // Enter otp
    }
    else
    {
        [REGMACRO verifyOTPForPhoneNumber:self.phoneNumber generatedCode:otpTextField.text completion:^(id obj) {
            NSLog(@"OTP verification :%@",obj);
        }];
    }
   
}
- (IBAction)ResendOTPBtnTapped:(id)sender {
    resendOTP.hidden = YES;

    [REGMACRO resendOTPForPhoneNumber:self.phoneNumber createdBy:@"25" completion:^(id obj) {
        NSLog(@"creates OTP: %@",obj);
    }];
    [self start];
}

-(void)start
{
    currSeconds = 20;
    timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    
}
-(void)timerFired
{
    if((currSeconds>0))
    {
        currSeconds-=1;
        [otpTimer setText:[NSString stringWithFormat:@"%d Sec",currSeconds]];
    }
    else
    {
        [timer invalidate];
        resendOTP.hidden = NO;
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
