//
//  RequestConfirmation.m
//  SocialPockets
//
//  Created by Ideas2IT-GaneshM on 27/07/16.
//  Copyright © 2016 Pandiyaraj. All rights reserved.
//

#import "RequestConfirmationViewController.h"
#import "DashBoardViewController.h"
#import "AddBankAccountController.h"
@interface RequestConfirmationViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *accountArray;
    NSMutableDictionary *accountDict;
    NSIndexPath *previousIndexpath;
    NSString *bankAccountId;
}
@property (weak, nonatomic) IBOutlet UITableView *accountTableView;
@property (weak, nonatomic) IBOutlet UIButton *acceptance;
@property (weak, nonatomic) IBOutlet UIView *transprantView;
@property (weak, nonatomic) IBOutlet UIView *thanksView,*passwordView;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@end

@implementation RequestConfirmationViewController
@synthesize loanInHandAmount, loanAmount,tenurePeriod;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.transprantView.hidden = YES;
    self.thanksView.hidden = YES;
    self.accountTableView.allowsMultipleSelectionDuringEditing = NO;
    
    
    // Do any additional setup after loading the view.
    accountArray = [[NSMutableArray alloc] init];
    accountArray=[@[@{@"USRMW_BANK_NAME" : @"HDFC",
                      @"USRMW_ACCOUNT_NUMBER" : @"123456789",
                      @"USRMW_IFSC_CODE": @"HDFC1206",
                      @"USRMW_ID": @"1",
                      @"Selected" : [NSNumber numberWithBool:NO]
                      },
                    @{@"USRMW_BANK_NAME" : @"Axis",
                      @"USRMW_ACCOUNT_NUMBER" : @"123456789",
                      @"USRMW_IFSC_CODE": @"HDFC1206",
                      @"USRMW_ID": @"2",
                      @"Selected" : [NSNumber numberWithBool:NO]
                      },
                    @{@"USRMW_BANK_NAME" : @"ICICI",
                      @"USRMW_ACCOUNT_NUMBER" : @"123456789",
                      @"USRMW_IFSC_CODE": @"HDFC1206",
                      @"USRMW_ID": @"3",
                      @"Selected" : [NSNumber numberWithBool:NO]
                      }
                    ]mutableCopy];
    
    if ([NetworkHelperClass getInternetStatus:NO])
    {
        [BANKACCHELPER showAllAccountWithcompletion:^(id obj) {
            if ([obj isKindOfClass:[NSArray class]] && [obj count]) {
                NSLog( @"Bank Accounts list: %@",obj);
                [accountArray removeAllObjects];
                //  obj = [obj filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(SELF.USRMW_STATUS = 2)"]];
                obj = [obj filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(%K = %@)", @"USRMW_STATUS", @"1"]];
                
                //                for (int i=0; i<[obj count]; i++) {
                //                    if([[[obj objectAtIndex:i] objectForKey:@"USRMW_STATUS"] isEqualToString:@"1"]){
                //                        [bankAccountArray addObject:[obj objectAtIndex:i]];
                //                    }
                //                }
                [accountArray addObjectsFromArray:obj];
                NSLog(@"%@",accountArray);
                [self.accountTableView reloadData];
                
            }
        }];
    }
    self.accountTableView.layer.cornerRadius = 7;
    
    self.title = @"Request Confirmation";
    previousIndexpath = nil;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@" " style:UIBarButtonItemStylePlain target:self action:nil];
    bankAccountId = @"1";
    //#-- Status Bar Color Change
    [self setNeedsStatusBarAppearanceUpdate];
    
    [self updateLabels];
    
}


