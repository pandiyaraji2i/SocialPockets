//
//  DashBoardViewController.h
//  SocialPockets
//
//  Created by Pandiyaraj on 25/07/16.
//  Copyright © 2016 Pandiyaraj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DashBoardViewController : UIViewController
{
    IBOutlet NSLayoutConstraint *scoreLabelTopConstraint;
    IBOutlet NSLayoutConstraint *scoreBGHeightConstraint;
    IBOutlet NSLayoutConstraint *pointsButtonTopConstraint;
    IBOutlet NSLayoutConstraint *circleViewHeightConstraint;
    IBOutlet UIButton *verificationButton;
    IBOutlet UILabel *pointsCountLabel, * verifyLabel, *timeLabel;
    IBOutlet UIButton *zerothDigitScoreButton, *tenthDigitScoreButton, *hundredDigitScoreButton;
    IBOutlet UIButton *applyLoan,*repayLoanButton;
    BOOL isVerificationCompleted;
    IBOutlet UIView *scoreBGView;
}
@property (nonatomic, weak) IBOutlet UIButton *pointsButton;
@end
