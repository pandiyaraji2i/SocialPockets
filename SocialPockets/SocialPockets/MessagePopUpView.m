//
//  MessagePopUpView.m
//  High Plains Mobile
//
//  Created by Pandiyaraj on 19/01/16.
//  Copyright © 2016 High Plains Information Systems, Inc. All rights reserved.
//

#import "MessagePopUpView.h"

@implementation MessagePopUpView
@synthesize activityView,loadingLabel,loadingView;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        loadingView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, frame.size.width, frame.size.height)];
        loadingView.backgroundColor = [UIColor blackColor];
        loadingView.clipsToBounds = YES;
        loadingView.layer.borderColor = [UIColor whiteColor].CGColor;
        loadingView.layer.borderWidth = 1.0;
        loadingView.layer.cornerRadius = 5.0;
        
        
        activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activityView.frame = CGRectMake(10, (frame.size.height-activityView.bounds.size.height)/2.0, activityView.bounds.size.width, activityView.bounds.size.height);
        [loadingView addSubview:activityView];
        
        loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(activityView.frame.origin.x+activityView.bounds.size.height+10.0, (frame.size.height-45.0)/2.0, 240.0, 45.0)];
        loadingLabel.backgroundColor = [UIColor clearColor];
        loadingLabel.textColor = [UIColor whiteColor];
        loadingLabel.font = [UIFont systemFontOfSize:14];
        loadingLabel.textAlignment = NSTextAlignmentLeft;
        loadingLabel.numberOfLines = 2;
        [loadingView addSubview:loadingLabel];
        
        [self addSubview:loadingView];
        [activityView startAnimating];
    }
    return self;
}

-(void)HideActivityIndicator
{
    if(activityView)
    {
        if([activityView isAnimating])
        {
            [activityView stopAnimating];
        }
    }
    
    for(UIView *view in self.subviews)
    {
        for(UIView *view1 in view.subviews)
        {
            [view1 removeFromSuperview];
        }
        [view removeFromSuperview];
    }
    
    [self removeFromSuperview];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
