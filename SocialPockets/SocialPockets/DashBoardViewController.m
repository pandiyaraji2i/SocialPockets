//
//  DashBoardViewController.m
//  SocialPockets
//
//  Created by Pandiyaraj on 25/07/16.
//  Copyright © 2016 Pandiyaraj. All rights reserved.
//

#import "DashBoardViewController.h"
#import "NotificationViewController.h"
#import "ApplyLoanViewController.h"
#import "RepayLoanViewController.h"

@interface DashBoardViewController ()
{
    NSDictionary *loanObject;
    double red , green, blue;
    double finalRed , finalGreen, finalBlue;
}
@end

@implementation DashBoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Social Pocket";
    //    //#-- Menu Button
    
    
    
    //    //#-- Menu Button
    UIButton *hamburgerMenuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    hamburgerMenuButton.frame = CGRectMake(0, 0, 22, 16);
    [hamburgerMenuButton setImage:[UIImage imageNamed:@"HamburgerMenu"] forState:UIControlStateNormal];
    [hamburgerMenuButton addTarget:self action:@selector(onMenuAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:hamburgerMenuButton];
    
    //#-- Notification Button
    UIButton *notificationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    notificationButton.frame = CGRectMake(0, 5, 21, 21);
    [notificationButton setBackgroundImage:[UIImage imageNamed:@"Notifications"] forState:UIControlStateNormal];
    [notificationButton setTitle:@"2" forState:UIControlStateNormal];
    notificationButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [notificationButton addTarget:self action:@selector(onNotificationAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem  =[[UIBarButtonItem alloc]initWithCustomView:notificationButton];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@" " style:UIBarButtonItemStylePlain target:self action:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivePushNotification:) name:@"ReceivedPushNotification" object:nil];

    //#-- Status Bar Color Change
    [self setNeedsStatusBarAppearanceUpdate];
    
    self.pointsButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.pointsButton.layer.borderWidth = 1.0;
    
    if (IPHONE4)
    {
        scoreBGHeightConstraint.constant = 40;
        scoreLabelTopConstraint.constant = 0;
        pointsButtonTopConstraint.constant = -30;
        circleViewHeightConstraint.constant = 10;
        repayCircleViewHeightConstraint.constant = 10;
    }else if (IPHONE5){
        scoreBGHeightConstraint.constant = 60;
        scoreLabelTopConstraint.constant = 10;
        pointsButtonTopConstraint.constant = 0 ;
        circleViewHeightConstraint.constant = 20;
        repayCircleViewHeightConstraint.constant = 20;
    }
    else{
        scoreBGHeightConstraint.constant = 90;
        scoreLabelTopConstraint.constant = 25;
        pointsButtonTopConstraint.constant = 30;
        circleViewHeightConstraint.constant = 60;
        repayCircleViewHeightConstraint.constant = 60;
//        zerothLeadingConstraint.constant = hundredthTrailingConstraint.constant =30;
//        buttonHeightConstraint.constant = 69;
//        buttonWidthConstraint.constant = 100;
        tenthDigitScoreButtonHeightConstraint.constant = 69;
        tenthDigitScoreButtonWidthConstraint.constant = 62;
        
    }
    
    isVerificationCompleted = YES;
    if (isVerificationCompleted) {
        //#-- Show apply loan
        [applyLoan setImage:[UIImage imageNamed:@"Rupees"] forState:UIControlStateNormal];
        [applyLoan setImageEdgeInsets:UIEdgeInsetsMake(-25, 37.5, 0, 0)];
        [applyLoan setTitleEdgeInsets:UIEdgeInsetsMake(30, -15, 0, 0)];
        [applyLoan setTitle:[NSString stringWithFormat:@"APPLY LOAN"] forState:UIControlStateNormal];
//        [applyLoan setTitle:[NSString stringWithFormat:@"%@\nAPPLY LOAN",INDIANRUPEES_UNICODE] forState:UIControlStateNormal];
        applyLoan.titleLabel.textAlignment = NSTextAlignmentCenter;
        applyLoan.titleLabel.numberOfLines = 0;
        applyLoan.hidden = NO;
        verificationButton.hidden = YES;
    }
    else{
        //#-- Verification is still processing
        applyLoan.hidden = YES;
        verificationButton.hidden = NO;
    }
    
    
    [self updateViewConstraints];
    
//    [self setupMenuBarButtonItems];
    
    [self getCreditScore];
    [self setDeviceDetail];
    
    [DBPROFILE downloadImage];
    // Do any additional setup after loading the view.
}

