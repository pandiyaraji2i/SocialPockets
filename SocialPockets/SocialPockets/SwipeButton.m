//
//  SharedMethods.h
//  High Plains Mobile
//
//  Created by Pandiyaraj on 06/05/16.
//  Copyright © 2016 High Plains Information Systems, Inc. All rights reserved.
//

#import "SwipeButton.h"

@class SwipeTableCell;

@implementation SwipeButton

+(instancetype) buttonWithTitle:(NSString *) title backgroundColor:(UIColor *) color callback:(SwipeButtonCallback) callback
{
    return [SwipeButton buttonWithTitle:title icon:nil backgroundColor:color callback:callback];
}

+(instancetype) buttonWithTitle:(NSString *) title icon:(UIImage*) icon backgroundColor:(UIColor *) color callback:(SwipeButtonCallback) callback
{
    return [SwipeButton buttonWithTitle:title icon:icon backgroundColor:color padding:10 callback:callback];
}

+(instancetype) buttonWithTitle:(NSString *) title icon:(UIImage*) icon backgroundColor:(UIColor *) color padding:(NSInteger) padding callback:(SwipeButtonCallback) callback
{
    SwipeButton * button = [SwipeButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = color;
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.callback = callback;
    button.titleLabel.font = FONT;
    button.frame = CGRectMake(button.frame.origin.x, button.frame.origin.y, 90, 25);
    return button;
}

-(BOOL) callSwipeConvenienceCallback: (SwipeTableCell *) sender
{
    if (_callback) {
        return _callback(sender);
    }
    return NO;
}

-(void) setPadding:(CGFloat) padding
{
    self.contentEdgeInsets = UIEdgeInsetsMake(0, padding, 0, padding);
    [self sizeToFit];
}

@end