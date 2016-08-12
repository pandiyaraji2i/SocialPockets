//
//  CollectionTableViewCell.m
//  manage_accounts
//
//  Created by Ideas2IT -Ragav on 01/08/16.
//  Copyright © 2016 rlabr. All rights reserved.
//

#import "CollectionTableViewCell.h"
#import "TableCollectionViewCell.h"
#import "AddBankAccountController.h"

@implementation CollectionTableViewCell
{
    NSDictionary *currentSectionDictionary;
    NSArray *secTitle;
}
@synthesize imageArray,currentTableIndex;

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


-(void)setInitialCollectionView {
    [self.collectionView registerNib:[UINib nibWithNibName:@"TableCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"TableCollectionViewCell"];
    currentSectionDictionary = [[NSDictionary alloc] init];
    currentSectionDictionary = [imageArray objectAtIndex:currentTableIndex.section];
    [self.collectionView reloadData];
}

#pragma mark <UICollectionViewDataSource>

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    secTitle = [currentSectionDictionary allKeys];
    
    return [[currentSectionDictionary objectForKey:[secTitle objectAtIndex:0]] count];
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TableCollectionViewCell *cell = (TableCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"TableCollectionViewCell" forIndexPath:indexPath];
    NSArray *currentRowDetail = [currentSectionDictionary objectForKey:[secTitle objectAtIndex:0]];
    
    cell.ImageView.image = [UIImage imageNamed:[[currentRowDetail objectAtIndex:indexPath.row] objectForKey:@"ImageName"]];
    if (currentTableIndex.section == 2) {
      NSString *bankName = [[[[currentRowDetail objectAtIndex:indexPath.row] objectForKey:@"ImageText"] componentsSeparatedByString:@","] objectAtIndex:0];
        cell.InfoLabel.text = bankName;
    }else{
    cell.InfoLabel.text = [[currentRowDetail objectAtIndex:indexPath.row] objectForKey:@"ImageText"];
    }
    if ([[currentRowDetail objectAtIndex:indexPath.row] objectForKey:@"Account Number"]) {

        cell.accountNumber.text = [self secureBankAccount:[[currentRowDetail objectAtIndex:indexPath.row] objectForKey:@"Account Number"]];
    }
    
    return cell;
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (currentTableIndex.section == 2 && [[currentSectionDictionary objectForKey:@"Money Account"] count]<=3 && indexPath.row == [[currentSectionDictionary objectForKey:@"Money Account"] count]-1 && [[[currentSectionDictionary objectForKey:@"Money Account"] objectAtIndex:2] valueForKey:@"Account Number"] == nil) {
        NSLog(@"comein");
        UIStoryboard *sB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        AddBankAccountController *addBankAccount = [sB instantiateViewControllerWithIdentifier:@"AddBankAccount"];
         [self.baseVc.navigationController pushViewController:addBankAccount animated:YES];
 

    }
}

-(NSString *)secureBankAccount:(NSString *)accNo{
    return [accNo stringByReplacingCharactersInRange:NSMakeRange(4, [accNo length]-8) withString:@"****"];

}



@end
