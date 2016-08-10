//
//  RequestConfirmation.h
//  SocialPockets
//
//  Created by Ideas2IT-GaneshM on 27/07/16.
//  Copyright © 2016 Pandiyaraj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RequestConfirmationViewController : UIViewController
{
    IBOutlet UILabel *loanAmountLabel, *loanInHandAmountLabel,*tenurePeriodLabel;
    IBOutlet UILabel *loanRequestStartDate, *loanRequestEndDate;
    IBOutlet UIButton *okButton;
    
}
@property (nonatomic,strong) NSString *loanAmount, *loanInHandAmount,*tenurePeriod;
@end
