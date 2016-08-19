//
//  SharedMethods.h
//  High Plains Mobile
//
//  Created by Pandiyaraj on 06/05/16.
//  Copyright © 2016 High Plains Information Systems, Inc. All rights reserved.
//
#import <UIKit/UIKit.h>

@class SwipeTableCell;

@interface SwipeButton : UIButton

typedef BOOL(^SwipeButtonCallback)(SwipeTableCell * sender);
@property (nonatomic, strong) SwipeButtonCallback callback;

/**
 * Convenience static constructors
 */

+(instancetype) buttonWithTitle:(NSString *) title backgroundColor:(UIColor *) color callback:(SwipeButtonCallback) callback;
+(instancetype) buttonWithTitle:(NSString *) title icon:(UIImage*) icon backgroundColor:(UIColor *) color callback:(SwipeButtonCallback) callback;
-(void) setPadding:(CGFloat) padding;

@end