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
    if ([self.titleStr isEqualToString:@"Terms & Conditions"]) {

    }else if ([self.titleStr isEqualToString:@"FAQs"])
    {
        
    }else{
        
    }
    if (IPHONE6PLUS_STANDARD){
        self.backgroundImage.image = [UIImage imageNamed:@"NotificationBG6Splus.png"];
        
    }else if (IPHONE5){
        self.backgroundImage.image = [UIImage imageNamed:@"NotificationBG.png"];
        
    }else if(IPHONE6_STANDARD){
        self.backgroundImage.image = [UIImage imageNamed:@"NotificationBG6S.png"];
        
    }else{
        self.backgroundImage.image = [UIImage imageNamed:@"NotificationBG4S.png"];
        
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
