//
//  CircleProgressView.h
//  CircleProgressView
//
//  Created by GaneshM on 8/8/16.
//  Copyright (c) 2016 GaneshM. All rights reserved.
//

@import UIKit;
@import QuartzCore;

IB_DESIGNABLE
typedef void(^onClickAction)(NSString*);
@interface CircleProgressView : UIView

@property (nonatomic, readwrite)    IBInspectable   double progress;
@property (nonatomic, readwrite)    IBInspectable   BOOL clockwise;
@property (nonatomic, readwrite)    IBInspectable   CGFloat trackWidth;
@property (nonatomic, strong)       IBInspectable   UIImage *trackImage;
@property (nonatomic, strong)       IBInspectable   UIColor *trackBackgroundColor;
@property (nonatomic, strong)       IBInspectable   UIColor *trackFillColor;
@property (nonatomic, strong)       IBInspectable   UIColor *trackBorderColor;
@property (nonatomic, readwrite)    IBInspectable   CGFloat trackBorderWidth;
@property (nonatomic, strong)       IBInspectable   UIColor *centerFillColor;
@property (nonatomic, strong)       IBInspectable   UIImage *centerImage;
@property (nonatomic, strong)       NSString *centerText;
@property (nonatomic,strong) UIButton *button;

@property (nonatomic, strong)                       UIView *contentView;

@property double minimumProgres, maximumProgress;
@property (nonatomic,strong)  UIView *centerView;
@property (nonatomic,strong)  UILabel *centerLabel;
@property (nonatomic,copy) onClickAction onClick;
- (void)setProgress:(double)progress animated:(BOOL)animated;
@end
