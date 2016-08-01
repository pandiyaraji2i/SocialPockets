//
//  ManageAccountsViewController.m
//  SocialPockets
//
//  Created by ideas2it-Kovendhan on 01/08/16.
//  Copyright © 2016 Pandiyaraj. All rights reserved.
//

#import "ManageAccountsViewController.h"
#import "CollectionTableViewCell.h"

@interface ManageAccountsViewController ()<UITableViewDataSource, UITableViewDelegate>


@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation ManageAccountsViewController{
NSMutableArray *infoArray;
NSArray *HeaderArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.title = @"Manage Accounts";
    infoArray = [self generateImageArray];
    HeaderArray = @[@"Identification Proof", @"Social Account", @"Money Account"];
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CollectionTableViewCell" bundle:nil] forCellReuseIdentifier:@"CollectionTableViewCell"];
}





#pragma mark - UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CollectionTableViewCell *cell = (CollectionTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CollectionTableViewCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[CollectionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CollectionTableViewCell"];
    }
    cell.imageArray = infoArray;
    [cell setInitialCollectionView];
    return cell;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 11, 145, 21)];
    titleLabel.text = [HeaderArray objectAtIndex:section];
    
    
    UILabel *linesLabel = [[UILabel alloc] initWithFrame:CGRectMake(tableView.frame.size.width-120, 11, 100, 21)];
    linesLabel.text = section == 1 ? @"1/4 Linked" : @"";
    linesLabel.textAlignment = NSTextAlignmentRight;
    linesLabel.textColor = [UIColor darkGrayColor];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)];
    [view addSubview:titleLabel];
    [view addSubview:linesLabel];
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}


#pragma generateImages ::: delete this after the original image


-(NSMutableArray *)generateImageArray {
    
    NSMutableArray *imagesArray = [[NSMutableArray alloc] init];
    for (int i=1; i<=10; i++) {
        NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
        NSString *infoString = [NSString stringWithFormat:@"image%d", i];
        UIImage *image = [UIImage imageNamed:infoString];
        
        [tempDict setValue:infoString forKey:@"Info"];
        [tempDict setValue:image forKey:@"Image"];
        
        [imagesArray addObject:tempDict];
    }
    
    return imagesArray;
}


-(void) formattedDictionary {
    
    
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

@end
