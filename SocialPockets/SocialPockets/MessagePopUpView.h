//
//  MessagePopUpView.h
//  High Plains Mobile
//
//  Created by Pandiyaraj on 19/01/16.
//  Copyright © 2016 High Plains Information Systems, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessagePopUpView : UIView
{
    UIActivityIndicatorView *activityView;
    UIView *loadingView;
    UILabel *loadingLabel;
}
@property (nonatomic, retain) UIActivityIndicatorView * activityView;
@property (nonatomic, retain) UIView *loadingView;
@property (nonatomic, retain) UILabel *loadingLabel;

-(void)HideActivityIndicator;
@end
