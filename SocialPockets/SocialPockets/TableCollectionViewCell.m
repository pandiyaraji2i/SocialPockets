//
//  TableCollectionViewCell.m
//  manage_accounts
//
//  Created by Ideas2IT -Ragav on 01/08/16.
//  Copyright © 2016 rlabr. All rights reserved.
//

#import "TableCollectionViewCell.h"

@implementation TableCollectionViewCell
@synthesize InfoLabel, ImageView, selectionImageView;



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    ImageView.layer.cornerRadius = 5;
    ImageView.layer.masksToBounds = YES;
}

@end


