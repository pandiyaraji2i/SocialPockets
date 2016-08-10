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
@property (nonatomic,copy) onCreateAction onCreate;
@end
