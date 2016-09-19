//
//  ManageAccountsViewController.m
//  SocialPockets
//
//  Created by ideas2it-Kovendhan on 01/08/16.
//  Copyright © 2016 Pandiyaraj. All rights reserved.
//

#import "ManageAccountsViewController.h"
#import "CollectionTableViewCell.h"
#import "AddBankAccountController.h"
#import "IGLoginViewController.h"

@interface ManageAccountsViewController ()<UITableViewDataSource, UITableViewDelegate,CollectionViewDataDelegate>

@property (nonatomic,strong) __block NSMutableArray *bankAccountsArray;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation ManageAccountsViewController{
    NSMutableArray *infoArray;
    NSArray *HeaderArray;
    int linkedAccountCount;
}

- (void)viewDidLoad {
    linkedAccountCount = 0;
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.title = @"Manage Accounts";
    infoArray =[[NSMutableArray alloc]init];
    self.bankAccountsArray = [[NSMutableArray alloc]init];
    //    [self loadSectionData];
    infoArray = [self generateImageArray];
    //    [self getAccountDetails];
    self.tableView.scrollEnabled = NO;
    HeaderArray = @[@"Identification Proof", @"Social Account", @"Money Account"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CollectionTableViewCell" bundle:nil] forCellReuseIdentifier:@"CollectionTableViewCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (IPHONE6PLUS_STANDARD){
        self.backgroundImage.image = [UIImage imageNamed:@"NotificationBG6Splus.png"];
        
    }else if (IPHONE5){
        self.backgroundImage.image = [UIImage imageNamed:@"NotificationBG.png"];
        
    }else if(IPHONE6_STANDARD){
        self.backgroundImage.image = [UIImage imageNamed:@"NotificationBG6S.png"];
        
    }else{
        self.backgroundImage.image = [UIImage imageNamed:@"NotificationBG4S.png"];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadManageAccounts) name:@"ReloadManageAccounts" object:nil];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@" " style:UIBarButtonItemStylePlain target:self action:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //    infoArray = [self generateImageArray];
    [self.tableView reloadData];
}
- (void)reloadManageAccounts
{
    infoArray = [self generateImageArray];
    [self.tableView reloadData];

}



#pragma generateImages ::: delete this after the original image

//#-- Edit by pandi
/*- (void)getAccountDetails
 {
 [BANKACCHELPER showAllAccountWithcompletion:^(id obj) {
 [self.bankAccountsArray addObjectsFromArray:obj];
 [self loadSectionData];
 }];
 } */

/* - (void)loadSectionData
 {
 [infoArray removeAllObjects];
 
 NSMutableArray *firstSection=[@[@{@"ImageName":@"AadharIcon",
 @"ImageText":@"Aadhar Card"
 },
 @{@"ImageName":@"PanCardIcon",
 @"ImageText":@"PAN Card"
 }
 ]mutableCopy];
 
 NSMutableArray *secondSection=[@[@{@"ImageName":@"FacebookIcon",
 @"ImageText":@"Facebook"
 },
 @{@"ImageName":@"TwitterIcon",
 @"ImageText":@"Twitter"
 },
 @{@"ImageName":@"InstagramIcon",
 @"ImageText":@"Instagram"
 },
 @{@"ImageName":@"LinkedinIcon",
 @"ImageText":@"LinkedIn"
 }
 ]mutableCopy];
 
 [infoArray addObject:firstSection];
 [infoArray addObject:secondSection];
 NSMutableArray *thirdSection = [[NSMutableArray alloc]init];
 if (self.bankAccountsArray.count) {
 for (int x = 0; x<self.bankAccountsArray.count; x++) {
 NSDictionary *bankAccountDetail = self.bankAccountsArray[x];
 NSDictionary *alertDict= @{@"ImageText" : [bankAccountDetail valueForKey:@"USRMW_BANK_NAME"],
 @"ImageName":@"BankWithoutACCNO",
 @"Account Number" : [bankAccountDetail valueForKey:@"USRMW_ACCOUNT_NUMBER"]
 };
 [thirdSection insertObject:alertDict atIndex:x];
 }
 if (thirdSection.count != 3) {
 NSDictionary *alertDict= @{@"ImageText" : @"Add account",
 @"ImageName":@"AddAccountIcon"
 };
 [thirdSection insertObject:alertDict atIndex:thirdSection.count];
 }
 
 }else
 {
 NSDictionary *alertDict= @{@"ImageText" : @"Add account",
 @"ImageName":@"AddAccountIcon"
 };
 [thirdSection insertObject:alertDict atIndex:0];
 }
 [infoArray addObject:thirdSection];
 dispatch_async(dispatch_get_main_queue(), ^{
 [self.tableView reloadData];
 });
 } */