#pragma mark barbutton items
/*- (void)setupMenuBarButtonItems {
    if(self.menuContainerViewController.menuState == MFSideMenuStateLeftMenuOpen) {
        [[(id)self.menuContainerViewController.leftMenuViewController tableView] reloadData];
        //        self.navigationItem.leftBarButtonItem = [self leftMenuBarButtonItem:YES];
    } else {
         [[(id)self.menuContainerViewController.leftMenuViewController tableView] reloadData];
//        self.navigationItem.leftBarButtonItem = [self leftMenuBarButtonItem:NO];
    }
}*/
- (UIBarButtonItem *)leftMenuBarButtonItem : (BOOL)isClose{
    
    NSString *imgName;
    UIButton *hamburgerMenuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if (isClose) {
        hamburgerMenuButton.frame = CGRectMake(0, 0, 23, 24);
        imgName = @"NavClose";
    }else{
        hamburgerMenuButton.frame = CGRectMake(0, 0, 22, 16);
        imgName = @"HamburgerMenu";
    }
    [hamburgerMenuButton setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    [hamburgerMenuButton addTarget:self action:@selector(onMenuAction:) forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc]initWithCustomView:hamburgerMenuButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self updateButtons];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isLoanRepaid"]) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLoanRepaid"];
        [self getUserLoanStatus];
    }
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isLoanProcessed"]) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLoanProcessed"];
        [self getUserLoanStatus];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Receive Notifications

- (void)receivePushNotification:(NSNotification *)notification
{
    NSLog(@"User Info %@",[notification object]);
    NSDictionary *jsonObject = [notification object];
    
    if ([jsonObject isKindOfClass:[NSDictionary class]]) {
        NSString *pushKey = [jsonObject valueForKey:@"LOC_KEY"];
        NSString *loanId = [jsonObject valueForKey:@"USRLN_ID"];
        if ([pushKey isEqualToString:@"PUSH_UA"] || [pushKey isEqualToString:@"PUSH_UR"]) {
            [PROFILEMACRO getUserInformation:^(id obj) {
                if ([obj isKindOfClass:[NSDictionary class]]) {
                    [DBPROFILE generateUserInfo:obj forUser:USERINFO.userId];
                    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"documentsVerificationProcess"];
                    [self updateButtons];
                }
            }];
            
        }
        else if ([pushKey isEqualToString:@"PUSH_ULR"])
        {
            
        }
        else if ([pushKey isEqualToString:@"PUSH_ULA"])
        {

        }
        else if ([pushKey isEqualToString:@"PUSH_ULRPA"] || [pushKey isEqualToString:@"PUSH_ULRPR"])
        {
//            [TRANSACTHISTORY getIndividualLoan:loanId completion:^(id obj) {
//                
//            }];
        }
        
        [self getUserLoanStatus];
//        [TRANSACTHISTORY getIndividualLoan:loanId completion:^(id obj) {
//            
//        }];
        
    }
}

#pragma mark set device detail

- (void)setDeviceDetail{
    [LOGINMACRO setDeviceForId:[[NSUserDefaults standardUserDefaults] valueForKey:USERID] completion:^(id obj) {
        NSLog(@"%@",obj);
    }];
}



#pragma mark get credit score

- (void)getCreditScore
{
    [ACTIVITY showActivity:@"Getting Credit score details"];
    [self performSelector:@selector(getCreditScoreDetails) withObject:nil afterDelay:0.2];
}

- (void)getCreditScoreDetails
{
    [self getUserLoanStatus];

    if ([NetworkHelperClass getInternetStatus:NO]) {
        [PROFILEMACRO getUserCreditScore:^(id obj) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                NSString *stringValue = [NSString stringWithFormat:@"%@",[obj valueForKey:@"USRCS_SCORE"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self updateCrediScore:stringValue];
                    id messageObj = [obj valueForKey:@"messages"];
                    pointsCountLabel.text = [NSString stringWithFormat:@"%@",[messageObj valueForKey:@"MESSAGE"]];
                    [self.pointsButton setTitle:[NSString stringWithFormat:@"%@ Points",[messageObj valueForKey:@"NEEDED_CREDIT_SCORE"]] forState:UIControlStateNormal];
                });
            }else{
                
            }
            
        }];
    }else{
        
    }
}

