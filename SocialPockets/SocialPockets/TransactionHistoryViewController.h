//
//  TransactionHistoryViewController.h
//  SocialPockets
//
//  Created by Ideas2IT-GaneshM on 29/07/16.
//  Copyright © 2016 Pandiyaraj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransactionHistoryViewController : UIViewController{
    UITableView *table;
    NSInteger selectedValueSection;
    bool isShowingListsec;
    NSMutableArray *transData;
}

@property (retain, nonatomic) IBOutlet UITableView *table;
@property (nonatomic) NSInteger selectedValueSection;
@property (nonatomic) bool isShowingListsec;
@property (retain, nonatomic) NSMutableArray *transData;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;



@end
