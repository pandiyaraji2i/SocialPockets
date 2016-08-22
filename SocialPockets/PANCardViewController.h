//
//  PANCardViewController.h
//  SocialPockets
//
//  Created by ideas2it-Kovendhan on 10/08/16.
//  Copyright © 2016 Pandiyaraj. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^updatePANNumber)(NSString*);

@interface PANCardViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *panNumberTF;
@property (nonatomic,copy) updatePANNumber updatePAN;
@property (weak, nonatomic) IBOutlet UIButton *yesBtn;
@property (weak, nonatomic) IBOutlet UIButton *noBtn;

@end