- (void)getUserLoanStatus
{
    
    [LOANMACRO getUserCurrentLoanStatusWithCompletionBlock:^(id obj) {
        if ([obj isKindOfClass:[NSString class]] || ![obj count]) {
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"loanIsProcessed"];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"loanIsApproved"];
            if ([USERINFO.user_eligible_status integerValue] == 1) {
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"readyToApply"];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"documentsVerificationProcess"];

            }else{
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"readyToApply"];
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"documentsVerificationProcess"];
            }
        }
        else{
            [TRANSACTHISTORY updateTransactionHistory:obj];
            loanObject = [obj lastObject];
            int loanStatus =[[loanObject valueForKey:@"USRLN_STATUS"] intValue];
            if ([[loanObject valueForKey:@"loanrepayment"] isKindOfClass:[NSDictionary class]]) {
                loanStatus = 4;
            }
            switch (loanStatus) {
                case 0: case 3: case 4: case 5:
                {
                    //#-- Loan either closed or loan repaid
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"readyToApply"];
                    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"loanIsApproved"];
                    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"loanIsProcessed"];
                    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"documentsVerificationProcess"];

                    break;
                }
                case 1:
                {
                    //#-- Loan is processed
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"loanIsProcessed"];
                    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"readyToApply"];
                    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"loanIsApproved"];
                    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"documentsVerificationProcess"];

                    break;
                }
                case 2:
                {
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"loanIsApproved"];
                    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"loanIsProcessed"];
                    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"readyToApply"];
                    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"documentsVerificationProcess"];
                    //#-- Loan is approved
                    break;
                }
                default:
                    break;
            }
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateButtons];
        });
        [ACTIVITY performSelectorOnMainThread:@selector(hideActivity) withObject:nil waitUntilDone:YES];
    }];

}

- (void)updateButtons
{
    verifyLabel.hidden = YES;
    timeLabel.hidden = YES;
    verificationButton.hidden = YES;
    applyLoanCircleView.hidden = NO;
    repayLoanCircleView.hidden = YES;
    applyLoan.titleLabel.textAlignment = NSTextAlignmentCenter;
    applyLoan.titleLabel.numberOfLines = 0;
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"documentsVerificationProcess"] || [USERINFO.user_eligible_status integerValue] == 1) {
        //#-- Documents verification process
        verifyLabel.hidden = NO;
        timeLabel.hidden = NO;
        verificationButton.hidden = NO;
        applyLoan.hidden  = repayLoanButton.hidden = YES;
    }
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"readyToApply"] || [USERINFO.user_eligible_status integerValue] == 2) {
        //#-- Ready to apply loan
        applyLoan.hidden = NO;
        repayLoanButton.hidden = YES;
        applyLoan.userInteractionEnabled = YES;
        [applyLoan setImage:[UIImage imageNamed:@"Rupees"] forState:UIControlStateNormal];
        [applyLoan setImageEdgeInsets:UIEdgeInsetsMake(-25, 37.5, 0, 0)];
        [applyLoan setTitleEdgeInsets:UIEdgeInsetsMake(30, -15, 0, 0)];
        [applyLoan setTitle:[NSString stringWithFormat:@"APPLY LOAN"] forState:UIControlStateNormal];
    }
