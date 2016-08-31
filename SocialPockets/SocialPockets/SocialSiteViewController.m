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
#import <linkedin-sdk/LISDK.h>
#import "AppDelegate.h"
#import "IGLoginViewController.h"
#import "ProgressViewController.h"


@interface SocialSiteViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSArray *tableData;
}
@property IBOutlet UITableView *socialTableView;
@property (weak, nonatomic) IBOutlet UILabel *attLabel;
@property (nonatomic,weak) IBOutlet UITextView *bodyResult;

@end

@implementation SocialSiteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Social Accounts";
    // Do any additional setup after loading the view.
    tableData = [[NSArray alloc] initWithObjects:@"FaceBook",@"Twitter",@"Instagram",@"LinkedIn", nil];
    self.socialTableView.delegate = self;
    self.socialTableView.dataSource = self;
    self.socialTableView.layer.cornerRadius = 5.0;
    self.socialTableView.layer.masksToBounds = YES;
    
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
    switch (indexPath.row) {
        case 0:
            lblname.textColor = [UIColor colorWithRed:71.0/255.0 green:89.0/255.0 blue:147.0/255.0 alpha:1.0];
            break;
        case 1:
            lblname.textColor = [UIColor colorWithRed:62.0/255.0 green:163.0/255.0 blue:230.0/255.0 alpha:1.0];
            break;
        case 2:
            lblname.textColor = [UIColor colorWithRed:194.0/255.0 green:33.0/255.0 blue:112.0/255.0 alpha:1.0];
            break;
        case 3:
            lblname.textColor = [UIColor colorWithRed:0.0/255.0 green:119.0/255.0 blue:183.0/255.0 alpha:1.0];
            break;
            
        default:
            break;
    }
    
    UIImageView *imgname = (UIImageView *)[cell.contentView viewWithTag:1];
    imgname.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[tableData objectAtIndex:indexPath.row]]];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    UIButton *linkedBtn = (UIButton *)[cell.contentView viewWithTag:3];
    switch (indexPath.row) {
        case 0:
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"FacebookAccessToken"]) {
                linkedBtn.backgroundColor = [UIColor colorWithRed:32.0/255.0 green:160.0/255.0 blue:18.0/255.0 alpha:1.0];
            }
            break;
        case 1:
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"TwitterAccessToken"]) {
                linkedBtn.backgroundColor = [UIColor colorWithRed:32.0/255.0 green:160.0/255.0 blue:18.0/255.0 alpha:1.0];
            }
            break;
        case 2:
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"InstagramAccessToken"]) {
                linkedBtn.backgroundColor = [UIColor colorWithRed:32.0/255.0 green:160.0/255.0 blue:18.0/255.0 alpha:1.0];
            }
            break;
        case 3:
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"LinkedInAccessToken"]) {
                linkedBtn.backgroundColor = [UIColor colorWithRed:32.0/255.0 green:160.0/255.0 blue:18.0/255.0 alpha:1.0];
            }
            break;
            
        default:
            break;
    }
    
    //[cell.textLabel setText:[tableData objectAtIndex:indexPath.row]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // for facebook
    if (indexPath.row == 0) {
        [SOCIALMACRO facebookLoginWithCompletion:^(id obj) {
            [[NSUserDefaults standardUserDefaults] setObject:[[obj token] tokenString] forKey:@"FacebookAccessToken"];
            NSLog(@"fb token ==%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"FacebookAccessToken"]);
            [tableView reloadData];
            [self getLikesCount];
            //[self dataFetchForUser:obj];
            //[self CreateSocialSiteWithSocialSite:@"1"];
        }];
    }
    else if (indexPath.row == 1) {         //  for Twitter
        [SOCIALMACRO twitterLoginWithCompletion:^(id obj) {
            [tableView reloadData];
            NSLog(@" userid === %@",[obj userID]);
        }];
    }
    else if (indexPath.row == 2) { //  for Instagram
        
        IGLoginViewController *IGloginVc = [self.storyboard instantiateViewControllerWithIdentifier:@"IGLoginView"];
        UINavigationController *navVc = [[UINavigationController alloc]initWithRootViewController:IGloginVc];
        [self presentViewController:navVc animated:YES completion:NULL];
        IGloginVc.onLogin = ^(id obj){
            [[NSUserDefaults standardUserDefaults] setObject:obj forKey:@"InstagramAccessToken"];
            [tableView reloadData];
            
            NSLog(@"Auth Token %@",obj);
            [SOCIALMACRO instagramLoginWithUserToken:obj WithCompletion:^(id obj) {
                //NSLog(@"Fetch Data %@",obj);
                NSString *followedby = [NSString stringWithFormat:@"%@",[[[obj objectForKey:@"data"] objectForKey:@"counts"]objectForKey:@"followed_by"]];
                NSString *follows = [NSString stringWithFormat:@"%@",[[[obj objectForKey:@"data"] objectForKey:@"counts"]objectForKey:@"follows"]];
                NSLog(@"Followed by = %@ \n Follows = %@",followedby,follows);
            }];
            //           [self CreateSocialSiteWithSocialSite:@"3"];
        };
        
    }
    else if (indexPath.row == 3) { //  for LinkedIn
        [SOCIALMACRO linkedInLoginWithCompletion:^(id obj) {
            [[NSUserDefaults standardUserDefaults] setObject:obj forKey:@"LinkedInAccessToken"];
            [tableView reloadData];
            //  [self CreateSocialSiteWithSocialSite:@"4"];
        }];
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

# pragma Mark Get FaceBook list Details

-(void)dataFetchForUser:(id)obj{
    if ([FBSDKAccessToken currentAccessToken]) {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"picture.type(large), email, name"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 NSString *pictureURL = [NSString stringWithFormat:@"%@",[[[result objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"]];
                 NSLog(@"email is %@", [result objectForKey:@"email"]);
                 NSData  *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:pictureURL]];
                 //                 self.profileImageView.image = [UIImage imageWithData:data];
                 //                 self.nameLbl.text = [NSString stringWithFormat:@"Welcome %@",[result objectForKey:@"name"]];
                 
             }
         }];
    }
}

-(void)getLikesCount{
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:@"/me"
                                  parameters:@{ @"fields": @"albums,friends",}
                                  HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        
        //code to get friends count
        int friendsCount = [[[[result objectForKey:@"friends"] objectForKey:@"summary"] objectForKey:@"total_count"] intValue];
        
        int  serverSentFriendsCount;
        
        //code for likes Count
        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"FBFriendsCount"]) {
            int oldValue = [[NSUserDefaults standardUserDefaults] integerForKey:@"FBFriendsCount"];
            serverSentFriendsCount = friendsCount - oldValue;
            if (serverSentFriendsCount>0) {
                //server API call
            }else{
                
            }
        }else{
            //API call with twitter friends Count
        }
        [[NSUserDefaults standardUserDefaults] setInteger:friendsCount forKey:@"FBFriendsCount"];

        

        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                      initWithGraphPath:[NSString stringWithFormat:@"/%@",[[[[result objectForKey:@"albums"] objectForKey:@"data"] objectAtIndex:0] objectForKey:@"id"]]
                                      parameters:@{ @"fields": @"photos",}
                                      HTTPMethod:@"GET"];
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
            // Insert your code here
            FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                          initWithGraphPath:[NSString stringWithFormat:@"/%@",[[[[result objectForKey:@"photos"] objectForKey:@"data"] objectAtIndex:0] objectForKey:@"id"]]
                                          parameters:@{ @"fields": @"likes,comments",}
                                          HTTPMethod:@"GET"];
            [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                // Insert your code here
                int likesCount = [[[result objectForKey:@"likes"] objectForKey:@"data"] count];
                int commentsCount = [[[result objectForKey:@"comments"] objectForKey:@"data"] count];

                int  serverSentLikeValue;
                int  serverSentcommentValue;
                
                //code for likes Count
                if ([[NSUserDefaults standardUserDefaults] integerForKey:@"FBLikesCount"]) {
                    int oldValue = [[NSUserDefaults standardUserDefaults] integerForKey:@"FBLikesCount"];
                    serverSentLikeValue = likesCount - oldValue;
                    if (serverSentLikeValue>0) {
                        //server API call
                    }else{
                        
                    }
                }else{
                    //API call with twitter friends Count
                }
                [[NSUserDefaults standardUserDefaults] setInteger:likesCount forKey:@"FBLikesCount"];
                
                //code for comments count
                
                if ([[NSUserDefaults standardUserDefaults] integerForKey:@"FBCommentsCount"]) {
                    int oldValue = [[NSUserDefaults standardUserDefaults] integerForKey:@"FBCommentsCount"];
                    serverSentLikeValue = commentsCount - oldValue;
                    if (serverSentcommentValue>0) {
                        //server API call
                    }else{
                        
                    }
                }else{
                    //API call with twitter friends Count
                }
                [[NSUserDefaults standardUserDefaults] setInteger:commentsCount forKey:@"FBCommentsCount"];
                
            }];
            
        }];
        
        // Insert your code here
    }];
}


-(void)getFriendsCount{
}



- (IBAction)nextBtnTapped:(id)sender {
    ProgressViewController *progressVc =[self.storyboard instantiateViewControllerWithIdentifier:@"ProgressVc"];
    [self.navigationController pushViewController:progressVc animated:YES];
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
