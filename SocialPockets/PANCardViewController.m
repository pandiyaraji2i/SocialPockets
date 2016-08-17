//
//  PANCardViewController.m
//  SocialPockets
//
//  Created by ideas2it-Kovendhan on 10/08/16.
//  Copyright © 2016 Pandiyaraj. All rights reserved.
//

#import "PANCardViewController.h"

@interface PANCardViewController ()

@end

@implementation PANCardViewController
@synthesize updatePAN;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)yesBtnTApped:(id)sender {
    if (self.panNumberTF.text.length>0) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"PanCardUpdate"];
        [self dismissViewControllerAnimated:YES completion:nil];
        if (updatePAN) {
            updatePAN(self.panNumberTF.text);
        }

    }
    else{
        ErrorMessageWithTitle(@"Message", @"please enter the number and then proceed");
    }
}
- (IBAction)noBtnTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
