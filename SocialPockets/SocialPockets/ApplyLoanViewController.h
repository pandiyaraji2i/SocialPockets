//
//  ApplyLoanViewController.h
//  SocialPockets
//
//  Created by ideas2it-Kovendhan on 27/07/16.
//  Copyright © 2016 Pandiyaraj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApplyLoanViewController : UIViewController
{
    IBOutlet UILabel *tenurePeriodLabel;
}
@property (weak, nonatomic) IBOutlet UISlider *loanAmtSlider;
@property (nonatomic,strong) NSDictionary *loanObject;
@end
