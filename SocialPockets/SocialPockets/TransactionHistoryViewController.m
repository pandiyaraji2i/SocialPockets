//
//  TransactionHistoryViewController.m
//  SocialPockets
//
//  Created by Ideas2IT-GaneshM on 29/07/16.
//  Copyright © 2016 Pandiyaraj. All rights reserved.
//

#import "TransactionHistoryViewController.h"

@interface TransactionHistoryViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSIndexPath *currentIndex,*previousIndexpath;
}
@end

@implementation TransactionHistoryViewController
@synthesize isShowingListsec,selectedValueSection,table,transData;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    self.title = @"Transaction History";
   
    isShowingListsec = NO;
    isLoadMoreShow = NO;
    self.table.backgroundColor = [UIColor yellowColor];
    self.table.layer.cornerRadius = 5;
    self.table.backgroundColor = [UIColor clearColor];
    
    transData = [[NSMutableArray alloc]init];
    [self getTransactionHistory:YES];
    
    //    [LOANMACRO getAllLoansWithCompletionBlock:^(id obj) {
    ////        [transData addObjectsFromArray:[obj objectForKey:@"loan"]];
    //        [transData addObjectsFromArray:obj];
    //        //view update has to happen in main queue
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //             [table reloadData];
    //        });
    //    }];
    if (IPHONE6PLUS_STANDARD){
        self.backgroundImage.image = [UIImage imageNamed:@"NotificationBG6Splus.png"];
        
    }else if (IPHONE5){
        self.backgroundImage.image = [UIImage imageNamed:@"NotificationBG.png"];
        
    }else if(IPHONE6_STANDARD){
        self.backgroundImage.image = [UIImage imageNamed:@"NotificationBG6S.png"];
        
    }else{
        self.backgroundImage.image = [UIImage imageNamed:@"NotificationBG4S.png"];
        
    }
    
    
    // transData = [[NSMutableArray alloc] initWithObjects:@"Transation: Rs 3000\n\nTransation details\nIn hand amount\nCredited on\nCredited to acc",@"Transation: Rs 5000\n\nTransation details\nIn hand amount\nCredited on\nCredited to acc",@"Transation: Rs 4000\n\nTransation details\nIn hand amount\nCredited on\nCredited to acc",@"Transation: Rs 3000\n\nTransation details\nIn hand amount\nCredited on\nCredited to acc", nil];
    self.table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.table.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
}

- (void)getTransactionHistory:(BOOL)isAfter
{
    NSDictionary *postDict ;
    NSArray *array = [TRANSACTHISTORY getAllTransactionHistory];
    if (array.count) {
        //# --- Sort is NO == Top ids come
        //# --- Sort is YES == Below ids come
        NSArray *array1 = [DatabaseObject dbQuery:@"TransactionHistory" withWhere:nil andSortKey:@"loanId" andSortAscending:!isAfter];
        NSString *loanId;
        if (array1.count) {
            TransactionHistory *transHistory = [array1 firstObject];
            loanId = transHistory.loanId;
        }
        if (isAfter) {
            //#-- Maximum loan id
            postDict = @{@"user_id":[[NSUserDefaults standardUserDefaults] valueForKey:USERID], @"after":loanId};
        }else{
            //#-- Minimum loan id
            postDict = @{@"user_id":[[NSUserDefaults standardUserDefaults] valueForKey:USERID], @"before":loanId};
        }
    }else{
        postDict = @{@"user_id":[[NSUserDefaults standardUserDefaults] valueForKey:USERID]};
    }
    
    if ([NetworkHelperClass getInternetStatus:NO])
    {
        [TRANSACTHISTORY downloadTransactionHistory:postDict completion:^(int value) {
          
            if (!isAfter) {
                if (value == 1) {
                    isLoadMoreShow = NO;
                }else{
                    isLoadMoreShow = YES;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [table reloadData];
                    });
                }
            }
           
        }];
    }
}
#pragma mark tableview delegate methods

