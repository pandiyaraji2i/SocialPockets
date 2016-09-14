//
//  LoanVC.m
//  SocialPockets
//
//  Created by Ideas2IT-GaneshM on 21/07/16.
//  Copyright © 2016 Pandiyaraj. All rights reserved.
//

#import "LoanViewController.h"

@interface LoanViewController ()

@end

@implementation LoanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view.
    
}

- (IBAction)extnLoan:(id)sender{
    [LOANMACRO extnLoanForUserId:@"14" completion:^(id obj) {
        NSLog(@"%@",obj);
    }];
}
- (IBAction)extnStatusLoan:(id)sender{
    [LOANMACRO statusForExtnUserId:@"14" completion:^(id obj) {
        NSLog(@"%@",obj);
    }];
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
