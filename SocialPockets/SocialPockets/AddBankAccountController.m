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