//
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"loanIsProcessed"]) {
        //#-- User requested loan.. and it is processed
        applyLoan.hidden = NO;
        repayLoanButton.hidden = YES;
        [applyLoan setImage:[UIImage imageNamed:@"SandClock"] forState:UIControlStateNormal];
        [applyLoan setImageEdgeInsets:UIEdgeInsetsMake(-40, 40, 0, 0)];
        [applyLoan setTitleEdgeInsets:UIEdgeInsetsMake(35,  -15, 0, 0)];
        [applyLoan setTitle:[NSString stringWithFormat:@"Your loan request is under process"] forState:UIControlStateNormal];
//        [applyLoan setTitle:[NSString stringWithFormat:@"%@\nYour loan request is under process",SAND_CLOCK] forState:UIControlStateNormal];
        applyLoan.titleLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:12];
        applyLoan.userInteractionEnabled = NO;
    }
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"loanIsApproved"]) {
        //#-- Loan approved by admin.. Repayment to be done
        applyLoan.hidden = YES;
        repayLoanButton.hidden = NO;
        //#-- Circle Progress come in
        repayLoanCircleView.hidden = NO;
        applyLoanCircleView.hidden = YES;
        //        repayLoanCircleView.trackFillColor = [self interpolateRGBColorFrom:[UIColor orangeColor] to:[UIColor greenColor] withFraction:1.0];
        repayLoanCircleView.clockwise = YES;
        repayLoanCircleView.progress = 0.9;
        NSString *loanAmount = [[NSString stringWithFormat:@"%@",[loanObject valueForKey:@"USRLN_AMOUNT"]] rupeesFormat];
        repayLoanCircleView.centerText = [NSString stringWithFormat:@"%@ %@   Repay Loan 14 Days left",INDIANRUPEES_UNICODE,loanAmount];
        __weak DashBoardViewController *dashBoardVc= self;
        __block id loanBlockObject = loanObject;
        repayLoanCircleView.onClick = ^(NSString* menuTitle)
        {
            if (menuTitle.length) {
                [dashBoardVc repayLoanButton:loanBlockObject];
            }
        };
    }
}
- (void)updateCrediScore:(NSString *)creditScore
{
    if (creditScore.length < 3) {
        creditScore = [@"0" stringByAppendingString:creditScore];
    }
    int length = (int)(creditScore.length-1);
    for(int i= length; i>=0; i--) {
        char character = [creditScore characterAtIndex:i];
        NSString *titleStr = [NSString stringWithFormat:@"%c",character];
        switch ((creditScore.length-1) - i) {
            case 4:
                [zerothDigitScoreButton setTitle:titleStr forState:UIControlStateNormal];
                break;
            case 3:
                [zerothDigitScoreButton setTitle:titleStr forState:UIControlStateNormal];
                break;
            case 2:
                [hundredDigitScoreButton setTitle:titleStr forState:UIControlStateNormal];
                break;
            case 1:
                [tenthDigitScoreButton setTitle:titleStr forState:UIControlStateNormal];
                break;
            case 0:
                [zerothDigitScoreButton setTitle:titleStr forState:UIControlStateNormal];
                break;
            default:
                break;
        }
    }
}
#pragma button actions
- (IBAction)applyLoanAction:(id)sender
{
    [ACTIVITY showActivity:@"Loading..."];
    [self performSelector:@selector(applyloan) withObject:nil afterDelay:0.2];
}

- (void)applyloan
{
    [LOANMACRO loanEligibityForUserCompletion:^(id obj) {
        [ACTIVITY performSelectorOnMainThread:@selector(hideActivity) withObject:nil waitUntilDone:YES];
        if ([obj isKindOfClass:[NSDictionary class]]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                ApplyLoanViewController *applyLoanVc = [self.storyboard instantiateViewControllerWithIdentifier:@"ApplyLoanVC"];
                applyLoanVc.loanObject = obj;
                [self.navigationController pushViewController:applyLoanVc animated:YES];
            });
        }
        else{
            ErrorMessageWithTitle(@"Message", obj);
        }
    }];
}
- (IBAction)repayLoanButton:(id)sender
{
    RepayLoanViewController *repayLoanVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RepayLoanVC"];
    repayLoanVC.repayLoanObject = loanObject;
    [self.navigationController pushViewController:repayLoanVC animated:YES];
}

#pragma mark Navigation Bar Button actions

- (void)onMenuAction:(UIBarButtonItem *)sender
{
    [self.navigationController.view endEditing:YES];
    if (!sender) {
        [self.menuContainerViewController closeSlideMenuCompletion:^{
//            [[(id)self.menuContainerViewController.leftMenuViewController tableView] reloadData];
        }];
    }
    else{
        [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
//            [self setupMenuBarButtonItems];
//            [[(id)self.menuContainerViewController.leftMenuViewController tableView] reloadData];
        }];
    }
}

- (void)onNotificationAction
{
    NotificationViewController *notificationVc = [self.storyboard instantiateViewControllerWithIdentifier:@"NotificationVc"];
    [self.navigationController pushViewController:notificationVc animated:YES];
}


#pragma mark color change
- (UIColor *)interpolateRGBColorFrom:(UIColor *)start to:(UIColor *)end withFraction:(float)f {
    
    f = MAX(0, f);
    f = MIN(1, f);
    
    const CGFloat *c1 = CGColorGetComponents(start.CGColor);
    const CGFloat *c2 = CGColorGetComponents(end.CGColor);
    
    CGFloat r = c1[0] + (c2[0] - c1[0]) * f;
    CGFloat g = c1[1] + (c2[1] - c1[1]) * f;
    CGFloat b = c1[2] + (c2[2] - c1[2]) * f;
    CGFloat a = c1[3] + (c2[3] - c1[3]) * f;
    
    return [UIColor colorWithRed:r green:g blue:b alpha:a];
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