- (NSUInteger)totalCount
{
    NSUInteger value = ([[[self transactionHistoryResultsController] fetchedObjects] count])?[[[self transactionHistoryResultsController] sections] count]:0;
    return value;
}

//increses the section according to data received
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //    return [transData count];
    NSUInteger total =[self totalCount];
    NSLog(@"toatl %ld",total);
    if (total>=5 && !isLoadMoreShow) {
        return total+1;
    }
    return total;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    [headerView setBackgroundColor:[UIColor clearColor]];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //increses the row size when clicked
    if (indexPath.section != [self totalCount]) {
        TransactionHistory *transctionHistory= [self.transactionHistoryResultsController  objectAtIndexPath:indexPath];
        if(isShowingListsec && selectedValueSection == indexPath.section){
            id loanObject = transctionHistory.loanObject;
            if([[loanObject objectForKey:@"USRLN_STATUS"] intValue] > 2 ){
                return 265;
            }
            else{
                return 195;
            }
        }
    }
    NSLog(@"last row == %ld",indexPath.section);
    if (indexPath.section != [self totalCount]) {
    return 60;
    }else{
        return 44;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSString *CellIdentifier;
    if (indexPath.section != [self totalCount]) {
        CellIdentifier = @"Cell";
    }else{
        CellIdentifier = nil;
    }
    
    UITableViewCell *cell = (CellIdentifier!=nil)?[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath]:[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.section != [self totalCount]) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        [[cell textLabel]setNumberOfLines:0];
        UILabel *loanAmount = (UILabel *)[cell viewWithTag:1];
        UILabel *loanStatus = (UILabel *)[cell viewWithTag:2];
        UILabel *amountInHand = (UILabel *)[cell viewWithTag:3];
        UILabel *creditDate = (UILabel *)[cell viewWithTag:4];
        UILabel *creditAccount = (UILabel *)[cell viewWithTag:5];
        UILabel *loanTenure = (UILabel *)[cell viewWithTag:6];
        UILabel *repayAmountLbl = (UILabel *)[cell viewWithTag:7];
        UILabel *repaidDateLbl = (UILabel *)[cell viewWithTag:8];
        UILabel *receiptIdLbl = (UILabel *)[cell viewWithTag:9];
        TransactionHistory *transactionHistory= [self.transactionHistoryResultsController  objectAtIndexPath:indexPath];
        
        //    TransactionHistory *transactionHistory = [transData objectAtIndex:indexPath.section];
        id loanObject = transactionHistory.loanObject;
        [loanAmount setText:[NSString stringWithFormat:@"Rs. %@",[loanObject objectForKey:@"USRLN_AMOUNT"]]];
        
        if ([[loanObject objectForKey:@"USRLN_STATUS"] intValue] > 0  && [[loanObject objectForKey:@"USRLN_STATUS"] intValue] <= 2)
        {
            [loanStatus setText:[NSString stringWithFormat:@"Ongoing"]];
            
        }
        else if ([[loanObject objectForKey:@"USRLN_STATUS"] intValue] > 2 ){
            [loanStatus setText:[NSString stringWithFormat:@"Repaid"]];
        }
        else if ([[loanObject objectForKey:@"USRLN_STATUS"] intValue] == 0 ){
            [loanStatus setText:[NSString stringWithFormat:@"Rejected"]];
        }
        else{
            [loanStatus setText:[NSString stringWithFormat:@"-----"]];
        }
        if ([[loanObject objectForKey:@"loanrepayment"] isKindOfClass:[NSDictionary class]]){
            
            [repayAmountLbl setText:[NSString stringWithFormat:@"%@",[[loanObject objectForKey:@"loanrepayment"] objectForKey:@"LOARE_AMOUNT"]]];
            repaidDateLbl.text =[SharedMethods convertString:[NSString stringWithFormat:@"%@",[[loanObject objectForKey:@"loanrepayment"] objectForKey:@"LOARE_CREATED_DATE"]] fromFormat:LOCALDATETIMEFORMAT toFormat:DATEFORMAT] ;
            [receiptIdLbl setText:[NSString stringWithFormat:@"%@",[loanObject objectForKey:@"USRLN_RECEIPT_NUMBER"]]];
        }
        else{
            
        }
        
        [amountInHand setText:[loanObject objectForKey:@"USRLN_ACTION_AMOUNT"]];
        
        creditDate.text=[SharedMethods convertString:[NSString stringWithFormat:@"%@",[loanObject objectForKey:@"USRLN_CREATED_DATE"]]fromFormat:LOCALDATETIMEFORMAT toFormat:DATEFORMAT];
        
        [creditAccount setText:[loanObject objectForKey:@"USRLN_MOBWM_ID"]];
        
        loanTenure.text = [SharedMethods convertString:[NSString stringWithFormat:@"%@",[loanObject objectForKey:@"USRLN_TENNURE_DATE"]]fromFormat:LOCALDATETIMEFORMAT toFormat:DATEFORMAT];
        
        
        [cell.textLabel sizeToFit];
    }
    else{
        cell.textLabel.text = @"Load more";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [UIColor colorWithRed:38.0/255.0 green:147.0/255.0 blue:255.0/255.0 alpha:1.0];
    }
    cell.layer.cornerRadius = 10;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section != [self totalCount]) {
        if (previousIndexpath!=indexPath) {
            isShowingListsec = YES;
        }else{
            isShowingListsec = !isShowingListsec;//makes value true or false
        }
        selectedValueSection = indexPath.section;
        previousIndexpath = indexPath;
        [table reloadData];
    }else{
        [self getTransactionHistory:NO];
    }
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

