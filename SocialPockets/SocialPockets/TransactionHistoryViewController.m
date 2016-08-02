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
    self.table.layer.cornerRadius = 5;
    self.table.backgroundColor = [UIColor clearColor];
    isShowingListsec = NO; 
    
    transData = [[NSMutableArray alloc] initWithObjects:@"Transation: Rs 3000\n\nTransation details\nIn hand amount\nCredited on\nCredited to acc",@"Transation: Rs 5000\n\nTransation details\nIn hand amount\nCredited on\nCredited to acc",@"Transation: Rs 4000\n\nTransation details\nIn hand amount\nCredited on\nCredited to acc",@"Transation: Rs 3000\n\nTransation details\nIn hand amount\nCredited on\nCredited to acc", nil];
    self.table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.table.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
    //self.table.bounces = NO;
    
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
            return 200;
        }
        
    }
    return 60.0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
 
        [[cell textLabel]setNumberOfLines:0];
        [[cell textLabel] setText:[transData objectAtIndex:indexPath.section]];
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