//
//  AddBankAccountController.h
//  SocialPockets
//
//  Created by Pandiyaraj on 26/07/16.
//  Copyright © 2016 Pandiyaraj. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^onCreateAction)(id);
@interface AddBankAccountController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *accountNoTF;
@property (weak, nonatomic) IBOutlet UITextField *bankNameTF;
@property (weak, nonatomic) IBOutlet UITextField *IFSCCodeTF;
@property (weak, nonatomic) IBOutlet UIView *addAccountview;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIView *editAccountbtnView;
@property (weak, nonatomic) IBOutlet UIView *editTitleView;
@property (nonatomic,strong) id currentAccountObject;
- (IBAction)editAction:(id)sender;
- (IBAction)deleteAction:(id)sender;

@property (nonatomic,copy) onCreateAction onCreate;
@end
