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
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"loanIsProcessed"]) {
        [applyLoan setTitle:[NSString stringWithFormat:@"%@\nYour loan request is under process",SAND_CLOCK] forState:UIControlStateNormal];
        applyLoan.titleLabel.font = [UIFont systemFontOfSize:12];
        applyLoan.titleLabel.textAlignment = NSTextAlignmentCenter;
        applyLoan.titleLabel.numberOfLines = 0;
        applyLoan.hidden = NO;
        verificationButton.hidden = YES;

    }else if ([[NSUserDefaults standardUserDefaults] boolForKey:@"loanIsApproved"])
    {
       // Circle Progress
        applyLoan.hidden = NO;
        verificationButton.hidden = YES;


    }else if ([[NSUserDefaults standardUserDefaults]boolForKey:@"verificationCompleted"])
    {
        applyLoan.hidden = YES;
        verificationButton.hidden = NO;

    }else if ([[NSUserDefaults standardUserDefaults] boolForKey:@"loanIsCompleted"])
    {
        [applyLoan setTitle:[NSString stringWithFormat:@"%@\nApply Loan",INDIANRUPEES_UNICODE] forState:UIControlStateNormal];
        applyLoan.titleLabel.textAlignment = NSTextAlignmentCenter;
        applyLoan.titleLabel.numberOfLines = 0;

        applyLoan.hidden = NO;
        verificationButton.hidden = YES;

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark get credit score 

- (void)getCreditScore
{
    [PROFILEMACRO getUserCreditScore:^(id obj) {
        
    }];
}

#pragma button actions
- (IBAction)applyLoanAction:(id)sender
{
    [LOANMACRO loanEligibityForUserCompletion:^(id obj) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            ApplyLoanViewController *applyLoanVc = [self.storyboard instantiateViewControllerWithIdentifier:@"ApplyLoanVC"];
            applyLoanVc.loanObject = obj;
            [self.navigationController pushViewController:applyLoanVc animated:YES];
        }
        else{
            ErrorMessageWithTitle(@"Message", @"Sorry. You are not eligible ");
        }

    }];
}

#pragma mark Navigation Bar Button actions

- (void)onMenuAction:(UIBarButtonItem *)sender
{
    [self.navigationController.view endEditing:YES];
    if (!sender) {
        [self.menuContainerViewController closeSlideMenuCompletion:^{
            [[(id)self.menuContainerViewController.leftMenuViewController tableView] reloadData];
        }];
    }
    else{
        [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
            [[(id)self.menuContainerViewController.leftMenuViewController tableView] reloadData];
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
