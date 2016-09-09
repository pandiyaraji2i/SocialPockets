//
//  RequestConfirmation.m
//  SocialPockets
//
//  Created by Ideas2IT-GaneshM on 27/07/16.
//  Copyright © 2016 Pandiyaraj. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import "RequestConfirmationViewController.h"
#import "DashBoardViewController.h"
#import "AddBankAccountController.h"
#import "SwipeTableCell.h"
#import "SwipeButton.h"


@interface RequestConfirmationViewController ()<UITableViewDataSource,UITableViewDelegate,SwipeTableCellDelegate,CLLocationManagerDelegate>{
    NSMutableArray *accountArray;
    NSMutableDictionary *accountDict;
    NSIndexPath *previousIndexpath;
    NSString *bankAccountId,*_longitude,*_latitude;
  
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
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
    [self CurrentLocationIdentifier];
    self.transprantView.hidden = YES;
    self.thanksView.hidden = YES;
    self.accountTableView.allowsMultipleSelectionDuringEditing = YES;
    
    
    // Do any additional setup after loading the view.
    accountArray = [[NSMutableArray alloc] init];    
    [self downloadAccounts];
    self.accountTableView.layer.cornerRadius = 7;
    
    self.title = @"Request Confirmation";
    previousIndexpath = nil;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@" " style:UIBarButtonItemStylePlain target:self action:nil];
//    bankAccountId = @"1";
    //#-- Status Bar Color Change
    [self setNeedsStatusBarAppearanceUpdate];
    
    [self updateLabels];
    self.accountTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (void)downloadAccounts
{
    if ([NetworkHelperClass getInternetStatus:NO])
    {
        [ACTIVITY showActivity:@"Fetching accounts..."];
        [BANKACCHELPER showAllAccountWithcompletion:^(id obj) {
            [ACTIVITY performSelectorOnMainThread:@selector(hideActivity) withObject:nil waitUntilDone:YES];
            if ([obj isKindOfClass:[NSArray class]]/* && [obj count]*/) {
                [accountArray removeAllObjects];
                //                  obj = [obj filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"USRMW_STATUS == %@", @"1"]];
                obj = [obj filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(%K = %@)", @"USRMW_STATUS", @"1"]];
                [accountArray addObjectsFromArray:obj];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.accountTableView reloadData];
                });
            }
        }];
    }
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
    SwipeTableCell *cell =(CellId!=nil)?[tableView dequeueReusableCellWithIdentifier:CellId forIndexPath:indexPath]:[tableView dequeueReusableCellWithIdentifier:CellId];
    if (cell == nil) {
        cell = [[SwipeTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellId];
    }
    cell.delegate = self;
    cell.backgroundColor  =[UIColor clearColor];
    if (indexPath.row == accountArray.count) {
        cell.textLabel.text = @"+ Add new account";
        cell.textLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:13];
        cell.textLabel.textColor =[UIColor colorWithRed:38.0/255.0 green:147.0/255.0 blue:255.0/255.0 alpha:1.0];
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
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.accountTableView.frame.size.width, 40)];
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, headerView.frame.size.width, headerView.frame.size.height)];
    titleLbl.text = @"Pick an account to credit the Loan";
    titleLbl.textColor = [UIColor grayColor];
    titleLbl.font = [UIFont fontWithName:@"Roboto-Light" size:13];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:titleLbl];
    return headerView;
}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    return YES;
//}
/*- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
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
    if (editingStyle == UITableViewCellEditingStyleDelete) {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Message"
                                                                             message:@"Are you sure want to delete"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    //We add buttons to the alert controller by creating UIAlertActions:
    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action){
                                                         NSString *selectedBankAccountId = [[accountArray objectAtIndex:indexPath.row] valueForKey:@"USRMW_ID"];
                                                         [self deleteBankAccount:selectedBankAccountId withIndex:indexPath];
                                                     }] ;
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:actionOk];
    [alertController addAction:actionCancel];
    [self presentViewController:alertController animated:YES completion:nil];
    }
}*/

