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
    NSMutableArray *bankAccountArray;
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

    // Do any additional setup after loading the view.
    
    bankAccountArray=[@[@{@"USRMW_BANK_NAME" : @"HDFC",
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
            if ([obj isKindOfClass:[NSArray class]]) {
                NSLog( @"Bank Accounts list: %@",obj);
                [bankAccountArray removeAllObjects];
                obj = [obj filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"USRMW_STATUS == 1"]];
                [bankAccountArray addObjectsFromArray:obj];
                [self.accountTableView reloadData];

            }
                   }];
    }
    self.accountTableView.layer.cornerRadius = 7;
    
    self.title = @"Request Confirmation";
    previousIndexpath = nil;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@" " style:UIBarButtonItemStylePlain target:self action:nil];
    
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
    return bankAccountArray.count >= MAX_ACCOUNT ? bankAccountArray.count:[bankAccountArray count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:
(NSIndexPath *)indexPath{
    
    NSString *CellId = @"accountCell";
    if (indexPath.row == bankAccountArray.count) {
        CellId = nil;
    }
    UITableViewCell *cell =(CellId!=nil)?[tableView dequeueReusableCellWithIdentifier:CellId forIndexPath:indexPath]:[tableView dequeueReusableCellWithIdentifier:CellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellId];
    }
    if (indexPath.row == bankAccountArray.count) {
        cell.textLabel.text = @"+ Add new account";
        cell.textLabel.textColor =[UIColor blueColor];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    else{
        UILabel *titlename = (UILabel *)[cell.contentView viewWithTag:999];
        
        titlename.text = [[bankAccountArray objectAtIndex:indexPath.row] objectForKey:@"USRMW_BANK_NAME"];
        UILabel *subtitlename = (UILabel *)[cell.contentView viewWithTag:888];
        
        subtitlename.text = [[bankAccountArray objectAtIndex:indexPath.row] objectForKey:@"USRMW_ACCOUNT_NUMBER"];
        
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        
        UIButton *check = (UIButton *)[cell.contentView viewWithTag:777];
        check.selected = [[[bankAccountArray objectAtIndex:indexPath.row] valueForKey:@"Selected"] boolValue];
        
    }
    return cell;
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == bankAccountArray.count) {
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
    
    [bankAccountArray removeObjectAtIndex:indexPath.row];
    [tableView reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

#pragma mark tableview delegate methods
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if((indexPath.row) == bankAccountArray.count)
    {
        AddBankAccountController *addBankAccount = [self.storyboard instantiateViewControllerWithIdentifier:@"AddBankAccount"];
        [self.navigationController pushViewController:addBankAccount animated:YES];
        return;
        
       [bankAccountArray insertObject:[@{@"BankName":@"Axis",@"AccountNum":@"126547682354872",@"Selected":[NSNumber numberWithBool:NO]}mutableCopy] atIndex:bankAccountArray.count];
        [tableView reloadData];
    }
    else{
        NSMutableDictionary *currentSelectedObj = [[bankAccountArray objectAtIndex:indexPath.row] mutableCopy];
        BOOL isSelectedValue = [[currentSelectedObj valueForKey:@"Selected"] boolValue];
        [currentSelectedObj setValue:[NSNumber numberWithBool:!isSelectedValue] forKey:@"Selected"];
        [bankAccountArray replaceObjectAtIndex:indexPath.row withObject:currentSelectedObj];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        bankAccountId = [[bankAccountArray objectAtIndex:indexPath.row] valueForKey:@"USRMW_ID"];
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
                         ErrorMessageWithTitle(@"Message", @"Something went wrong");
                         self.transprantView.hidden = YES;
                     }
                 }];
             }else{
                 ErrorMessageWithTitle(@"Message", @"Invalid password");
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

@end
