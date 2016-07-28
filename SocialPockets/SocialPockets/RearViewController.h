//
//  RearViewController.h
//  SocialPockets
//
//  Created by Pandiyaraj on 25/07/16.
//  Copyright © 2016 Pandiyaraj. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^MenuSelection)(NSString*);
@interface RearViewController : UITableViewController
@property (nonatomic,copy) MenuSelection menu;
@end
