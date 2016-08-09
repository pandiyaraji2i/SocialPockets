//
//  RepayLoanViewController.h
//  SocialPockets
//
//  Created by Ideas2IT-GaneshM on 28/07/16.
//  Copyright © 2016 Pandiyaraj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RepayLoanViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *loanTakenDate;
@property (nonatomic,strong) NSDictionary *repayLoanObject;
@property (weak, nonatomic) IBOutlet UILabel *loanDueDate;
@property (weak, nonatomic) IBOutlet UILabel *loanAmount;
@property (weak, nonatomic) IBOutlet UILabel *tenurePeriod;
@property (weak, nonatomic) IBOutlet UILabel *inHandAmount;
@property (weak, nonatomic) IBOutlet UILabel *processingFeeAmount;
@property (weak, nonatomic) IBOutlet UILabel *processingFeePercentage;

@end