-(NSMutableArray *)generateImageArray {
    NSMutableArray *imagesArray = [@[@{@"Identification Proof":@[@{@"ImageName":@"AadharIcon",
                                                                   @"ImageText":@"Aadhar Card",
                                                                   @"Linked":[NSNumber numberWithBool:NO]
                                                                   },
                                                                 @{@"ImageName":@"PanCardIcon",
                                                                   @"ImageText":@"PAN Card",
                                                                   @"Linked":[NSNumber numberWithBool:NO]
                                                                   },]
                                       },
                                     @{@"Social Account":[@[@{@"ImageName":@"FacebookIcon",
                                                             @"ImageText":@"Facebook",
                                                             @"Linked":[NSNumber numberWithBool:NO]
                                                             },
                                                           @{@"ImageName":@"TwitterIcon",
                                                             @"ImageText":@"Twitter",
                                                              @"Linked":[NSNumber numberWithBool:NO]
                                                             },
                                                           @{@"ImageName":@"InstagramIcon",
                                                             @"ImageText":@"Instagram",
                                                              @"Linked":[NSNumber numberWithBool:NO]
                                                             },
                                                           @{@"ImageName":@"LinkedinIcon",
                                                             @"ImageText":@"LinkedIn",
                                                              @"Linked":[NSNumber numberWithBool:NO]
                                                             }
                                                           ]mutableCopy]
                                       },
                                     @{@"Money Account":@[@{@"ImageName":@"HDFCIcon",
                                                            @"ImageText":@"HDFC",
                                                            @"Account Number":@"1231231123",
                                                            @"Linked":[NSNumber numberWithBool:YES]
                                                            },
                                                          @{@"ImageName":@"AddAccountIcon",
                                                            @"ImageText":@"ADD account",
                                                            @"Linked":[NSNumber numberWithBool:YES]
                                                            },]
                                       }]mutableCopy];
#warning Need to work
    
    NSMutableArray *accountArray = [[NSMutableArray alloc] init];
    if ([NetworkHelperClass getInternetStatus:NO])
    {
        [BANKACCHELPER showAllAccountWithcompletion:^(id obj) {
            if ([obj isKindOfClass:[NSArray class]]) {
                for (int i = 0; i<[obj count]; i++) {
                    NSMutableDictionary *temp = [[NSMutableDictionary alloc] init];
                    [temp setValue:[[obj objectAtIndex:i] valueForKey:@"USRMW_BANK_NAME"] forKey:@"ImageText"];
                    [temp setValue:@"BankWithoutACCNO" forKey:@"ImageName"];
                    [temp setValue:[[obj objectAtIndex:i] valueForKey:@"USRMW_ACCOUNT_NUMBER"] forKey:@"Account Number"];
                    [temp setValue:[NSNumber numberWithBool:YES] forKey:@"Linked"];
                    [accountArray addObject:temp];
                }
                if ([obj count]<3) {
                    NSMutableDictionary *temp = [[NSMutableDictionary alloc] init];
                    [temp setValue:@"Add account" forKey:@"ImageText"];
                    [temp setValue:@"AddAccountIcon" forKey:@"ImageName"];
                    [temp setValue:[NSNumber numberWithBool:NO] forKey:@"Linked"];
                    [accountArray addObject:temp];
                    
                }
                NSDictionary *replacingDict = @{@"Money Account":accountArray
                                                };
                [imagesArray replaceObjectAtIndex:2 withObject:replacingDict];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }else{
                NSLog(@"Nothing do");
            }
           
        }];
        
        
        [SOCIALMACRO viewSocialSiteWithCompletion:^(id obj) {
            if ([obj count]) {
              
                NSMutableArray *socialDict = [[imagesArray objectAtIndex:1] valueForKey:@"Social Account"];
                id arrayObj = [obj valueForKeyPath:@"USRSOC_SOCIAL_ID"];
                arrayObj  = [self arrayByEliminatingDuplicatesMaintainingOrder:arrayObj];
                linkedAccountCount = (int)[arrayObj count];
                for (NSNumber *selectedValue in arrayObj) {
                    switch (selectedValue.intValue) {
                        case 1:
                        {
                            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                            [dict setValue:@"FacebookIcon" forKey:@"ImageName"];
                            [dict setValue:@"Facebook" forKey:@"ImageText"];
                            [dict setValue:[NSNumber numberWithBool:YES] forKey:@"Linked"];
                            [socialDict replaceObjectAtIndex:0 withObject:dict];
                            break;
                        }
                        case 2:
                        {
                            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                            [dict setValue:@"TwitterIcon" forKey:@"ImageName"];
                            [dict setValue:@"Twitter" forKey:@"ImageText"];
                            [dict setValue:[NSNumber numberWithBool:YES] forKey:@"Linked"];
                            [socialDict replaceObjectAtIndex:1 withObject:dict];
                            break;
                        }
                        case 3:
                        {
                            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                            [dict setValue:@"InstagramIcon" forKey:@"ImageName"];
                            [dict setValue:@"Instagram" forKey:@"ImageText"];
                            [dict setValue:[NSNumber numberWithBool:YES] forKey:@"Linked"];
                            [socialDict replaceObjectAtIndex:2 withObject:dict];
                            break;
                        }
                        case 4:
                        {
                            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                            [dict setValue:@"LinkedinIcon" forKey:@"ImageName"];
                            [dict setValue:@"LinkedIn" forKey:@"ImageText"];
                            [dict setValue:[NSNumber numberWithBool:YES] forKey:@"Linked"];
                            [socialDict replaceObjectAtIndex:3 withObject:dict];
                            break;
                        }
                        default:
                            break;
                    }
                }
                NSDictionary *replacingDict = @{@"Social Account":socialDict
                                                };
                [imagesArray replaceObjectAtIndex:1 withObject:replacingDict];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });


            }
        }];
        
    }
    return imagesArray;
}

