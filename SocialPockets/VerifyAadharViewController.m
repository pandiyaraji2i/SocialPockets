//
//  VerifyAadharViewController.m
//  SocialPockets
//
//  Created by ideas2it-Kovendhan on 10/08/16.
//  Copyright © 2016 Pandiyaraj. All rights reserved.
//

#import "VerifyAadharViewController.h"

@interface VerifyAadharViewController (){
    NSDictionary *obj;
}

@end

@implementation VerifyAadharViewController
@synthesize updateAadharView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    obj= @{
           @"name":@"Ganesh",
           @"fathername" : @"Muralidharan",
           @"yearofbirth" : @"1987",
           @"gender" : @"Male",
           @"address" : @"no :1 , fourth cross street , Krishna nagar, Pammal, Chennai "
           
           };
}
- (IBAction)cancelBtnTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)yesBtntapped:(id)sender {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"AadharCardUpdate"];
    [self dismissViewControllerAnimated:YES completion:nil];
    if (updateAadharView) {
        updateAadharView(obj);
    }
    
    // [self.navigationController popToRootViewControllerAnimated:YES];
    
}
- (IBAction)noBtnTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
