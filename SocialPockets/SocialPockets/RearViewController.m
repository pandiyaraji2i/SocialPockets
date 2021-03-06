//
//  RearViewController.m
//  SocialPockets
//
//  Created by Pandiyaraj on 25/07/16.
//  Copyright © 2016 Pandiyaraj. All rights reserved.
//

#import "RearViewController.h"

@interface RearViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *listArray;
}
@end

@implementation RearViewController
@synthesize menu;

- (void)viewDidLoad {
    [super viewDidLoad];
    listArray = @[@"Dashboard",@"Points Feed",@"Transaction History",@"Manage Accounts",@"Terms & Conditions",@"FAQ",@"About SocialPocket"];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.frame.size.width, 10.0f)];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark uitableview datasource and delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"CellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = [listArray objectAtIndex:indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.menu) {
        self.menu([listArray objectAtIndex:indexPath.row]);
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 120;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 10, tableView.frame.size.width,100)];
    
    sectionView.backgroundColor=[UIColor colorWithRed:38.0/255.0 green:38.0/255.0 blue:38.0/255.0 alpha:1.0];
    UIImageView *tempImage =[[UIImageView alloc]initWithFrame:CGRectMake(17.5, 15, 44,44)];
    [tempImage.layer setCornerRadius:tempImage.frame.size.width/2.0f];
    [tempImage.layer setMasksToBounds:YES];
    tempImage.image = [UIImage imageNamed:@"Social.jpg"];
    tempImage.layer.borderColor = [UIColor whiteColor].CGColor;
    tempImage.layer.borderWidth = 1.0;
    tempImage.layer.shadowColor = [UIColor redColor].CGColor;
    [sectionView addSubview:tempImage];
    
    UILabel *tempLabel =[[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(tempImage.frame), sectionView.frame.size.width-tempImage.frame.size.width-20, 30)];
    tempLabel.text=@"Pandiya Raj";
    tempLabel.textColor=[UIColor whiteColor];
    tempLabel.font=[UIFont fontWithName:@"Helvetica Neue" size:16];
    
    UILabel *emailIdLabel =[[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(tempLabel.frame)-10, sectionView.frame.size.width-tempImage.frame.size.width, 30)];
    emailIdLabel.text=@"Pandiyaraj@ideas2it.com";
    [emailIdLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:10]];
    emailIdLabel.textColor=[UIColor whiteColor];
    [sectionView addSubview:emailIdLabel];
    [sectionView addSubview:tempLabel];
    
    UIButton *logoutButton =[UIButton buttonWithType:UIButtonTypeCustom];
    logoutButton.frame = CGRectMake(sectionView.frame.size.width-60, sectionView.frame.size.height-40,60, 40);
    [logoutButton setTitle:@"Log out" forState:UIControlStateNormal];
    [logoutButton addTarget:self action:@selector(logOut) forControlEvents:UIControlEventTouchUpInside];
    [sectionView addSubview:logoutButton];
    return sectionView;
}

- (void)logOut
{
    if (menu) {
        menu(@"Logout");
    }
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
