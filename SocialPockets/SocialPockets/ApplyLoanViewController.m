//
//  ApplyLoanViewController.m
//  SocialPockets
//
//  Created by ideas2it-Kovendhan on 27/07/16.
//  Copyright © 2016 Pandiyaraj. All rights reserved.
//

#import "ApplyLoanViewController.h"
#import "RequestConfirmationViewController.h"
 int const LoanProcessingFeeDetectionPercent = 6;


@interface ApplyLoanViewController (){
    float loanMinValue;
    int loanMultipler;
}
@property (weak, nonatomic) IBOutlet UIView *loanDetailsView;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UILabel *loanAmountLbl;
@property (weak, nonatomic) IBOutlet UILabel *deductionAmtLbl;
@property (weak, nonatomic) IBOutlet UILabel *handAmtLbl;
@property (weak, nonatomic) IBOutlet UILabel *MainLoanAmt;

@end

@implementation ApplyLoanViewController
@synthesize loanObject,loanProcessingFee;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    float maxLoanAmount = [[loanObject objectForKey:@"MAXIMUM_LOAN_AMOUNT"] floatValue];
    //float maxLoanAmount = 5000;
    [self updateSliderForAmt:maxLoanAmount];
    self.loanAmtSlider.minimumValue = 0;
        _loanDetailsView.layer.cornerRadius = 5.0;
    _loanDetailsView.layer.masksToBounds = YES;
    UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sliderTapped:)];
    [self.loanAmtSlider addGestureRecognizer:gr];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@" " style:UIBarButtonItemStylePlain target:self action:nil];


    
    self.title = @"Apply Loan";
    
    tenurePeriodLabel.text = [NSString stringWithFormat:@"%@ Days Tenure Period",[self.loanObject valueForKey:@"TENURE_DATE"]];
    loanProcessingFee.text = [NSString stringWithFormat:@"%@%% Processing Fee Deduction",[self.loanObject valueForKey:@"PROCESSING_FEE"]];
    
    //#-- Status Bar Color Change
    [self setNeedsStatusBarAppearanceUpdate];
    [self sliderValueChanged:nil];

}
- (IBAction)nextBtnTapped:(id)sender {
    RequestConfirmationViewController *requestConfirmationVc = [self.storyboard instantiateViewControllerWithIdentifier:@"RequsetConfirmationVc"];
    requestConfirmationVc.loanAmount = self.MainLoanAmt.text;
    requestConfirmationVc.loanInHandAmount = [[self.handAmtLbl.text stringByReplacingOccurrencesOfString:@"Rs. " withString:@""] rupeesFormat];//self.handAmtLbl.text;
    requestConfirmationVc.tenurePeriod = [NSString stringWithFormat:@"%@",[loanObject valueForKey:@"TENURE_DATE"]];
    [self.navigationController pushViewController:requestConfirmationVc animated:YES];
}

- (IBAction)sliderValueChanged:(UISlider*)sender {
    double num = self.loanAmtSlider.value;
    int intpart = (int)num;
    double decpart = num - intpart;
    if (decpart>0.5) {
        self.loanAmtSlider.value=intpart+1;
    }
    else
    {
        self.loanAmtSlider.value=intpart;
    }
    if (self.loanAmtSlider.value < loanMinValue) {
        self.loanAmtSlider.value = loanMinValue;
    }
    

    int loanAmt =(int)self.loanAmtSlider.value*loanMultipler;
    _loanAmountLbl.text =  [NSString stringWithFormat:@"Rs. %d",loanAmt];
   _deductionAmtLbl.text =  [NSString stringWithFormat:@"- Rs. %d", (loanAmt/100)*LoanProcessingFeeDetectionPercent];
    _handAmtLbl.text =  [NSString stringWithFormat:@"Rs. %d", (loanAmt-(loanAmt/100)*LoanProcessingFeeDetectionPercent)];
    _MainLoanAmt.text = [[NSString stringWithFormat:@"%d", loanAmt] rupeesFormat];

}
- (void)sliderTapped:(UIGestureRecognizer *)g {
    UISlider* s = (UISlider*)g.view;
    if (s.highlighted){
        [self sliderValueChanged:nil];
        return; // tap on thumb, let slider deal with it
    }
    CGPoint pt = [g locationInView: s];
    CGFloat percentage = pt.x / s.bounds.size.width;
    CGFloat delta = percentage * (s.maximumValue - s.minimumValue);
    CGFloat value = s.minimumValue + delta;
    self.loanAmtSlider.value = value;
    [self  sliderValueChanged:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark StatusBar Style
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


#pragma mark slider methods

// set upadte slider

-(void)updateSliderForAmt:(float)amt{
    
    if (amt<=1000) {
        loanMultipler = 100;
        self.loanAmtSlider.maximumValue = (amt/loanMultipler);
        loanMinValue = 1;
    }else if (amt<=10000){
        loanMultipler = 500;
        self.loanAmtSlider.maximumValue = (amt/loanMultipler);
        loanMinValue = 1;
    }else if (amt>10000){
        loanMultipler = 1000;
        self.loanAmtSlider.maximumValue = (amt/loanMultipler);
        loanMinValue = 1;
    }
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
