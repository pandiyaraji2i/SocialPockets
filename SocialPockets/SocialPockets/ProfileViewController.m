//
//  ProfileViewController.m
//  SocialPockets
//
//  Created by ideas2it-Kovendhan on 19/07/16.
//  Copyright © 2016 Pandiyaraj. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UIButton *updateBtn;
@property (weak, nonatomic) IBOutlet UIButton *eligibiltyBtn;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)UpdateBtnTapped:(id)sender {
 
    [PROFILEMACRO updateUserProfileWithName:@"kovendhan" username:@"kovendhan" email:@"kovendhan@ideas2it.com" phoneNumber:@"1111111111" completion:^(id obj) {
        NSLog(@"profile update =%@",obj);
    }];
    
}
- (IBAction)onEligiblityCheck:(id)sender {
  
    [PROFILEMACRO eligibityForUserId:@"1" completion:^(id obj) {
        NSLog(@"eligibility = %@",obj);
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
