//
//  SocialSiteViewController.m
//  SocialPockets
//
//  Created by ideas2it-Kovendhan on 21/07/16.
//  Copyright © 2016 Pandiyaraj. All rights reserved.
//

#import "SocialSiteViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <TwitterKit/TwitterKit.h>

@interface SocialSiteViewController ()<UITableViewDataSource,UITableViewDelegate>{
        NSArray *tableData;
}
@property IBOutlet UITableView *socialTableView;
@property (weak, nonatomic) IBOutlet UILabel *attLabel;

@end

@implementation SocialSiteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    tableData = [[NSArray alloc] initWithObjects:@"FaceBook",@"Twitter",@"Instagram",@"googlePlus", nil];
    self.socialTableView.delegate = self;
    self.socialTableView.dataSource = self;
    self.socialTableView.layer.borderWidth = 2.0;
    self.socialTableView.layer.borderColor = [UIColor grayColor].CGColor;
    
    NSDictionary *attribs = @{
                              NSForegroundColorAttributeName:[UIColor whiteColor],
                              NSFontAttributeName: [UIFont fontWithName:@"Helvetica Neue" size:11]
                              };
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:_attLabel.text attributes:attribs];
    
    
    UIFont *boldFont = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
    NSRange range = [_attLabel.text rangeOfString:@"Social Score"];
    [attributedText setAttributes:@{NSForegroundColorAttributeName: [UIColor yellowColor],
                                    NSFontAttributeName:boldFont} range:range];
    
    
    _attLabel.attributedText = attributedText;
}

# pragma uitableview delagates


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  [tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:
(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SocialCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SocialCell"];
    }
    
    UILabel *lblname = (UILabel *)[cell.contentView viewWithTag:99];
    
    lblname.text = [tableData objectAtIndex:indexPath.row];
    
    UIImageView *imgname = (UIImageView *)[cell.contentView viewWithTag:1];
    
    
    imgname.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[tableData objectAtIndex:indexPath.row]]];
    
    
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    //[cell.textLabel setText:[tableData objectAtIndex:indexPath.row]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // Button click for facebook
    if (indexPath.row == 0) {
     [self loginButtonClicked];
//        [SharedMethods showAlertActionWithTitle:@"Alert" message:@"Are you want to add FaceBook" completion:^(id obj) {
//            NSLog(@"just test");
//            [self CreateSocialSiteWithSocialSite:@"1"];
//        }];
    }
        // Button click for Twitter
    if (indexPath.row == 1) {
        [self TwitterLoginBtnClicked];
//        [SharedMethods showAlertActionWithTitle:@"Alert" message:@"Are you want to add Twitter" completion:^(id obj) {
//            NSLog(@"just test");
//            [self CreateSocialSiteWithSocialSite:@"2"];
//        }];
    }
        // Button click for Instagram
    if (indexPath.row == 2) {
        [SharedMethods showAlertActionWithTitle:@"Alert" message:@"Are you want to add Instagram" completion:^(id obj) {
            NSLog(@"just test");
            [self CreateSocialSiteWithSocialSite:@"3"];
        }];
        
    }
        // Button click for LinkedIn
    if (indexPath.row == 3) {
        [SharedMethods showAlertActionWithTitle:@"Alert" message:@"Are you want to add Linkedin" completion:^(id obj) {
            NSLog(@"just test");
            [self CreateSocialSiteWithSocialSite:@"4"];
        }];
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(void)CreateSocialSiteWithSocialSite:(NSString*)socialSiteId{
    [SOCIALMACRO createSocialSite:socialSiteId details:@"just to test" createdBy:@"25" completion:^(id obj) {
        NSLog( @"socail site created: %@",obj);
    }];
}

- (IBAction)CreateSocialSiteBtnTapped:(id)sender {
    [SOCIALMACRO createSocialSite:@"3" details:@"just to test" createdBy:@"25" completion:^(id obj) {
        NSLog( @"socail site created: %@",obj);
    }];
}
- (IBAction)ViewSocialSiteBtnTapped:(id)sender {
    [SOCIALMACRO viewSocialSiteWithCompletion:^(id obj) {
        NSLog( @"socail site list: %@",obj);
    }];
}
- (IBAction)UpdateSocialSiteBtnTapped:(id)sender {
    [SOCIALMACRO updateSocialSite:@"2" socialId:@"3" details:@"test by ko" modifiedBy:@"25" completion:^(id obj) {
        NSLog(@"updated social sites: %@",obj);
    }];
}


-(void)loginButtonClicked
{
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login
     logInWithReadPermissions: @[@"public_profile"]
     fromViewController:self
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"Process error");
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
         } else {
             NSLog(@"Logged in");
             [self CreateSocialSiteWithSocialSite:@"1"];
         }
     }];
}

#pragma Twitter Methods

-(void)TwitterLoginBtnClicked{
   
    
    
    [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {
        if (session) {
            NSLog(@"signed in as %@", [session userName]);
            [self CreateSocialSiteWithSocialSite:@"2"];

        } else {
            NSLog(@"error: %@", [error localizedDescription]);
        }
    }];
    

    // TODO: Change where the log in button is positioned in your view
   // logInButton.center = self.view.center;
   // [self.view addSubview:logInButton];
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