- (void)deleteBankAccount:(NSString *)bankAccount withIndex:(NSIndexPath *)indexPath
{
    [ACTIVITY showActivity:@"Loading..."];
    [BANKACCHELPER deleteBankAccountWithId:bankAccount completion:^(id obj) {
        [ACTIVITY performSelectorOnMainThread:@selector(hideActivity) withObject:nil waitUntilDone:YES];
        if ([obj isKindOfClass:[NSDictionary class]]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [accountArray removeObjectAtIndex:indexPath.row];
                [self.accountTableView reloadData];
            });
        }else{
            ErrorMessageWithTitle(@"Message", obj);
        }
    }];

}

#pragma mark Swipe Delegate

-(BOOL) swipeTableCell:(SwipeTableCell*) cell canSwipe:(SwipeDirection) direction;
{
    //To assign index from the swiped table view indexpath
    NSIndexPath *indexPath = [self.accountTableView indexPathForCell:cell];
    if (indexPath.row == accountArray.count) {
        return NO;
    }
    return YES;
}

-(NSArray*) swipeTableCell:(SwipeTableCell*) cell swipeButtonsForDirection:(SwipeDirection)direction
             swipeSettings:(SwipeSettings*) swipeSettings expansionSettings:(SwipeExpansionSettings*) expansionSettings
{
    swipeSettings.transition = SwipeTransitionBorder;
    UITableView *tableView = (UITableView *)cell.superview.superview;
    
    //Check for direction
    if (direction == SwipeDirectionRightToLeft)
    {
        expansionSettings.fillOnTrigger = NO;
        //For delete action
        
        SwipeButton *deleteButton =[SwipeButton buttonWithTitle:@"Delete" backgroundColor:[UIColor redColor] callback:^BOOL(SwipeTableCell *sender) {
            NSIndexPath * indexPath = [tableView indexPathForCell:sender];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Message"
                                                                                     message:@"Are you sure want to delete"
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            //We add buttons to the alert controller by creating UIAlertActions:
            UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * _Nonnull action){
                                                                 NSString *selectedBankAccountId = [[accountArray objectAtIndex:indexPath.row] valueForKey:@"USRMW_ID"];
                                                                 [self deleteBankAccount:selectedBankAccountId withIndex:indexPath];
                                                                 if ([selectedBankAccountId intValue] == [bankAccountId intValue]) {
                                                                     previousIndexpath = nil;
                                                                     bankAccountId = nil;

                                                                 }
                                                             }] ;
            UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alertController addAction:actionOk];
            [alertController addAction:actionCancel];
            [self presentViewController:alertController animated:YES completion:nil];
            return YES;
        }];
        return @[deleteButton];
    }
    
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

#pragma mark tableview delegate methods
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if((indexPath.row) == accountArray.count)
    {
        AddBankAccountController *addBankAccount = [self.storyboard instantiateViewControllerWithIdentifier:@"AddBankAccount"];
        [self.navigationController pushViewController:addBankAccount animated:YES];
        addBankAccount.onCreate = ^(id obj)
        {
//            [accountArray addObject:obj];
            [accountArray addObject:[obj objectForKey:@"userCreditDetails"]]; // Ask murugan to change the process
            [tableView reloadData];
        };
    }
    else{
        
        if ( previousIndexpath != indexPath ) {
            [self updateButtonStatusWithIndexPath:indexPath];
            if (previousIndexpath!=nil) {
                [self updateButtonStatusWithIndexPath:previousIndexpath];
            }
            previousIndexpath = indexPath;
            [tableView reloadData];
            bankAccountId = [NSString stringWithFormat:@"%@",[[accountArray objectAtIndex:indexPath.row] valueForKey:@"USRMW_ID"]];
        }
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
    if (!bankAccountId ||!bankAccountId.length) {
        ErrorMessageWithTitle(@"Message", @"Please select bank account");
        return;
    }
    if (self.acceptance.selected) {
        self.transprantView.hidden = NO;
        self.passwordView.hidden = NO;
    }
    else{
        ErrorMessageWithTitle(@"Message", @"Please accept terms and conditions");
    }
}

