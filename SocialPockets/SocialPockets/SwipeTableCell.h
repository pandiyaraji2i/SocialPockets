//
//  SharedMethods.h
//  High Plains Mobile
//
//  Created by Pandiyaraj on 06/05/16.
//  Copyright © 2016 High Plains Information Systems, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SwipeTransition)
{
    SwipeTransitionBorder = 0,
    SwipeTransitionStatic,
    SwipeTransitionDrag,
    SwipeTransitionClipCenter,
    SwipeTransition3D,
};

typedef NS_ENUM(NSInteger, SwipeDirection)
{
    SwipeDirectionLeftToRight = 0,
    SwipeDirectionRightToLeft
};

typedef NS_ENUM(NSInteger, SwipeState)
{
    SwipeStateNone = 0,
    SwipeStateSwippingLeftToRight,
    SwipeStateSwippingRightToLeft,
    SwipeStateExpandingLeftToRight,
    SwipeStateExpandingRightToLeft,
};

@interface SwipeSettings: NSObject

@property (nonatomic, assign) SwipeTransition transition;
@property (nonatomic, assign) CGFloat threshold;
@property (nonatomic, assign) CGFloat offset;
@property (nonatomic, assign) CGFloat animationDuration;

@end

@interface SwipeExpansionSettings: NSObject

@property (nonatomic, assign) NSInteger buttonIndex;
@property (nonatomic, assign) BOOL fillOnTrigger;
@property (nonatomic, assign) CGFloat threshold;
@property (nonatomic, assign) CGFloat animationDuration;

@end

@class SwipeTableCell;

@protocol SwipeTableCellDelegate <NSObject>

@optional

-(BOOL) swipeTableCell:(SwipeTableCell*) cell canSwipe:(SwipeDirection) direction;
-(void) swipeTableCell:(SwipeTableCell*) cell didChangeSwipeState:(SwipeState) state gestureIsActive:(BOOL) gestureIsActive;
-(BOOL) swipeTableCell:(SwipeTableCell*) cell tappedButtonAtIndex:(NSInteger) index direction:(SwipeDirection)direction fromExpansion:(BOOL) fromExpansion;
-(NSArray*) swipeTableCell:(SwipeTableCell*) cell swipeButtonsForDirection:(SwipeDirection)direction
             swipeSettings:(SwipeSettings*) swipeSettings expansionSettings:(SwipeExpansionSettings*) expansionSettings;

@end

@interface SwipeTableCell : UITableViewCell

@property (nonatomic, weak) id<SwipeTableCellDelegate> delegate;
@property (nonatomic, strong, readonly) UIView * swipeContentView;
@property (nonatomic, copy) NSArray * leftButtons;
@property (nonatomic, copy) NSArray * rightButtons;
@property (nonatomic, strong) SwipeSettings * leftSwipeSettings;
@property (nonatomic, strong) SwipeSettings * rightSwipeSettings;
@property (nonatomic, strong) SwipeExpansionSettings * leftExpansion;
@property (nonatomic, strong) SwipeExpansionSettings * rightExpansion;
@property (nonatomic, readonly) SwipeState swipeState;
@property (nonatomic, readonly) BOOL isSwipeGestureActive;
@property (nonatomic, strong) UIColor * swipeBackgroundColor;
@property (nonatomic, assign) CGFloat swipeOffset;

@property (weak, nonatomic) IBOutlet UILabel *titlelabel;
@property (weak, nonatomic) IBOutlet UILabel *desclabel;
@property (weak, nonatomic) IBOutlet UILabel *queuelabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowimageView;
@property (weak, nonatomic) IBOutlet UIButton *queuebutton;

-(void) hideSwipeAnimated: (BOOL) animated;
-(void) showSwipe: (SwipeDirection) direction animated: (BOOL) animated;
-(void) setSwipeOffset:(CGFloat)offset animated: (BOOL) animated completion:(void(^)()) completion;
-(void) refreshContentView;
-(void) refreshButtons: (BOOL) usingDelegate;

@end