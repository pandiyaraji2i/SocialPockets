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
    NSString *penaltyAmount;
    
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
    
    self.processingFeePercentage.text = [NSString stringWithFormat:@"6%% Processing Fee"];
    self.tenurePeriod.text = [NSString stringWithFormat:@"21 Days Tenure Period"];
    
    self.loanTakenDate.text = [SharedMethods convertString:[NSString stringWithFormat:@"%@",[repayLoanObject valueForKey:@"USRLN_TRANSFERRED_DATE"]] fromFormat:LOCALDATETIMEFORMAT toFormat:DATEFORMAT]; ;
    self.loanDueDate.text =[SharedMethods convertString:[NSString stringWithFormat:@"%@",[repayLoanObject valueForKey:@"USRLN_TENNURE_DATE"]] fromFormat:LOCALDATETIMEFORMAT toFormat:DATEFORMAT] ;
    
    repayLoanId = [NSString stringWithFormat:@"%@",[repayLoanObject valueForKey:@"USRLN_ID"]];
    mobileWalletId = [NSString stringWithFormat:@"%@",[repayLoanObject valueForKey:@"USRLN_MOBWM_ID"]];
    long long loanAmountValue = [[repayLoanObject valueForKey:@"USRLN_AMOUNT"] longLongValue];
    long penaltyAmountValue = 0;//[[repayLoanObject valueForKey:@"PENALITY_AMOUNT"] longLongValue]
    
    long long totalAmount = loanAmountValue + penaltyAmountValue;
    
    loanRepayAmount = [NSString stringWithFormat:@"%lld",totalAmount];
    
    penaltyAmount = @"0";
    
    int processingFee = (int)(loanAmountValue * 6)/100;
    
   
    self.loanAmount.text = [loanRepayAmount rupeesFormat];
    
    self.loanDetailAmount.text = [NSString stringWithFormat:@"Rs. %@",[[NSString stringWithFormat:@"%@",[repayLoanObject valueForKey:@"USRLN_ACTION_AMOUNT"]] rupeesFormat]];
    
    self.processingFeeAmount.text =[NSString stringWithFormat:@"Rs. %@",[[NSString stringWithFormat:@"%d",processingFee] rupeesFormat]];
    
     self.penaltyAmountlbl.text =[NSString stringWithFormat:@"Rs. %@",[[NSString stringWithFormat:@"%ld",penaltyAmountValue] rupeesFormat]];
    
    self.inHandAmount.text = [NSString stringWithFormat:@"Rs. %@",[loanRepayAmount rupeesFormat]];
    
    
    
}
- (IBAction)DoneBtnTapped:(id)sender {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLoanRepaid"];
    self.blackoutview.hidden = YES;
    self.thanksview.hidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)RepayBtn:(id)sender {
    [ACTIVITY showActivity:@"Loading..."];
    [self performSelector:@selector(repayLoan) withObject:nil afterDelay:0.2];
}

- (void)repayLoan{
    [LOANMACRO repayLoan:repayLoanId mobileWallet:mobileWalletId repayAmount:loanRepayAmount completion:^(id obj) {
        [ACTIVITY performSelectorOnMainThread:@selector(hideActivity) withObject:nil waitUntilDone:YES];
        if ([obj isKindOfClass:[NSDictionary class]]) {
            self.blackoutview.hidden = NO;
            self.thanksview.hidden = NO;
        }else{
            ErrorMessageWithTitle(@"Message", obj);
        }
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

