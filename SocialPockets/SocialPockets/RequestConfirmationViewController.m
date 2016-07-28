//
//  RequestConfirmation.m
//  SocialPockets
//
//  Created by Ideas2IT-GaneshM on 27/07/16.
//  Copyright © 2016 Pandiyaraj. All rights reserved.
//

#import "RequestConfirmationViewController.h"

@interface RequestConfirmationViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray /*tableData,*tableNumber,*/*arr,*temp;
    NSMutableDictionary *accountDict;
    NSIndexPath *previousIndexpath;
}
@property (weak, nonatomic) IBOutlet UITableView *accountTableView;
- (IBAction)acceptBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *acceptance;

@end

@implementation RequestConfirmationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    //    tableData = [[NSMutableArray alloc] initWithObjects:@"HDFC bank",@"ICICI Bank",@"citi bank", nil];
    //    tableNumber = [[NSMutableArray alloc] initWithObjects:@"126547682354872" ,@"32875684756448756",@"126547682354872",nil];

arr = [@[@{@"BankName":@"HDFC",@"AccountNum":@"126547682354872"}
                            ,@{@"BankName":@"HDFC",@"AccountNum":@"126547682354872"}]mutableCopy];
 
    arr=[@[@{@"BankName" : @"HDFC",
                                   @"AccountNum" : @"123456789",
                                   @"Selected" : [NSNumber numberWithBool:NO]
                                   },
                                 @{@"BankName" : @"HDFC",
                                   @"AccountNum" : @"123456789",
                                   @"Selected" : [NSNumber numberWithBool:YES]
                                   },
                                 @{@"BankName" : @"HDFC",
                                   @"AccountNum" : @"123456789",
                                   @"Selected" : [NSNumber numberWithBool:NO]
                                   }
                                 ]mutableCopy];
    self.accountTableView.delegate = self;
    self.accountTableView.dataSource = self;
    self.accountTableView.layer.cornerRadius = 7;
    
    self.navigationController.navigationBarHidden = NO;
    self.title = @"Request Confirmation";
    previousIndexpath = nil;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arr.count >= MAX_ACCOUNT ? arr.count:[arr count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:
(NSIndexPath *)indexPath{
    
    NSString *CellId = @"accountCell";
    
    if (indexPath.row == arr.count) {
        CellId = nil;
    }
    UITableViewCell *cell =(CellId!=nil)?[tableView dequeueReusableCellWithIdentifier:CellId forIndexPath:indexPath]:[tableView dequeueReusableCellWithIdentifier:CellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellId];
    }
    if (indexPath.row == arr.count) {
        cell.textLabel.text = @"+ Add new account";
        cell.textLabel.textColor =[UIColor blueColor];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    else{
        UILabel *titlename = (UILabel *)[cell.contentView viewWithTag:999];
        
        titlename.text = [[arr objectAtIndex:indexPath.row] objectForKey:@"BankName"];
        UILabel *subtitlename = (UILabel *)[cell.contentView viewWithTag:888];
        
        subtitlename.text = [[arr objectAtIndex:indexPath.row] objectForKey:@"AccountNum"];
        
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        
        UIButton *check = (UIButton *)[cell.contentView viewWithTag:777];
        check.selected = [[[arr objectAtIndex:indexPath.row] valueForKey:@"Selected"] boolValue];
        
    }
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if((indexPath.row) == arr.count)
    {
        NSLog(@"Adding new account:");
       [arr insertObject:[@{@"BankName":@"Axis",@"AccountNum":@"126547682354872",@"Selected":[NSNumber numberWithBool:NO]}mutableCopy] atIndex:arr.count];
        [tableView reloadData];
    }
    else{
        NSMutableDictionary *currentSelectedObj = [[arr objectAtIndex:indexPath.row] mutableCopy];
        BOOL isSelectedValue = [[currentSelectedObj valueForKey:@"Selected"] boolValue];
        [currentSelectedObj setValue:[NSNumber numberWithBool:!isSelectedValue] forKey:@"Selected"];
        [arr replaceObjectAtIndex:indexPath.row withObject:currentSelectedObj];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        return;
        UITableViewCell *currentCell = [tableView cellForRowAtIndexPath:indexPath];
        
        if (previousIndexpath != indexPath) {
            UITableViewCell *prevCell = [tableView cellForRowAtIndexPath:previousIndexpath];
            UIButton *check = (UIButton *)[prevCell.contentView viewWithTag:777];
            [self changeAction:check];
            previousIndexpath = nil;
        }
        
        UIButton *check = (UIButton *)[currentCell.contentView viewWithTag:777];
        [self changeAction:check];
        previousIndexpath = indexPath;
    }
    
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == arr.count) {
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
    
    [arr removeObjectAtIndex:indexPath.row];
    
//        loc =[[NSArray alloc]initWithArray:[[[temp mutableCopy] removeObjectAtIndex:indexPath.row]]];
    [tableView reloadData];
}
- (void)changeAction:(id)sender
{
    UIButton *idSender = sender;
    idSender.selected = !idSender.selected;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)acceptBtn:(id)sender {
    _acceptance.selected = !_acceptance.selected;
}
@end
