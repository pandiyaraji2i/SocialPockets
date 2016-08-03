//
//  CollectionTableViewCell.m
//  manage_accounts
//
//  Created by Ideas2IT -Ragav on 01/08/16.
//  Copyright © 2016 rlabr. All rights reserved.
//

#import "CollectionTableViewCell.h"
#import "TableCollectionViewCell.h"

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
    NSLog(@"currentdict  %@",[imageArray objectAtIndex:currentTableIndex.section]);
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
    cell.InfoLabel.text = [[currentRowDetail objectAtIndex:indexPath.row] objectForKey:@"ImageText"];
    
    return cell;
    
}



@end