- (void)updateLabels
{
    NSDate *startDate =[NSDate date];
    NSDate *endDate = [SharedMethods addDaysToDate:[self.tenurePeriod intValue] startDate:startDate];
    loanRequestStartDate.text = [NSString stringWithFormat:@"%@",[SharedMethods convertString:[SharedMethods stringFromGivenDate:startDate formatType:LOCALDATETIMEFORMAT] fromFormat:LOCALDATETIMEFORMAT toFormat:DATEFORMAT]];
    loanRequestEndDate.text = [SharedMethods convertString:[SharedMethods stringFromGivenDate:endDate formatType:LOCALDATETIMEFORMAT] fromFormat:LOCALDATETIMEFORMAT toFormat:DATEFORMAT];
    loanAmountLabel.text = loanAmount;
    loanInHandAmountLabel.text = loanInHandAmount;
    tenurePeriodLabel.text = [NSString stringWithFormat:@"%@ Days Tenure Period",self.tenurePeriod];
    okButton.layer.cornerRadius = 5.0;
    okButton.layer.borderColor = [UIColor colorWithRed:38.0/255.0 green:146.0/255.0 blue:255.0/255.0 alpha:1.0].CGColor;
    okButton.layer.borderWidth = 1.0;
}
#pragma mark tableview datasource methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return accountArray.count >= MAX_ACCOUNT ? accountArray.count:[accountArray count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:
(NSIndexPath *)indexPath{
    
    NSString *CellId = @"accountCell";
    if (indexPath.row == accountArray.count) {
        CellId = nil;
    }
    UITableViewCell *cell =(CellId!=nil)?[tableView dequeueReusableCellWithIdentifier:CellId forIndexPath:indexPath]:[tableView dequeueReusableCellWithIdentifier:CellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellId];
    }
    if (indexPath.row == accountArray.count) {
        cell.textLabel.text = @"+ Add new account";
        cell.textLabel.textColor =[UIColor blueColor];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    else{
        UILabel *titlename = (UILabel *)[cell.contentView viewWithTag:999];
        
        titlename.text = [[accountArray objectAtIndex:indexPath.row] objectForKey:@"USRMW_BANK_NAME"];
        UILabel *subtitlename = (UILabel *)[cell.contentView viewWithTag:888];
        
        subtitlename.text = [[accountArray objectAtIndex:indexPath.row] objectForKey:@"USRMW_ACCOUNT_NUMBER"];
        
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        
        UIButton *check = (UIButton *)[cell.contentView viewWithTag:777];
        check.selected = [[[accountArray objectAtIndex:indexPath.row] valueForKey:@"Selected"] boolValue];
        
    }
    return cell;
}
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    return YES;
//}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == accountArray.count) {
        return NO;
    }
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[BANKACCHELPER deleteBankAccountWithId:USERID modifiedBy:<#(NSString *)#> completion:<#^(id obj)completionBlock#>]
    if(editingStyle == UITableViewCellEditingStyleDelete){
    [accountArray removeObjectAtIndex:indexPath.row];
    [tableView reloadData];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

#pragma mark tableview delegate methods
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if((indexPath.row) == accountArray.count)
    {
        //        AddBankAccountController *addBankAccount = [self.storyboard instantiateViewControllerWithIdentifier:@"AddBankAccount"];
        //        [self.navigationController pushViewController:addBankAccount animated:YES];
        //        return;
        //
        //       [bankAccountArray insertObject:[@{@"BankName":@"Axis",@"AccountNum":@"126547682354872",@"Selected":[NSNumber numberWithBool:NO]}mutableCopy] atIndex:bankAccountArray.count];
        //        [tableView reloadData];
    }
    else{
        
        if ( previousIndexpath != indexPath ) {
            [self updateButtonStatusWithIndexPath:indexPath];
            if (previousIndexpath!=nil) {
                [self updateButtonStatusWithIndexPath:previousIndexpath];
            }
            previousIndexpath = indexPath;
            [tableView reloadData];
            //[tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            bankAccountId = [[accountArray objectAtIndex:indexPath.row] valueForKey:@"USRMW_ID"];
            
        }
        
        
        
        
        
        //        UITableViewCell *currentCell = [tableView cellForRowAtIndexPath:indexPath];
        //
        //        if (previousIndexpath != indexPath) {
        //            UITableViewCell *prevCell = [tableView cellForRowAtIndexPath:previousIndexpath];
        //            UIButton *check = (UIButton *)[prevCell.contentView viewWithTag:777];
        //            [self changeAction:check];
        //            previousIndexpath = nil;
        //        }
        //
        //        UIButton *check = (UIButton *)[currentCell.contentView viewWithTag:777];
        //        [self changeAction:check];
        //        previousIndexpath = indexPath;
    }
    
    
}
-(void)updateButtonStatusWithIndexPath:(NSIndexPath *)indexpath{
    NSMutableDictionary *SelectedObj = [[accountArray objectAtIndex:indexpath.row] mutableCopy];
    BOOL isPreSelectedValue = [[SelectedObj valueForKey:@"Selected"] boolValue];
    [SelectedObj setValue:[NSNumber numberWithBool:!isPreSelectedValue] forKey:@"Selected"];
    [accountArray replaceObjectAtIndex:indexpath.row withObject:SelectedObj];
}

#pragma mark button actions
- (void)changeAction:(id)sender
{
    UIButton *idSender = sender;
    idSender.selected = !idSender.selected;
}

- (IBAction)doneButtonAction:(id)sender {
    if (self.acceptance.selected) {
        self.transprantView.hidden = NO;
        self.passwordView.hidden = NO;
    }else{
        ErrorMessageWithTitle(@"Warning", @"Please accept terms and conditions");
    }
}

- (IBAction)onPasswordOkAction:(id)sender
{
    if (!self.passwordTextField.text.length) {
        ErrorMessageWithTitle(@"Message", @"Please enter password");
    }else{
        [PROFILEMACRO passWordValidation:self.passwordTextField.text completion:^(id obj) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                self.passwordView.hidden = YES;
                [LOANMACRO requestLoanForUserId:[[NSUserDefaults standardUserDefaults] valueForKey:USERID] amount:self.loanAmount mobileWallerId:bankAccountId completion:^(id obj) {
                    if ([obj isKindOfClass:[NSDictionary class]]) {
                        self.transprantView.hidden = NO;
                        self.thanksView.hidden = NO;
                    }
                    else{
                        ErrorMessageWithTitle(@"Message", obj);
                        self.transprantView.hidden = YES;
                    }
                }];
            }else{
                ErrorMessageWithTitle(@"Message", obj);
            }
        }];
    }
}