- (IBAction)onPasswordOkAction:(id)sender
{
    if (!self.passwordTextField.text.length) {
        ErrorMessageWithTitle(@"Message", @"Please enter password");
    }else{
        [ACTIVITY showActivity:@"Validating password..."];
        [self performSelector:@selector(validatePassword) withObject:nil afterDelay:0.2];
    }
}

- (void)validatePassword
{
    [PROFILEMACRO passWordValidation:self.passwordTextField.text completion:^(id obj) {
        [ACTIVITY performSelectorOnMainThread:@selector(hideActivity) withObject:nil waitUntilDone:YES];
        if ([obj isKindOfClass:[NSDictionary class]]) {
            [ACTIVITY showActivity:@"Processing loan..."];
            self.passwordView.hidden = YES;
            
            //*_latitude , *_longitude to be added below in the loan request API
            
            [LOANMACRO requestLoanForUserId:[[NSUserDefaults standardUserDefaults] valueForKey:USERID] amount:self.loanAmount mobileWallerId:bankAccountId completion:^(id obj) {
                [ACTIVITY performSelectorOnMainThread:@selector(hideActivity) withObject:nil waitUntilDone:YES];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([obj isKindOfClass:[NSDictionary class]]) {
                        self.transprantView.hidden = NO;
                        self.thanksView.hidden = NO;
                    }
                    else{
                        ErrorMessageWithTitle(@"Message", obj);
                        self.transprantView.hidden = YES;
                    }
                });
            }];
        }else{
            ErrorMessageWithTitle(@"Message", obj);
        }
    }];
}

- (IBAction)onPasswordCloseAction:(id)sender
{
    self.transprantView.hidden = YES;
    self.passwordView.hidden = YES;
}

- (IBAction)closeButtonAction:(id)sender {
    self.transprantView.hidden = YES;
    self.thanksView.hidden = YES;
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLoanProcessed"];
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

#pragma mark alertview delete

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


-(void)CurrentLocationIdentifier
{
    //---- For getting current gps location
    if ([CLLocationManager locationServicesEnabled])
    {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.distanceFilter = kCLDistanceFilterNone;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 &&
            [CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedWhenInUse
            //[CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedAlways
            ) {
            // Will open an confirm dialog to get user's approval
            [locationManager requestWhenInUseAuthorization];
            //[_locationManager requestAlwaysAuthorization];
        }
        
        [locationManager startUpdatingLocation];
    }
    else{
        NSLog(@"err");
    }
    //------
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //    [errorAlert show];
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
        case kCLAuthorizationStatusRestricted:
        case kCLAuthorizationStatusDenied:
        {
            // do some error handling
        }
            break;
        default:{
            [locationManager startUpdatingLocation];
        }
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    CLLocation *location;
    location =  [manager location];
    CLLocationCoordinate2D coordinate = [location coordinate];
    CLLocation *currentLocation = [[CLLocation alloc] init];
    currentLocation = newLocation;
    _longitude = [NSString stringWithFormat:@"%f",coordinate.longitude];
    _latitude = [NSString stringWithFormat:@"%f",coordinate.latitude];
    NSLog(@"value Lat : %@ Long :%@",_latitude,_longitude);
    [locationManager stopUpdatingHeading];
    locationManager = nil;
    return;
    //    globalObjects.longitude = [NSString stringWithFormat:@"%f",coordinate.longitude];
    //    globalObjects.latitude = [NSString stringWithFormat:@"%f",coordinate.latitude];
}

@end
