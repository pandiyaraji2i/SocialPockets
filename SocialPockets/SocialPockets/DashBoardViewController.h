//
//  DashBoardViewController.h
//  SocialPockets
//
//  Created by Pandiyaraj on 25/07/16.
//  Copyright © 2016 Pandiyaraj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DashBoardViewController : UIViewController
{
    IBOutlet NSLayoutConstraint *scoreLabelTopConstraint;
    IBOutlet NSLayoutConstraint *scoreBGHeightConstraint;
    IBOutlet NSLayoutConstraint *pointsButtonTopConstraint;
}
@property (nonatomic, weak) IBOutlet UIButton *pointsButton;
@end
