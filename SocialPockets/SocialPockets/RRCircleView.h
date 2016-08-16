//
//  RRCircleView.h
//  CircleDraw
//
//  Created by Ideas2IT -Raghav on 25/07/16.
//  Copyright © 2016 rlabr. All rights reserved.
//

#import <UIKit/UIKit.h>


/** Class that represents RRCircleView itself.
 
 RcircleView can be initialized programmatically or using InterfaceBuilder.
 
 To show RRcircleView just use:
 
 RRcircleView *view = [[RRcircleView alloc] initFromPoint:self.view.center from:self.view];
 [view showFullView:true];
 
 Interface provides ability to customize each element of CircleProgressBar independently;
 
 */
IB_DESIGNABLE
@interface RRCircleView : UIView


/**
 *  number of buttons for the view that should on the outer circle
 */
@property (nonatomic) IBInspectable NSInteger numberOfButtons;


/**
 *  radius of the buttons on outer circle
 */
@property (nonatomic, readonly) IBInspectable CGFloat menuRadius;


/**
 *  avatar or profile image that will be should on the middle
 */
@property (nonatomic) IBInspectable UIImage *avatarImage;


/**
 *  image array for the buttons
 */
@property (nonatomic) NSArray<UIImage *> *imagesArray;


/**
 *  progress highlighter; a value starts from 0
 */
@property (nonatomic) IBInspectable int progressNumber;


//***************************************//
//**************appearence***************//
//***************************************//

/**
 *  OuterCircle Color for non selected items
 */
@property (nonatomic) UIColor *outerCircleColor;

/**
 *  highlight Color for the selected items
 */
@property (nonatomic) UIColor *highlightColor;




/**
 *  init for the Rcircleview
 *
 *  @param centerPoint center pointfor the view
 *  @param base        base view (e.g. self.view for a view controller)
 *
 *  @return instance
 */
-(id)initFromPoint:(CGPoint)centerPoint from:(UIView *)base;


/**
 *  shows the view
 *
 *  @param fullView BOOL value to show whether full view
 */
-(void)showFullView:(BOOL)fullView;

@end
