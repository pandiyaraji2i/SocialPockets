//
//  AddBankAccountController.m
//  SocialPockets
//
//  Created by Pandiyaraj on 26/07/16.
//  Copyright © 2016 Pandiyaraj. All rights reserved.
//

#import "AddBankAccountController.h"

@interface AddBankAccountController()<UITextFieldDelegate>{
    NSString *bankAccountId;
}


@end

@implementation AddBankAccountController
@synthesize onCreate,nextBtn;
@synthesize currentAccountObject;
- (void)viewDidLoad {
    [super viewDidLoad];
    if (currentAccountObject != nil) {
        self.title = @"Edit Account";
        self.editTitleView.hidden =self.editAccountbtnView.hidden = NO;
        self.nextBtn.hidden =  self.addAccountview.hidden  =YES;
        
        
        self.accountNoTF.userInteractionEnabled = self.accountNoTF.userInteractionEnabled = self.accountNoTF.userInteractionEnabled = NO;
        self.accountNoTF.text = [self.currentAccountObject valueForKey:@"Account Number"];
        self.bankNameTF.text = [self.currentAccountObject valueForKey:@"ImageText"];
        self.IFSCCodeTF.text = [self.currentAccountObject valueForKey:@"IfscCode"];
        bankAccountId = [self.currentAccountObject valueForKey:@"AccountId"];
       
    }else{
        self.title = @"Add Account";
        self.editTitleView.hidden =self.editAccountbtnView.hidden = YES;
        self.nextBtn.hidden = self.addAccountview.hidden  = NO;
         self.accountNoTF.userInteractionEnabled = self.accountNoTF.userInteractionEnabled = self.accountNoTF.userInteractionEnabled = YES;
    }
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)nextButtonAction:(id)sender
{
    if (self.accountNoTF.text.length>0 && self.bankNameTF.text.length>0  &&self.IFSCCodeTF.text.length>0) {
        [ACTIVITY showActivity:@"Creating account..."];
        [BANKACCHELPER createBankAccountForUserId:USERINFO.userId bankName:self.bankNameTF.text ifscCode:self.IFSCCodeTF.text accountNumber:self.accountNoTF.text branchName:@"Guindy" createdBy:[[NSUserDefaults standardUserDefaults] valueForKey:USERID] completion:^(id obj) {
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

    }else{
        ErrorMessageWithTitle(@"Message", @"Please enter all fields");
    }
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan) {
        [self.view endEditing:YES];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    // verify the text field you wanna validate
    if (!(textField == NULL)) {
        
        // do not allow the first character to be space | do not allow more than one space
        if ([string isEqualToString:@" "]) {
            if (!textField.text.length)
                return NO;
            if ([[textField.text stringByReplacingCharactersInRange:range withString:string] rangeOfString:@"  "].length)
                return NO;
        }
        
        // allow backspace
        if ([textField.text stringByReplacingCharactersInRange:range withString:string].length < textField.text.length) {
            return YES;
        }
        
        // in case you need to limit the max number of characters
        if ([textField.text stringByReplacingCharactersInRange:range withString:string].length > 18) {
            return NO;
        }
        return YES;
    }
    
    return YES;
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

- (IBAction)editAction:(id)sender {
    UIButton *btn = sender;
    if (!btn.selected) {
        [self updateTextfieldEnabled:YES];
        btn.selected = !btn.selected;
    }else{
        btn.selected  = !btn.selected;
        [self updateTextfieldEnabled:NO];
        return;
        
        if (self.accountNoTF.text.length>0 && self.bankNameTF.text.length>0  &&self.IFSCCodeTF.text.length>0) {
            [ACTIVITY showActivity:@"Updating..."];
            [BANKACCHELPER updateBankAccount:bankAccountId bankName:self.bankNameTF.text ifscCode:self.IFSCCodeTF.text accountNumber:self.accountNoTF.text branchName:@"Guindy" createdBy:[[NSUserDefaults standardUserDefaults] valueForKey:USERID] completion:^(id obj) {
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
        else{
              ErrorMessageWithTitle(@"Message", @"Please enter all fields");
        }
    }
}

- (void)updateTextfieldEnabled:(BOOL)isEditable
{
    self.accountNoTF.userInteractionEnabled = self.bankNameTF.userInteractionEnabled = self.IFSCCodeTF.userInteractionEnabled  = isEditable;
    if (isEditable) {
        self.accountNoTF.clearButtonMode = self.bankNameTF.clearButtonMode = self.IFSCCodeTF.clearButtonMode  = UITextFieldViewModeAlways;
    }else{
         self.accountNoTF.clearButtonMode = self.bankNameTF.clearButtonMode = self.IFSCCodeTF.clearButtonMode   = UITextFieldViewModeNever;
    }
}


- (IBAction)deleteAction:(id)sender {
    
    if (bankAccountId!=nil) {
        [ACTIVITY showActivity:@"Loading..."];
        [BANKACCHELPER deleteBankAccountWithId:bankAccountId completion:^(id obj) {
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
}
@end
