//
//  ProgressViewController.m
//  SocialPockets
//
//  Created by ideas2it-Kovendhan on 17/08/16.
//  Copyright © 2016 Pandiyaraj. All rights reserved.
//

#import "ProgressViewController.h"
#import "RRCircleView.h"
#import "LoginViewController.h"

@interface ProgressViewController (){
    NSArray *imageNameArray;
}

@end

@implementation ProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.doneBtn.layer.cornerRadius = 5.0;
    self.doneBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.doneBtn.layer.borderWidth = 1.5;
    self.navigationController.navigationBarHidden = YES;
    imageNameArray = [NSArray arrayWithObjects:@"FBProgress",@"BankProgress",@"TwitterProgress",@"InstagramProgress",@"LInkedInProgress",@"PanCardProgress",@"AccountProgress",@"AadharProgress", nil];
    RRCircleView *view = [[RRCircleView alloc] initFromPoint:self.view.center from:self.progressBG];
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    view.progressNumber = 5;
    view.imagesArray = [self imageArray];
    view.avatarImage = [UIImage imageNamed:@"ProfileImage"];
    
    [view showFullView:true];
    

}
-(NSArray *)imageArray{
    NSMutableArray *imageArray = [[NSMutableArray alloc] init];
    for (int i =0;i<imageNameArray.count; i++) {
        [imageArray addObject:[UIImage imageNamed:[imageNameArray objectAtIndex:i]]];
    }
    return imageArray;
}
// Done Btn tapped

- (IBAction)doneBtnTapped:(id)sender {
//    [self.navigationController popToRootViewControllerAnimated:YES];
    MFSideMenuContainerViewController *container = [LoginViewController loginSuccessForIOS8:YES userId:USERINFO.userId fromClass:@"ProgressViewController"];
    [self.navigationController presentViewController:container animated:YES completion:nil];
    
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
