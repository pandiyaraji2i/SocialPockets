//
//  UIView+Animation.m
//  High Plains Mobile
//
//  Created by Pandiyaraj on 10/03/16.
//  Copyright © 2016 High Plains Information Systems, Inc. All rights reserved.
//

#import "UIView+Animation.h"

@implementation UIView (Animation)
- (void) moveTo:(CGPoint)destination duration:(float)secs option:(UIViewAnimationOptions)option
{
    [UIView animateWithDuration:secs delay:0.0 options:option
                     animations:^{
                         self.frame = CGRectMake(destination.x,destination.y, self.frame.size.width, self.frame.size.height);
                     }
                     completion:nil];
}

- (void) downUnder:(float)secs option:(UIViewAnimationOptions)option
{
    [UIView animateWithDuration:secs delay:0.0 options:option
                     animations:^{
                         self.transform = CGAffineTransformRotate(self.transform, M_PI);
                     }
                     completion:nil];
}

- (void) addSubviewWithZoomInAnimation:(UIView*)view duration:(float)secs option:(UIViewAnimationOptions)option
{
  
    [[NSNotificationCenter defaultCenter] postNotificationName:@"disableSwipegesture" object:nil];

    // first reduce the view to 1/100th of its original dimension
    CGAffineTransform trans = CGAffineTransformScale(view.transform, 0.01, 0.01);
    view.transform = trans;	// do it instantly, no animation
    [self addSubview:view];
    // now return the view to normal dimension, animating this tranformation
    [UIView animateWithDuration:secs delay:0.0 options:option
                     animations:^{
                         view.transform = CGAffineTransformScale(view.transform, 100.0, 100.0);
                     }
                     completion:nil];
}

- (void) removeWithZoomOutAnimation:(float)secs option:(UIViewAnimationOptions)option
{
     [[NSNotificationCenter defaultCenter] postNotificationName:@"enableSwipegesture" object:nil];
    [UIView animateWithDuration:secs delay:0.0 options:option
                     animations:^{
                         self.transform = CGAffineTransformScale(self.transform, 0.01, 0.01);
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}

// add with a fade-in effect
- (void) addSubviewWithFadeAnimation:(UIView*)view duration:(float)secs option:(UIViewAnimationOptions)option
{
    view.alpha = 0.0;	// make the view transparent
    [self addSubview:view];	// add it
    [UIView animateWithDuration:secs delay:0.0 options:option
                     animations:^{view.alpha = 1.0;}
                     completion:nil];	// animate the return to visible
}

// remove self making it "drain" from the sink!
- (void) removeWithSinkAnimation:(int)steps
{
    NSTimer *timer;
    if (steps > 0 && steps < 100)	// just to avoid too much steps
        self.tag = steps;
    else
        self.tag = 50;
    timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(removeWithSinkAnimationRotateTimer:) userInfo:nil repeats:YES];
}
- (void) removeWithSinkAnimationRotateTimer:(NSTimer*) timer
{
    CGAffineTransform trans = CGAffineTransformRotate(CGAffineTransformScale(self.transform, 0.9, 0.9),0.314);
    self.transform = trans;
    self.alpha = self.alpha * 0.98;
    self.tag = self.tag - 1;
    if (self.tag <= 0)
    {
        [timer invalidate];
        [self removeFromSuperview];
    }
}


// Screen Shot

- (UIView *)customSnapshotFromView {
    
    // Make an image from the input view.
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Create an image view.
    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    
    return snapshot;
}
- (void)removeSubviewWithFadeAnimation:(float)secs
{
    [UIView animateWithDuration:secs
                     animations:^ {
                         CGRect frame = self.frame;
                         frame.origin.y = self.frame.size.width+500;
                         self.frame = frame;
                         self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                         [UIView beginAnimations:nil context:nil];
                         [UIView setAnimationDuration:2.0];
                         [UIView commitAnimations];
                     }];
    
    
}
/*- (UIView *)findTopMostViewForPoint:(CGPoint)point
{
    for(int i = self.subviews.count - 1; i >= 0; i--)
    {
        UIView *subview = [self.subviews objectAtIndex:i];
        if(!subview.hidden && CGRectContainsPoint(subview.frame, point))
        {
            CGPoint pointConverted = [self convertPoint:point toView:subview];
            return [subview findTopMostViewForPoint:pointConverted];
        }
    }
    
    return self;
}

- (BOOL)isTopmostViewInWindow
{
    if(self.window == nil)
    {
        return NO;
    }
    
    CGPoint centerPointInSelf = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    CGPoint centerPointOfSelfInWindow = [self convertPoint:centerPointInSelf toView:self.window];
    UIView *view = [self.window findTopMostViewForPoint:centerPointOfSelfInWindow];
    BOOL isTopMost = view == self || [view isDescendantOfView:self];
    return isTopMost;
}*/

@end
