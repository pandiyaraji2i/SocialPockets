//
//  ProfileViewController.m
//  SocialPockets
//
//  Created by ideas2it-Kovendhan on 19/07/16.
//  Copyright © 2016 Pandiyaraj. All rights reserved.
//

#import "ProfileViewController.h"
#import "ChangePasswordController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
- (IBAction)editProfileAction:(id)sender
{
    UIButton *btn = sender;
    if (btn.selected) {
        
    }else{
    [PROFILEMACRO updateUserProfileWithName:@"kovendhan" username:@"kovendhan" email:@"kovendhan@ideas2it.com" phoneNumber:@"1111111111" completion:^(id obj) {
        NSLog(@"profile update =%@",obj);
    }];
    }
    
}
- (IBAction)changePasswordAction:(id)sender {
    ChangePasswordController *changePasswordVc =[self.storyboard instantiateViewControllerWithIdentifier:@"ChangePasswordVc"];
    [self.navigationController pushViewController:changePasswordVc animated:YES];
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
