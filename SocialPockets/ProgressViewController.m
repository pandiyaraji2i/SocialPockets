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
    NSMutableArray*imageUpdatedArray;
    RRCircleView *view;

}

@end

@implementation ProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
    self.doneBtn.layer.cornerRadius = 5.0;
    self.doneBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.doneBtn.layer.borderWidth = 1.5;
    self.navigationController.navigationBarHidden = YES;
    imageNameArray = [NSArray arrayWithObjects:@"AccountProgress",@"AadharProgress",@"PanCardProgress",@"FBProgress",@"TwitterProgress",@"InstagramProgress",@"LInkedInProgress",@"BankProgress", nil];
    
    view = [[RRCircleView alloc] initFromPoint:self.view.center from:self.progressBG];
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self getImageUpdatedArray];
    
    view.imagesArray = [self imageArray];
    view.avatarImage = [UIImage imageNamed:@"ProfileImage"];
    
    [view showFullView:true];
    

}
-(void)getImageUpdatedArray{
    imageUpdatedArray= [[NSMutableArray alloc] init];
    [imageUpdatedArray addObject:@"AccountProgress"];
  //  if ([[NSUserDefaults standardUserDefaults] boolForKey:@"AadharCardUpdate"]){
        [imageUpdatedArray addObject:@"AadharProgress"];
  //  }
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"PanCardUpdate"]) {
        [imageUpdatedArray addObject:@"PanCardProgress"];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"FacebookAccessToken"]) {
        [imageUpdatedArray addObject:@"FBProgress"];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"TwitterAccessToken"]) {
        [imageUpdatedArray addObject:@"TwitterProgress"];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"InstagramAccessToken"]) {
        [imageUpdatedArray addObject:@"InstagramProgress"];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"LinkedInAccessToken"]) {
        [imageUpdatedArray addObject:@"LInkedInProgress"];
    }
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"BankAccountUpdated"]) {
        [imageUpdatedArray addObject:@"BankProgress"];
//    }
    view.progressNumber = [imageUpdatedArray count];
    view.progressNumber = 6;

    NSLog(@"%lu",(unsigned long)[imageUpdatedArray count]);
    for (NSString*type in imageNameArray) {
    if (![imageUpdatedArray containsObject:type]) {
        [imageUpdatedArray addObject:type];
    }
    }
}

-(NSArray *)imageArray{
    NSMutableArray *imageArray = [[NSMutableArray alloc] init];
    for (int i =0;i<imageUpdatedArray.count; i++) {
        [imageArray addObject:[UIImage imageNamed:[imageUpdatedArray objectAtIndex:i]]];
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