- (IBAction)onPasswordCloseAction:(id)sender
{
    self.transprantView.hidden = YES;
    self.passwordView.hidden = YES;
}

- (IBAction)closeButtonAction:(id)sender {
    self.transprantView.hidden = YES;
    self.thanksView.hidden = YES;
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"loanIsProcessed"];
    for (UIViewController* viewController in self.navigationController.viewControllers) {
        if ([viewController isKindOfClass:[DashBoardViewController class]] ) {
            DashBoardViewController *dashboard = (DashBoardViewController*)viewController;
            [self.navigationController popToViewController:dashboard animated:YES];
            break;
        }
    }
}

- (IBAction)acceptBtn:(id)sender {
    _acceptance.selected = !_acceptance.selected;
}


#pragma mark view memory
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark StatusBar Style
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
//-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    UITableViewRowAction *delete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Delete" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
//                                    {
//                                        // Delete something here
//                                    }];
//    delete.backgroundColor = [UIColor redColor];
//    
//    UITableViewRowAction *more = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@" More " handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
//                                  {
//                                      //Just as an example :
//                                     // [self presentUIAlertControllerActionSheet];
//                                  }];
//    more.backgroundColor = [UIColor colorWithRed:0.188 green:0.514 blue:0.984 alpha:1];
//    
//    return @[delete, more]; //array with all the buttons you want. 1,2,3, etc...
//}


@end
