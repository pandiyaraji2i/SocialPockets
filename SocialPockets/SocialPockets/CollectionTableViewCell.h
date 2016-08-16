//
//  CollectionTableViewCell.h
//  manage_accounts
//
//  Created by Ideas2IT -Ragav on 01/08/16.
//  Copyright © 2016 rlabr. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CollectionViewDataDelegate <NSObject>

- (void)selectedCellTableIndexPath:(NSIndexPath *)tableIndexPath collectionIndexPath:(NSIndexPath *)collectionIndexPath;

@end

@interface CollectionTableViewCell : UITableViewCell<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic , strong) NSMutableArray *imageArray;
@property (nonatomic) NSIndexPath *currentTableIndex;

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, assign) id<CollectionViewDataDelegate> delegate;


-(void)setInitialCollectionView;

@end
