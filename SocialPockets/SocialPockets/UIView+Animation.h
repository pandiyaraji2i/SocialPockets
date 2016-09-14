//
//  UIView+Animation.h
//  High Plains Mobile
//
//  Created by Pandiyaraj on 10/03/16.
//  Copyright © 2016 High Plains Information Systems, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Animation)

- (void) moveTo:(CGPoint)destination duration:(float)secs option:(UIViewAnimationOptions)option;
- (void) downUnder:(float)secs option:(UIViewAnimationOptions)option;
- (void) addSubviewWithZoomInAnimation:(UIView*)view duration:(float)secs option:(UIViewAnimationOptions)option;
- (void) removeWithZoomOutAnimation:(float)secs option:(UIViewAnimationOptions)option;
- (void) addSubviewWithFadeAnimation:(UIView*)view duration:(float)secs option:(UIViewAnimationOptions)option;
- (void) removeWithSinkAnimation:(int)steps;
- (void) removeWithSinkAnimationRotateTimer:(NSTimer*) timer;
- (UIView *)customSnapshotFromView;
- (UIView *)findTopMostViewForPoint:(CGPoint)point;
- (void)removeSubviewWithFadeAnimation:(float)secs;
@end
