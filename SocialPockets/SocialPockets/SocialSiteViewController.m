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
    //[cell.textLabel setText:[tableData objectAtIndex:indexPath.row]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    // Button click for facebook
    if (indexPath.row == 0) {
        [SOCIALMACRO faceBookLoginButtonClickedWithCompletion:^(id obj) {
            [self dataFetchForUser:obj];
            //[self CreateSocialSiteWithSocialSite:@"1"];
        }];
    }
    else if (indexPath.row == 1) {         // Button click for Twitter
        [SOCIALMACRO TwitterLoginBtnClickedWithCompletion:^(id obj) {
            [self getTwitterFollowersListForUserID:[obj userID]];
            //[self CreateSocialSiteWithSocialSite:@"2"];

        }];
    }
   else if (indexPath.row == 2) { // Button click for Instagram
        [SharedMethods showAlertActionWithTitle:@"Alert" message:@"Are you want to add Instagram" completion:^(id obj) {
            NSLog(@"just test");
            [self CreateSocialSiteWithSocialSite:@"3"];
        }];
        
    }
   else if (indexPath.row == 3) { // Button click for LinkedIn
       
       
       
       [LISDKSessionManager clearSession];
       __block NSString *reqURL = [NSString stringWithFormat:@"https://www.linkedin.com/v1/people/~:(id,first-name,last-name,headline,picture-url,industry,summary,specialties,positions:(id,title,summary,start-date,end-date,is-current,company:(id,name,type,size,industry,ticker)),skills:(id,skill:(name)),three-current-positions,three-past-positions,volunteer)?format=json"];
       NSLog(@"%@    blank",[[[LISDKSessionManager sharedInstance] session].accessToken accessTokenValue]);
       [LISDKSessionManager createSessionWithAuth:[NSArray arrayWithObjects:LISDK_BASIC_PROFILE_PERMISSION,LISDK_EMAILADDRESS_PERMISSION,nil]
                                            state:@"some state"
                           showGoToAppStoreDialog:YES
                                     successBlock:^(NSString *returnState) {
                                         
                                         NSLog(@"%s","success called!");
                                         LISDKSession *session = [[LISDKSessionManager sharedInstance] session];
                                         NSString *authtoken = [[[LISDKSessionManager sharedInstance] session].accessToken accessTokenValue];
                                         NSLog(@"%@",authtoken);
                                         if(session)
                                         {
                                             [[LISDKAPIHelper sharedInstance] apiRequest:reqURL
                                                                                  method:@"GET"
                                                                                    body:[_bodyResult.text dataUsingEncoding:NSUTF8StringEncoding]
                                                                                 success:^(LISDKAPIResponse *response) {
                                                                                     //NSLog(@"2nd success called %@", response.data);
                                                                                     [self CreateSocialSiteWithSocialSite:@"4"];
                                                                                     
                                                                                 }
                                                                                   error:^(LISDKAPIError *apiError) {
                                                                                       
                                                                                   }];
                                         }
                                     }
                                       errorBlock:^(NSError *error) {
                                           NSLog(@"%s %@","error called! ", [error description]);
                                           
                                       }
        ];
       
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

# pragma Mark Get followers list

-(void)getTwitterFollowersListForUserID:(NSString *)userid{
    //NSString *statusesShowEndpoint = @"https://api.twitter.com/1.1/followers/list.json";
    NSString *statusesShowEndpoint = @"https://api.twitter.com/1.1/friends/list.json";
    NSDictionary *params = @{@"id" : userid};
    NSError *clientError;
    TWTRAPIClient *client = [[TWTRAPIClient alloc] initWithUserID:userid];
    NSURLRequest *request = [client URLRequestWithMethod:@"GET" URL:statusesShowEndpoint parameters:params error:&clientError];
    // if (request) {
    [client sendTwitterRequest:request completion:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data) {
            // handle the response data e.g.
            NSError *jsonError;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            NSLog(@"%@",json);
            NSLog(@"followers List %lu",(unsigned long)[[json valueForKey:@"users"] count]);
            
        }
        else {
            NSLog(@"Error: %@", connectionError);
        }
    }];
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
