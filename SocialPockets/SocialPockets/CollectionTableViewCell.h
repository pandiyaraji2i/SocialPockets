//
//  CollectionTableViewCell.h
//  manage_accounts
//
//  Created by Ideas2IT -Ragav on 01/08/16.
//  Copyright © 2016 rlabr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionTableViewCell : UITableViewCell<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, weak)UIViewController *baseVc;
@property (nonatomic , strong) NSMutableArray *imageArray;
@property (nonatomic) NSIndexPath *currentTableIndex;

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;

-(void)setInitialCollectionView;

@end
