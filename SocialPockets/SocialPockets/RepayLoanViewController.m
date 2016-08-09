//
//  RepayLoanViewController.m
//  SocialPockets
//
//  Created by Ideas2IT-GaneshM on 28/07/16.
//  Copyright © 2016 Pandiyaraj. All rights reserved.
//

#import "RepayLoanViewController.h"

@interface RepayLoanViewController ()
{
    NSString *repayLoanId;
    
}
- (IBAction)RepayBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *blackoutview;
@property (weak, nonatomic) IBOutlet UIView *thanksview;
@property (weak, nonatomic) IBOutlet UIButton *repay;


@end
@implementation RepayLoanViewController
@synthesize repayLoanObject;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = NO;
    self.title = @"Repay Loan";
    self.blackoutview.hidden = YES;
    self.thanksview.hidden = YES;
//    self.processingFeeAmount.text = [NSString stringWithFormat:@"%@%% Processing Fee Deduction",[self.repayObject valueForKey:@"PROCESSING_FEE"]];
//    self.tenurePeriod.text = [NSString stringWithFormat:@"%@ Days Tenure Period",[self.repayObject valueForKey:@"TENURE_DATE"]];
    
    self.processingFeeAmount.text = [NSString stringWithFormat:@"6 %% Processing Fee Deduction"];
    self.tenurePeriod.text = [NSString stringWithFormat:@"21 Days Tenure Period"];
    
//    [LOANMACRO getIndividualLoan:repayLoanId completion:^(id obj) {
    
        self.loanTakenDate.text = [SharedMethods convertString:[NSString stringWithFormat:@"%@",[repayLoanObject valueForKey:@"USRLN_TRANSFERRED_DATE"]] fromFormat:LOCALDATETIMEFORMAT toFormat:DATEFORMAT]; ;
        self.loanDueDate.text =[SharedMethods convertString:[NSString stringWithFormat:@"%@",[repayLoanObject valueForKey:@"USRLN_TENNURE_DATE"]] fromFormat:LOCALDATETIMEFORMAT toFormat:DATEFORMAT] ;
        self.loanAmount.text = [NSString stringWithFormat:@"%@",[repayLoanObject valueForKey:@"USRLN_AMOUNT"]];
        self.inHandAmount.text = [NSString stringWithFormat:@"%@",[repayLoanObject valueForKey:@"USRLN_AMOUNT"]];
        
//    }];
    
}
- (IBAction)DoneBtnTapped:(id)sender {
    self.blackoutview.hidden = YES;
    self.thanksview.hidden = YES;
    
}
- (IBAction)DismissBtnTapped:(id)sender {
    self.blackoutview.hidden = YES;
    self.thanksview.hidden = YES;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)RepayBtn:(id)sender {
    self.blackoutview.hidden = NO;
    self.thanksview.hidden = NO;
}

#pragma mark StatusBar Style
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
@end
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

