//
//  NotificationViewController.m
//  SocialPockets
//
//  Created by Pandiyaraj on 27/07/16.
//  Copyright © 2016 Pandiyaraj. All rights reserved.
//

#import "NotificationViewController.h"

@interface NotificationViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Notifications";
    notificationsTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    notificationsTableView.backgroundColor = [UIColor clearColor];
    // Do any additional setup after loading the view.
    if (IPHONE6PLUS_STANDARD){
        self.backgroundImage.image = [UIImage imageNamed:@"NotificationBG6Splus.png"];
        
    }else if (IPHONE5){
        self.backgroundImage.image = [UIImage imageNamed:@"NotificationBG.png"];
        
    }else if(IPHONE6_STANDARD){
        self.backgroundImage.image = [UIImage imageNamed:@"NotificationBG6S.png"];
        
    }else{
        self.backgroundImage.image = [UIImage imageNamed:@"NotificationBG4S.png"];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


#pragma mark tableview data source and delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"NotificationCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    UILabel *titleLabel = (id)[cell.contentView viewWithTag:1];
    titleLabel.text = @"You have earned 500 points";
    titleLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:15];
    
    UILabel *descriptionLabel  = (id)[cell.contentView viewWithTag:2];
    descriptionLabel.text = @"Repayed loan amount 13 days earlier to the tenure period.";
    descriptionLabel.font = [UIFont fontWithName:@"Roboto-Light" size:12];
    
    UILabel *timeLabel = (id)[cell.contentView viewWithTag:3];
    timeLabel.text = @"5 mins ago";
    timeLabel.font = [UIFont fontWithName:@"Roboto-Light" size:12];
    
    cell.backgroundColor = [UIColor clearColor];
    return cell;
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