- (NSArray *)arrayByEliminatingDuplicatesMaintainingOrder:(NSArray *)orgArray
{
    NSMutableSet *addedObjects = [NSMutableSet set];
    NSMutableArray *result = [NSMutableArray array];
    
    for (id obj in orgArray) {
        if (![addedObjects containsObject:obj]) {
            [result addObject:obj];
            [addedObjects addObject:obj];
        }
    }
    
    return result;
}


#pragma mark - UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CollectionTableViewCell *cell = (CollectionTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CollectionTableViewCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[CollectionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CollectionTableViewCell"];
    }
    cell.imageArray = infoArray;
    cell.currentTableIndex = indexPath;
    cell.delegate = self;
    [cell setInitialCollectionView];
    return cell;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 11, 145, 21)];
    titleLabel.text = [HeaderArray objectAtIndex:section];
    
    
    UILabel *linesLabel = [[UILabel alloc] initWithFrame:CGRectMake(tableView.frame.size.width-120, 11, 100, 21)];
    NSString *linkedCount = [NSString stringWithFormat:@"%d/4 Linked",linkedAccountCount];
    linesLabel.text = (section == 1) ? linkedCount : @"";
    linesLabel.textAlignment = NSTextAlignmentRight;
    linesLabel.textColor = [UIColor colorWithRed:41.0/255.0 green:158.0/255.0 blue:19.0/255.0 alpha:1.0];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)];
    [view addSubview:titleLabel];
    [view addSubview:linesLabel];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectRowAtIndexPath");
}

- (void)selectedCellTableIndexPath:(NSIndexPath *)tableIndexPath collectionIndexPath:(NSIndexPath *)collectionIndexPath
{
    if (tableIndexPath.section == 1) {
        switch (collectionIndexPath.row) {
            case 0:
            {
                [SOCIALMACRO facebookLoginWithCompletion:^(id obj) {
                    NSLog(@"FaceBook login Success");
                    //                    [self CreateSocialSiteWithSocialSite:@"1"];
                    infoArray = [self generateImageArray];
                    [self.tableView reloadData];
                } ];
            }
                break;
            case 1:{
                [ACTIVITY showActivity:@"Fetching twitter details from the settings..."];
                [SOCIALMACRO twitterLoginWithCompletion:^(id obj) {
                    NSLog(@"Twitter login Success");
                    //#-- Change selected color
                    [ACTIVITY performSelectorOnMainThread:@selector(hideActivity) withObject:nil waitUntilDone:YES];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        infoArray = [self generateImageArray];
                        [self.tableView reloadData];
                    });
                }];
            }
                break;
                
            case 2:
            { //  for Instagram
                
                IGLoginViewController *IGloginVc = [self.storyboard instantiateViewControllerWithIdentifier:@"IGLoginView"];
                UINavigationController *navVc = [[UINavigationController alloc]initWithRootViewController:IGloginVc];
                [self presentViewController:navVc animated:YES completion:NULL];
                IGloginVc.onLogin = ^(id obj){
                    infoArray = [self generateImageArray];
                    [self.tableView reloadData];
                    [[NSUserDefaults standardUserDefaults] setObject:obj forKey:@"InstagramAccessToken"];
                    
                    NSLog(@"Auth Token %@",obj);
                    [SOCIALMACRO instagramLoginWithUserToken:obj WithCompletion:^(id obj) {
                        [SOCIALMACRO instagramDetailWithUserToken:[[NSUserDefaults standardUserDefaults] valueForKey:@"InstagramAccessToken"] WithCompletion:^(id obj) {
                            
                        }];
                    }];
                };
            }
                break;
                
            case 3:{
                [SOCIALMACRO linkedInLoginWithCompletion:^(id obj) {
                    infoArray = [self generateImageArray];
                    [self.tableView reloadData];
                }];
                break;
            }
                
            default:
                break;
        }
    }
    
    NSDictionary *currentSectionDictionary = infoArray[tableIndexPath.section];
    if (tableIndexPath.section == 2 &&  [[[currentSectionDictionary objectForKey:@"Money Account"] objectAtIndex:collectionIndexPath.row] valueForKey:@"Account Number"] == nil) {
        AddBankAccountController *addBankAccount = [self.storyboard instantiateViewControllerWithIdentifier:@"AddBankAccount"];
        [self.navigationController pushViewController:addBankAccount animated:YES];
        addBankAccount.onCreate = ^(id obj)
        {
            infoArray = [self generateImageArray];
            [self.tableView reloadData];
        };
    }
}

- (void)updateArrayValues:(id)object currentIndex:(int)index
{
    
    
#warning need to work
    if (index == 2) {
        // replace
    }
    
    
    
    
}

-(void) formattedDictionary {
    
    
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