#pragma mark CoreData Classes
#pragma mark Fetch groups
- (NSFetchedResultsController *)transactionHistoryResultsController
{
    if (transactionHistoryResultsController == nil)
    {
        NSString *entityName;
        NSArray *sortDescriptors;
        entityName = @"TransactionHistory";
        NSSortDescriptor *sd1 = [NSSortDescriptor sortDescriptorWithKey:@"loanId" ascending:NO];
        sortDescriptors = [NSArray arrayWithObjects:sd1, nil];
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:entityName
                                                  inManagedObjectContext:DATABASE.managedObjectContext];
        
        
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setEntity:entity];
        [fetchRequest setFetchBatchSize:2];
        [fetchRequest setSortDescriptors:sortDescriptors];
        [fetchRequest setPredicate:nil];
        transactionHistoryResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                  managedObjectContext:DATABASE.managedObjectContext
                                                                                    sectionNameKeyPath:@"loanId"
                                                                                             cacheName:nil];
        [transactionHistoryResultsController setDelegate:self];
        
        NSError *error = nil;
        if (![transactionHistoryResultsController performFetch:&error])
        {
            //TFLOG(@"%@ Unresolved error %@, %@",LineNUMBER, error, [error userInfo]);
        }
    }
    return transactionHistoryResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [table beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
        {
            [table insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            //            if (![self totalCount]) {
            //                [table setEditing:NO];
            //                self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:infoBtn];
            //                self.navigationItem.leftBarButtonItem=nil;
            //                [table reloadData];
            //            }else{
            //                [table setEditing:NO];
            //                self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editDoneAction:)];
            //                self.navigationItem.leftBarButtonItem =nil;
            //            }
        }
            break;
        case NSFetchedResultsChangeDelete:
        {
            // First figure out how many sections there are
            [table deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
            break;
        case NSFetchedResultsChangeUpdate:
        {
            UITableViewCell *cell = [table cellForRowAtIndexPath:indexPath];
            [table reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation: UITableViewRowAnimationAutomatic];
            //            [self configureCell:cell atIndexPath:indexPath];
            [cell layoutSubviews];
        }
            break;
        case NSFetchedResultsChangeMove:
        {
            [table deleteRowsAtIndexPaths:[NSArray
                                           arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [table insertRowsAtIndexPaths:[NSArray
                                           arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
        {
            [table insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeDelete:
        {
            [table deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // The t controller has sent all current change notifications, so tell the table view to process all updates.
    [table endUpdates];
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