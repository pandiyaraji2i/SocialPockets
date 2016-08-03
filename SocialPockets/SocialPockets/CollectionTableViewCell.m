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
@synthesize imageArray;

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


-(void)setInitialCollectionView {
    [self.collectionView registerNib:[UINib nibWithNibName:@"TableCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"TableCollectionViewCell"];
    [self.collectionView reloadData];
}

#pragma mark <UICollectionViewDataSource>

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [imageArray count];
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TableCollectionViewCell *cell = (TableCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"TableCollectionViewCell" forIndexPath:indexPath];
    
    cell.ImageView.image = [[imageArray objectAtIndex:indexPath.row] objectForKey:@"Image"];
    cell.InfoLabel.text = [[imageArray objectAtIndex:indexPath.row] objectForKey:@"Info"];
    
    return cell;
    
}



@end
