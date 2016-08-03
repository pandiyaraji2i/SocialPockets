//
//  TransactionHistoryViewController.m
//  SocialPockets
//
//  Created by Ideas2IT-GaneshM on 29/07/16.
//  Copyright © 2016 Pandiyaraj. All rights reserved.
//

#import "TransactionHistoryViewController.h"

@interface TransactionHistoryViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSIndexPath *currentIndex;
   }
@end

@implementation TransactionHistoryViewController
@synthesize isShowingListsec,selectedValueSection,table,transData;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    self.title = @"Transaction Histroy";
    self.table.backgroundColor = [UIColor yellowColor];
    self.table.layer.cornerRadius = 5;
    self.table.backgroundColor = [UIColor clearColor];
    isShowingListsec = NO;
    
    transData = [[NSMutableArray alloc]init];
    [LOANMACRO getAllLoansWithCompletionBlock:^(id obj) {
        [transData addObjectsFromArray:[obj objectForKey:@"loan"]];
        //view update has to happen in main queue
        dispatch_async(dispatch_get_main_queue(), ^{
             [table reloadData];
        });
    }];

    
   // transData = [[NSMutableArray alloc] initWithObjects:@"Transation: Rs 3000\n\nTransation details\nIn hand amount\nCredited on\nCredited to acc",@"Transation: Rs 5000\n\nTransation details\nIn hand amount\nCredited on\nCredited to acc",@"Transation: Rs 4000\n\nTransation details\nIn hand amount\nCredited on\nCredited to acc",@"Transation: Rs 3000\n\nTransation details\nIn hand amount\nCredited on\nCredited to acc", nil];
    self.table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.table.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
    
    
    }
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
   

}
//increses the section according to data received
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [transData count];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    {
        //increses the row size when clicked
        if(isShowingListsec && selectedValueSection == indexPath.section){
            return 220;
        }
        
    }
    return 60.0;
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;

 
    [[cell textLabel]setNumberOfLines:0];
       // [[cell textLabel] setText:[[transData objectAtIndex:indexPath.section] objectForKey:@"USRLN_AMOUNT"]];
    
    UILabel *loanAmount = (UILabel *)[cell viewWithTag:1];
    UILabel *loanStatus = (UILabel *)[cell viewWithTag:2];
    UILabel *amountInHand = (UILabel *)[cell viewWithTag:3];
    UILabel *creditDate = (UILabel *)[cell viewWithTag:4];
    UILabel *creditAccount = (UILabel *)[cell viewWithTag:5];
    UILabel *loanTenure = (UILabel *)[cell viewWithTag:6];
  
    [loanAmount setText:[NSString stringWithFormat:@"Rs. %@",[[transData objectAtIndex:indexPath.section] objectForKey:@"USRLN_AMOUNT"]]];
    //[loanStatus setText:[[transData objectAtIndex:indexPath.section] objectForKey:@"USRLN_STATUS"]];

    if ([[[transData objectAtIndex:indexPath.section] objectForKey:@"USRLN_STATUS"] intValue] <= 2 )
    {
        [loanStatus setText:[NSString stringWithFormat:@"Ongoing"]];
        
    }
    else if ([[[transData objectAtIndex:indexPath.section] objectForKey:@"USRLN_STATUS"] intValue] > 2 ){
        [loanStatus setText:[NSString stringWithFormat:@"Repaid"]];
    }
    else{
        [loanStatus setText:[NSString stringWithFormat:@"-----"]];
    }
    [amountInHand setText:[[transData objectAtIndex:indexPath.section] objectForKey:@"USRLN_ACTION_AMOUNT"]];
    
    NSString *cdateStr = [[transData objectAtIndex:indexPath.section] objectForKey:@"USRLN_CREATED_DATE"];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSDate *dateStr = [dateFormat dateFromString:cdateStr];
    [dateFormat setDateFormat:@"dd-MM-yyyy"];
    NSString *cdate = [dateFormat stringFromDate:dateStr];
    [creditDate setText:cdate];
    //[creditDate setText:[[transData objectAtIndex:indexPath.section] objectForKey:@"USRLN_CREATED_DATE"]];
    [creditAccount setText:[[transData objectAtIndex:indexPath.section] objectForKey:@"USRLN_MOBWM_ID"]];
    
    cdateStr = [[transData objectAtIndex:indexPath.section] objectForKey:@"USRLN_TENNURE_DATE"];
    [dateFormat setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    dateStr = [dateFormat dateFromString:cdateStr];
    [dateFormat setDateFormat:@"dd-MM-yyyy"];
    cdate = [dateFormat stringFromDate:dateStr];
    [loanTenure setText:cdate];
    //[loanTenure setText:[[transData objectAtIndex:indexPath.section] objectForKey:@"USRLN_TENNURE_DATE"]];
    [cell.textLabel sizeToFit];
    cell.layer.cornerRadius = 10;
    return cell;
 
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
        isShowingListsec = !isShowingListsec;//makes value true or false
    selectedValueSection = indexPath.section;
    [table reloadSections:[NSIndexSet indexSetWithIndex:(indexPath.item)] withRowAnimation:UITableViewRowAnimationFade];
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