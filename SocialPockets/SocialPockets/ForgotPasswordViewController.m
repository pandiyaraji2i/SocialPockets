//
//  ResetPasswordViewController.m
//  SocialPockets
//
//  Created by ideas2it-Kovendhan on 08/08/16.
//  Copyright © 2016 Pandiyaraj. All rights reserved.
//

#import "ForgotPasswordViewController.h"

@interface ForgotPasswordViewController ()

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Forgot Password";
}

- (IBAction)resetPasswordButtonAction:(id)sender
{
    if (!userNameTextField.text.length || !userEmailAddressField.text.length) {
        ErrorMessageWithTitle(@"Message", @"Please enter all the fields");
    }
    else {
        [LOGINMACRO forgotPasswordForUser:userEmailAddressField.text completion:^(id obj) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                [self showAlertView:[obj valueForKey:@"Message"]];
            }else{
                ErrorMessageWithTitle(@"Message", obj);
            }
        }];
    }
}

- (void)showAlertView:(NSString *)message
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Message"
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    //We add buttons to the alert controller by creating UIAlertActions:
    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action){
                                                         [self.navigationController popViewControllerAnimated:YES];
                                                     }] ;
    [alertController addAction:actionOk];
    [self presentViewController:alertController animated:YES completion:nil];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark keyboard dismiss method
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
