//
//  ApplyLoanViewController.m
//  SocialPockets
//
//  Created by ideas2it-Kovendhan on 27/07/16.
//  Copyright © 2016 Pandiyaraj. All rights reserved.
//

#import "ApplyLoanViewController.h"
 int const LoanProcessingFeeDetectionPercent = 6;


@interface ApplyLoanViewController ()
@property (weak, nonatomic) IBOutlet UIView *loanDetailsView;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UILabel *loanAmountLbl;
@property (weak, nonatomic) IBOutlet UILabel *deductionAmtLbl;
@property (weak, nonatomic) IBOutlet UILabel *handAmtLbl;
@property (weak, nonatomic) IBOutlet UILabel *MainLoanAmt;

@end

@implementation ApplyLoanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _loanDetailsView.layer.cornerRadius = 5.0;
    _loanDetailsView.layer.masksToBounds = YES;
    UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sliderTapped:)];
    [self.loanAmtSlider addGestureRecognizer:gr];
    self.navigationController.navigationBarHidden = NO;
    self.title = @"Apply Loan";
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//   // self.navigationController.navigationItem.backBarButtonItem = [NSDictionary dictionaryWithObject:[UIColor redColor] forKey:NSForegroundColorAttributeName];
//
//    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];

}
- (IBAction)NextBtnTapped:(id)sender {
}
- (IBAction)SliderValueChanged:(UISlider*)sender {
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
    NSLog(@"%f",self.loanAmtSlider.value);

    int loanAmt =(int)self.loanAmtSlider.value*500;
    _loanAmountLbl.text =  [NSString stringWithFormat:@"Rs. %d",loanAmt];
   _deductionAmtLbl.text =  [NSString stringWithFormat:@"- Rs. %d", (loanAmt/100)*LoanProcessingFeeDetectionPercent];
    _handAmtLbl.text =  [NSString stringWithFormat:@"Rs. %d", (loanAmt-(loanAmt/100)*LoanProcessingFeeDetectionPercent)];
    _MainLoanAmt.text = [NSString stringWithFormat:@"%d", loanAmt];

}
- (void)sliderTapped:(UIGestureRecognizer *)g {
    UISlider* s = (UISlider*)g.view;
    if (s.highlighted){
        [self SliderValueChanged:nil];
        return; // tap on thumb, let slider deal with it
    }
    CGPoint pt = [g locationInView: s];
    CGFloat percentage = pt.x / s.bounds.size.width;
    CGFloat delta = percentage * (s.maximumValue - s.minimumValue);
    CGFloat value = s.minimumValue + delta;
    self.loanAmtSlider.value = value;
    [self  SliderValueChanged:nil];
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
