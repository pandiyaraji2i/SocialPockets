//
//  AboutUsViewController.m
//  SocialPockets
//
//  Created by Pandiyaraj on 28/07/16.
//  Copyright © 2016 Pandiyaraj. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController
@synthesize titleStr;

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = titleStr;
    titleStr  = self.title;
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:self.titleStr message:@"mess" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
    if ([self.titleStr isEqualToString:@"Terms & Conditions"]) {

    }else if ([self.titleStr isEqualToString:@"FAQs"])
    {
        
    }else{
        
    }
    
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Status Bar Style
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
