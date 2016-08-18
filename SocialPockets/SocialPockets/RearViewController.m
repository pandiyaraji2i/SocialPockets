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
    NSIndexPath *previousIndexPath;
    BOOL highlightAccountText;
}
@end

@implementation RearViewController
@synthesize menu;

- (void)viewDidLoad {
    [super viewDidLoad];
    listArray = @[@"Dashboard",@"My Account",@"Transaction History",@"Manage Accounts",@"Terms & Conditions",@"FAQ",@"About Social Pocket"];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.frame.size.width, 10.0f)];
//    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    // Do any additional setup after loading the view.
//
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAccount) name:@"ReloadAccountScreen" object:nil];
}

- (void)reloadAccount
{
    highlightAccountText = YES;

    [self.tableView reloadData];
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
    cell.textLabel.textColor = [UIColor grayColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont fontWithName:@"Roboto" size:14];
    if (highlightAccountText && indexPath.row == 1) {
        cell.textLabel.textColor = [UIColor colorWithRed:32.0/255.0 green:132.0/255.0 blue:37.0/255.0 alpha:1.0];
        cell.textLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:14];
        highlightAccountText = NO;
    }


    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (previousIndexPath && previousIndexPath != indexPath) {
        UITableViewCell *previousCell = [tableView cellForRowAtIndexPath:previousIndexPath];
        previousCell.textLabel.textColor = [UIColor grayColor];
        previousCell.textLabel.font = [UIFont fontWithName:@"Roboto" size:14];
    }
    
    UITableViewCell *Cell = [tableView cellForRowAtIndexPath:indexPath];
    Cell.textLabel.textColor = [UIColor colorWithRed:32.0/255.0 green:132.0/255.0 blue:37.0/255.0 alpha:1.0];
    Cell.textLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:14];

    previousIndexPath = indexPath;

    
    if (self.menu) {
        self.menu([listArray objectAtIndex:indexPath.row]);
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 140;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 10, tableView.frame.size.width,120)];
    
    sectionView.backgroundColor=[UIColor whiteColor];
    UIImageView *tempImage =[[UIImageView alloc]initWithFrame:CGRectMake(17.5, 10, 69,69)];
    [tempImage.layer setCornerRadius:tempImage.frame.size.width/2.0f];
    [tempImage.layer setMasksToBounds:YES];
    tempImage.image = [DBPROFILE getImageForUser];
    tempImage.layer.borderColor = [UIColor lightGrayColor].CGColor;
    tempImage.layer.borderWidth = 1.0;
    tempImage.layer.shadowColor = [UIColor redColor].CGColor;
    [sectionView addSubview:tempImage];
    
    UILabel *nameLabel =[[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(tempImage.frame), sectionView.frame.size.width-tempImage.frame.size.width-20, 30)];
    nameLabel.text=USERINFO.name;// [[NSUserDefaults standardUserDefaults] valueForKey:USERNAME];
    nameLabel.textColor=[UIColor blackColor];
    nameLabel.font=[UIFont fontWithName:@"Roboto-Light" size:15];
    
    UILabel *emailIdLabel =[[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(nameLabel.frame)-10, sectionView.frame.size.width-tempImage.frame.size.width, 30)];
    emailIdLabel.text=USERINFO.user_email;// [[NSUserDefaults standardUserDefaults] valueForKey:USEREMAIL];
    emailIdLabel.font=[UIFont fontWithName:@"Roboto-Medium" size:11];
    emailIdLabel.textColor=[UIColor grayColor];
    [sectionView addSubview:emailIdLabel];
    [sectionView addSubview:nameLabel];
    
    UIButton *logoutButton =[UIButton buttonWithType:UIButtonTypeCustom];
    logoutButton.frame = CGRectMake(sectionView.frame.size.width-60, 30,30, 30);
    [logoutButton setImage:[UIImage imageNamed:@"LogoutIcon"] forState:UIControlStateNormal];
    [logoutButton addTarget:self action:@selector(logOut) forControlEvents:UIControlEventTouchUpInside];
    [sectionView addSubview:logoutButton];


    
    CALayer *border = [CALayer layer];
    border.backgroundColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0].CGColor;
    
    border.frame = CGRectMake(0, 138, sectionView.frame.size.width, 1);
    [sectionView.layer addSublayer:border];
    

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
