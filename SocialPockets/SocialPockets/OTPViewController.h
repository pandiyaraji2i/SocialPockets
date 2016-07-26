//
//  OTPViewController.h
//  SocialPockets
//
//  Created by ideas2it-Kovendhan on 20/07/16.
//  Copyright © 2016 Pandiyaraj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OTPViewController : UIViewController
{
    IBOutlet UITextField *otpTextField;
    IBOutlet UILabel *otpTimer,*phoneNoLabel;
    IBOutlet UIButton *resendOTP;
    NSTimer *timer;
    int currSeconds;
}

@property (nonatomic, strong) NSString *phoneNumber;
@end
