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
    NSString *repayLoanId,*mobileWalletId,*loanRepayAmount;
    
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
    
    self.processingFeePercentage.text = [NSString stringWithFormat:@"Penalty Amount"];
    self.tenurePeriod.text = [NSString stringWithFormat:@"21 Days Tenure Period"];
    
    
//    [LOANMACRO getIndividualLoan:repayLoanId completion:^(id obj) {
    repayLoanId = [NSString stringWithFormat:@"%@",[repayLoanObject valueForKey:@"USRLN_ID"]];
    mobileWalletId = [NSString stringWithFormat:@"%@",[repayLoanObject valueForKey:@"USRLN_MOBWM_ID"]];
    loanRepayAmount = [NSString stringWithFormat:@"%@",[repayLoanObject valueForKey:@"USRLN_ACTION_AMOUNT"]];
    
        self.loanTakenDate.text = [SharedMethods convertString:[NSString stringWithFormat:@"%@",[repayLoanObject valueForKey:@"USRLN_TRANSFERRED_DATE"]] fromFormat:LOCALDATETIMEFORMAT toFormat:DATEFORMAT]; ;
        self.loanDueDate.text =[SharedMethods convertString:[NSString stringWithFormat:@"%@",[repayLoanObject valueForKey:@"USRLN_TENNURE_DATE"]] fromFormat:LOCALDATETIMEFORMAT toFormat:DATEFORMAT] ;
        self.loanAmount.text = [NSString stringWithFormat:@"%@",[repayLoanObject valueForKey:@"USRLN_AMOUNT"]];
    self.loanDetailAmount.text = [NSString stringWithFormat:@"%@",[repayLoanObject valueForKey:@"USRLN_ACTION_AMOUNT"]];
    int amt = 0; // temp value given for additional fee.
    //int amt = [[repayLoanObject valueForKey:@"USRLN_ACTION_AMOUNT"] intValue];
    //amt = (amt*6)/100;
    int inHandAmt = [[repayLoanObject valueForKey:@"USRLN_ACTION_AMOUNT"] intValue];
    //inHandAmt = inHandAmt-amt;
    
    self.inHandAmount.text =[NSString stringWithFormat:@"%d",inHandAmt];
    self.processingFeeAmount.text =[NSString stringWithFormat:@"%d",amt];
//    }];
    
}
- (IBAction)DoneBtnTapped:(id)sender {
    
    self.blackoutview.hidden = YES;
    self.thanksview.hidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)RepayBtn:(id)sender {
    self.blackoutview.hidden = NO;
    self.thanksview.hidden = NO;
    [ LOANMACRO repayLoan:repayLoanId mobileWallet:mobileWalletId repayAmount:loanRepayAmount completion:^(id obj) {
    }];
    self.okButton.layer.borderColor = [UIColor grayColor].CGColor;
    self.okButton.layer.masksToBounds = YES;
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

