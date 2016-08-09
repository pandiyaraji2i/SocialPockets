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

@end

@implementation DashBoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Social Pocket";
    
    //#-- Menu Button
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
    }else if (IPHONE5){
        scoreBGHeightConstraint.constant = 60;
        scoreLabelTopConstraint.constant = 10;
        pointsButtonTopConstraint.constant = 0 ;
        circleViewHeightConstraint.constant = 20;
    }
    else{
        scoreBGHeightConstraint.constant = 100;
        scoreLabelTopConstraint.constant = 25;
        pointsButtonTopConstraint.constant = 20;
        circleViewHeightConstraint.constant = 30;
    }
    
    isVerificationCompleted = YES;
    if (isVerificationCompleted) {
        //#-- Show apply loan
        [applyLoan setTitle:[NSString stringWithFormat:@"%@\nApply Loan",INDIANRUPEES_UNICODE] forState:UIControlStateNormal];
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
    
    [self getCreditScore];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
//    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isLoggedFirst"] ||  [[NSUserDefaults standardUserDefaults] boolForKey:@"loanIsCompleted"]) {
//        [self performSelector:@selector(verifyDocumentsCompleted) withObject:nil afterDelay:2.0];
//    }
    [self updateButtons];
}

- (void)viewWillDisappear:(BOOL)animated
{
   
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)verifyDocumentsCompleted
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"verificationCompleted"];
    [self updateButtons];
}

- (void)updateButtons
{
//    repayLoanButton.hidden = NO;
//    applyLoan.hidden = YES;
//    verificationButton.hidden = YES;
//    return;
    
    verifyLabel.hidden = YES;
    timeLabel.hidden = YES;
    repayLoanButton.hidden = YES;
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"loanIsProcessed"]) {
        [applyLoan setTitle:[NSString stringWithFormat:@"%@\nYour loan request is under process",SAND_CLOCK] forState:UIControlStateNormal];
        applyLoan.titleLabel.font = [UIFont systemFontOfSize:12];
        applyLoan.titleLabel.textAlignment = NSTextAlignmentCenter;
        applyLoan.titleLabel.numberOfLines = 0;
//        repayLoanButton.hidden = NO;
//        verificationButton.hidden = YES;
//        applyLoan.hidden = YES;
    }else if ([[NSUserDefaults standardUserDefaults] boolForKey:@"loanIsApproved"])
    {
        // Circle Progress
        verificationButton.hidden = YES;
        repayLoanButton.hidden = NO;
        applyLoan.hidden = YES;
        
    }/*else if ([[NSUserDefaults standardUserDefaults]boolForKey:@"isLoggedFirst"])
    {
        applyLoan.hidden = YES;
        verificationButton.hidden =NO;
    }*/else if ([[NSUserDefaults standardUserDefaults] boolForKey:@"loanIsCompleted"] || [[NSUserDefaults standardUserDefaults] boolForKey:@"isLoggedFirst"])
    {
        [applyLoan setTitle:[NSString stringWithFormat:@"%@\nApply Loan",INDIANRUPEES_UNICODE] forState:UIControlStateNormal];
        applyLoan.titleLabel.textAlignment = NSTextAlignmentCenter;
        applyLoan.titleLabel.numberOfLines = 0;
        
        applyLoan.hidden = NO;
        verificationButton.hidden = YES;
        verifyLabel.hidden = YES;
        timeLabel.hidden = YES;
        
    }
}

#pragma mark get credit score 

- (void)getCreditScore
{
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

- (void)updateCrediScore:(NSString *)creditScore
{
    if (creditScore.length < 3) {
        creditScore = [@"0" stringByAppendingString:creditScore];
    }
    int length = (int)(creditScore.length-1);
    for(int i= length; i>=0; i--) {
        char character = [creditScore characterAtIndex:i];
        NSString *titleStr = [NSString stringWithFormat:@"%c",character];
//        NSLog(@"%c",character);
//        CGRect scoreBGRect = scoreBGView.frame;
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.center = scoreBGView.center;
//        button.frame = CGRectMake(75,3, 48, 54);
//        [button setTitle:titleStr forState:UIControlStateNormal];
//        [button setBackgroundImage:[UIImage imageNamed:@"ScoreBG"] forState:UIControlStateNormal];
//        [scoreBGView addSubview:button];
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
/*
 - (void) evenlySpaceTheseButtonsInThisView : (int) buttonCount : (UIView *) thisView {
    int widthOfAllButtons = 0;
    for (int i = 0; i < buttonCount; i++) {
        UIButton *thisButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [thisButton setBackgroundImage:[UIImage imageNamed:@"ScoreBG"] forState:UIControlStateNormal];
        [thisButton setTitle:@"1" forState:UIControlStateNormal];

        [thisButton setCenter:CGPointMake(0, thisView.frame.size.height / 2.0)];
        widthOfAllButtons = widthOfAllButtons + thisButton.frame.size.width;
    }
    
    int spaceBetweenButtons = (thisView.frame.size.width - widthOfAllButtons) / (buttonCount + 1);
    
    UIButton *lastButton = nil;
    for (int i = 0; i < buttonCount; i++) {
        UIButton *thisButton = [UIButton buttonWithType:UIButtonTypeCustom];
        if (lastButton == nil) {
            [thisButton setFrame:CGRectMake(spaceBetweenButtons, thisButton.frame.origin.y, thisButton.frame.size.width, thisButton.frame.size.height)];
        } else {
            [thisButton setFrame:CGRectMake(spaceBetweenButtons + lastButton.frame.origin.x + lastButton.frame.size.width, thisButton.frame.origin.y, thisButton.frame.size.width, thisButton.frame.size.height)];
        }
        [thisButton setBackgroundImage:[UIImage imageNamed:@"ScoreBG"] forState:UIControlStateNormal];
        [thisButton setTitle:@"1" forState:UIControlStateNormal];
        lastButton = thisButton;
    }
}
*/
 #pragma button actions
- (IBAction)applyLoanAction:(id)sender
{
    UIButton *button = sender;
    if ([button.titleLabel.text rangeOfString:@"under"].length) {
//        ErrorMessageWithTitle(@"Message", @"Your previous loan request is already processed");
        return;
    }
    
    
    [LOANMACRO loanEligibityForUserCompletion:^(id obj) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            ApplyLoanViewController *applyLoanVc = [self.storyboard instantiateViewControllerWithIdentifier:@"ApplyLoanVC"];
            applyLoanVc.loanObject = obj;
            [self.navigationController pushViewController:applyLoanVc animated:YES];
        }
        else{
            ErrorMessageWithTitle(@"Message", obj);
        }

    }];
}

- (IBAction)repayLoanButton:(id)sender
{
    [LOANMACRO loanEligibityForUserCompletion:^(id obj) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            RepayLoanViewController *repayLoanVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RepayLoanVC"];
            repayLoanVC.repayObject = obj;
            [self.navigationController pushViewController:repayLoanVC animated:YES];
        }
        else{
            ErrorMessageWithTitle(@"Message", obj);
        }
        
    }];
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
//            [[(id)self.menuContainerViewController.leftMenuViewController tableView] reloadData];
        }];
    }
}

- (void)onNotificationAction
{
    NotificationViewController *notificationVc = [self.storyboard instantiateViewControllerWithIdentifier:@"NotificationVc"];
    [self.navigationController pushViewController:notificationVc animated:YES];
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
