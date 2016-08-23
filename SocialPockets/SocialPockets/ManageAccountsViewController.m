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

@interface ManageAccountsViewController ()<UITableViewDataSource, UITableViewDelegate,CollectionViewDataDelegate>

@property (nonatomic,strong) __block NSMutableArray *bankAccountsArray;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation ManageAccountsViewController{
    NSMutableArray *infoArray;
    NSArray *HeaderArray;
}

- (void)viewDidLoad {
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
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@" " style:UIBarButtonItemStylePlain target:self action:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //    infoArray = [self generateImageArray];
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
                                                                   @"ImageText":@"Aadhar Card"
                                                                   },
                                                                 @{@"ImageName":@"PanCardIcon",
                                                                   @"ImageText":@"PAN Card"
                                                                   },]
                                       },
                                     @{@"Social Account":@[@{@"ImageName":@"FacebookIcon",
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
                                                           ]
                                       },
                                     @{@"Money Account":@[@{@"ImageName":@"HDFCIcon",
                                                            @"ImageText":@"HDFC",
                                                            @"Account Number":@"1231231123"
                                                            },
                                                          @{@"ImageName":@"AddAccountIcon",
                                                            @"ImageText":@"ADD account"
                                                            },]
                                       }]mutableCopy];
#warning Need to work
    
    NSMutableArray *accountArray = [[NSMutableArray alloc] init];
    if ([NetworkHelperClass getInternetStatus:NO])
    {
        [BANKACCHELPER showAllAccountWithcompletion:^(id obj) {
            for (int i = 0; i<[obj count]; i++) {
                NSMutableDictionary *temp = [[NSMutableDictionary alloc] init];
                [temp setValue:[[obj objectAtIndex:i] valueForKey:@"USRMW_BANK_NAME"] forKey:@"ImageText"];
                [temp setValue:@"BankWithoutACCNO" forKey:@"ImageName"];
                [temp setValue:[[obj objectAtIndex:i] valueForKey:@"USRMW_ACCOUNT_NUMBER"] forKey:@"Account Number"];
                [accountArray addObject:temp];
            }
            if ([obj count]<3) {
                NSMutableDictionary *temp = [[NSMutableDictionary alloc] init];
                [temp setValue:@"Add account" forKey:@"ImageText"];
                [temp setValue:@"AddAccountIcon" forKey:@"ImageName"];
                [accountArray addObject:temp];
                
            }
            NSDictionary *replacingDict = @{@"Money Account":accountArray
                                            };
            [imagesArray replaceObjectAtIndex:2 withObject:replacingDict];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }];
    }
    return imagesArray;
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
    linesLabel.text = section == 1 ? @"1/4 Linked" : @"";
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
    NSLog(@"Indexpath --- %@ --- %@",tableIndexPath,collectionIndexPath);
    if (tableIndexPath.section == 1) {
        switch (collectionIndexPath.row) {
            case 0:
            {
                [SOCIALMACRO faceBookLoginButtonClickedWithCompletion:^(id obj) {
                    NSLog(@"FaceBook login Success");
                    [self CreateSocialSiteWithSocialSite:@"1"];
                } ];
            }
                break;
            case 1:{
                [SOCIALMACRO TwitterLoginBtnClickedWithCompletion:^(id obj) {
                    NSLog(@"Twitter login Success");
                    [self CreateSocialSiteWithSocialSite:@"2"];
                }];
            }
                break;
            case 2:
                break;
            case 3:
                break;
                
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

#pragma mark Creation of socialSiteId

-(void)CreateSocialSiteWithSocialSite:(NSString*)socialSiteId{
    [SOCIALMACRO createSocialSite:socialSiteId details:@"just to test" createdBy:@"25" completion:^(id obj) {
        NSLog( @"socail site created: %@",obj);
    }];
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
