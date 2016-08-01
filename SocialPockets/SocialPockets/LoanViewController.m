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

- (IBAction)requestLoan:(id)sender {
    [LOANMACRO requestLoanForUserId:@"25" amount:@"2500" createdBy:@"25" completion:^(id obj) {
        
        NSLog(@"%@",obj);
        // need to upload image
        UIImage *img =[UIImage imageNamed:@"Chotta2.jpg"];
        [NetworkHelperClass uploadImage:img isUserOrLoan:2 userId:@"" sync:NO completion:^(id obj) {
             
        }];
    }];
    
}

- (IBAction)LoanStatus:(id)sender {
    [LOANMACRO checkStatusOfLoan:@"11" completion:^(id obj) {
        NSLog(@"%@",obj);
        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Response " message:[obj objectForKey:@"USRN"] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
//        [alert show];
//        
    }];
}

- (IBAction)repayLoan:(id)sender{
    [LOANMACRO repayLoanForUserId:@"25" loanId:@"14" mobileWallet:@"1" repayAmount:@"1" completion:^(id obj) {
        NSLog(@"%@",obj);
    }];
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

- (IBAction)createMWallet:(id)sender {
    [MWALLET mwalletForUserId:@"14" mobilewallet:@"4" createdBy:@"14" completion:^(id obj) {
        NSLog(@"%@",obj);
    }];
    
}

- (IBAction)deleteMwallet:(id)sender {
    [MWALLET deletMwalletUserId:@"14" mobilewallet:@"4" completion:^(id obj) {
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
