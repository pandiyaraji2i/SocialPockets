//
//  AddBankAccountController.m
//  SocialPockets
//
//  Created by Pandiyaraj on 26/07/16.
//  Copyright © 2016 Pandiyaraj. All rights reserved.
//

#import "AddBankAccountController.h"

@interface AddBankAccountController ()

@end

@implementation AddBankAccountController
@synthesize onCreate;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Add Account";
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)nextButtonAction:(id)sender
{
    [ACTIVITY showActivity:@"Creating account..."];
    [BANKACCHELPER createBankAccountForUserId:[[NSUserDefaults standardUserDefaults] valueForKey:USERID] bankName:self.bankNameTF.text ifscCode:self.IFSCCodeTF.text accountNumber:self.accountNoTF.text branchName:@"Guindy" createdBy:[[NSUserDefaults standardUserDefaults] valueForKey:USERID] completion:^(id obj) {
        [ACTIVITY performSelectorOnMainThread:@selector(hideActivity) withObject:nil waitUntilDone:YES];
        if ([obj isKindOfClass:[NSDictionary class]]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
                if (onCreate) {
                    onCreate(obj);
                }
            });
        }else{
            ErrorMessageWithTitle(@"Message", obj);
        }
    }];
    
}

#pragma mark StatusBar Style
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
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
