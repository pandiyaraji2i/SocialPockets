//
//  TableCollectionViewCell.h
//  manage_accounts
//
//  Created by Ideas2IT -Ragav on 01/08/16.
//  Copyright © 2016 rlabr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableCollectionViewCell : UICollectionViewCell


@property (weak, nonatomic) IBOutlet UIImageView *ImageView;
@property (weak, nonatomic) IBOutlet UILabel *InfoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectionImageView;

@end
