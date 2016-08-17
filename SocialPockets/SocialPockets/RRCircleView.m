//
//  RcircleView.m
//  CircleDraw
//
//  Created by Ideas2IT -Raghav on 25/07/16.
//  Copyright © 2016 rlabr. All rights reserved.
//
//
//  highlight the view controllers
//

#import "RRCircleView.h"

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@interface RRCircleView()

@property (nonatomic, assign) CGFloat maxW;
@property (nonatomic, strong) NSMutableArray *elementsArray;

@end

@implementation RRCircleView {
    UIView *radialMenuView;
    UIView *baseView;
    CGPoint _centerPoint;
    BOOL isFullView;
}

-(void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if (isFullView) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextClearRect(context, rect);
        [self drawHighlightedView:context];
    }
    
}


-(id)initWithFrame:(CGRect)frame{
    return [self initFromPoint:CGPointZero from:[[[[[UIApplication sharedApplication] delegate] window] rootViewController] view]];
}


-(id)initFromPoint:(CGPoint)centerPoint from:(UIView *)base {
    self = [super initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].origin.x, [[UIScreen mainScreen] bounds].origin.y, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    
    if(self){
        centerPoint.y -= [[UIScreen mainScreen] bounds].origin.y;
        _centerPoint = CGPointEqualToPoint(centerPoint, CGPointZero) ? self.center : centerPoint;
        baseView = base;
        [self checkForDefaults];
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}


/**
 *  check the appearence property else give default values
 */
-(void)checkForDefaults {
    if (!self.outerCircleColor) {
        self.outerCircleColor = [UIColor colorWithRed:220/255.0f green:220/255.0f blue:220/255.0f alpha:0.60];
    }
    if (!self.highlightColor) {
        self.highlightColor = [UIColor yellowColor];
    }
    
}


/**
 *  Generates buttons for placing on the outer circle
 *
 *  @param i index
 *
 *  @return A UIButton object
 */
-(UIButton *)generateButtons:(int)i {
    UIButton *element = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    element.backgroundColor = [UIColor colorWithRed:31/255.0f green:144/255.0f blue:38/255.0f alpha:1.00];
    element.layer.cornerRadius = element.bounds.size.height/2.0;
    element.layer.borderColor = [UIColor whiteColor].CGColor;
    element.layer.borderWidth = 1;
    
    if (_imagesArray) {
        [element setImage:[_imagesArray objectAtIndex:i] forState:UIControlStateNormal];

       // [element setBackgroundImage:[_imagesArray objectAtIndex:i] forState:UIControlStateNormal];
    }else {
        [element setTitle:[NSString stringWithFormat:@"%d", i+1] forState:UIControlStateNormal];
    }
    
    if (i <= self.progressNumber-4) {
        element.layer.borderColor = self.highlightColor.CGColor;
    }
    if (i == 6 || i == 7) {
        element.layer.borderColor = self.highlightColor.CGColor;
    }
    
    return element;
}



/**
 *  Adds the frame for the button for placing that radially
 */
-(void)generateRadialMenu{
    _menuRadius = 50;
    
    // calculate the radius according to the screen width
    _menuRadius = ([[UIScreen mainScreen] bounds].size.width - 100)/2;
    
    if (!_numberOfButtons) {
        _numberOfButtons = 8;
    }
    
    _elementsArray = [[NSMutableArray alloc] init];
    radialMenuView = [[UIView alloc] init];
    
    self.maxW = 0;
    for(int i = 0; i < _numberOfButtons; i++){
        UIButton *element = [self generateButtons:i];
        if(self.maxW < element.frame.size.width) self.maxW = element.frame.size.width;
        element.userInteractionEnabled = YES;
        element.alpha = 0;
        element.tag = i;
        [element addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.elementsArray addObject:element];
        
        [radialMenuView addSubview:element];
    }
    
    radialMenuView.frame = CGRectMake(0, 0, _menuRadius*2.0+self.maxW, _menuRadius*2.0+self.maxW);
    radialMenuView.center = _centerPoint;
    radialMenuView.userInteractionEnabled = YES;

}



/**
 *  radial button IBAction fnction
 *
 *  @param sender uibutton sender
 */
-(void)didTapButton:(UIButton *)sender{
    // do stuff when the button is clicked
//    NSLog(@"%ld", (long)sender.tag);
}


-(void)showFullView:(BOOL)fullView{
    isFullView = fullView;
    if (fullView) {
        [self generateRadialMenu];
        
        [self addSubview:radialMenuView];
        self.backgroundColor = [UIColor clearColor];
        [self placeRadialMenuElementsAnimated:NO];
        [self drawTheOuterLine];
    }else {
        CGFloat dia = [[UIScreen mainScreen] bounds].size.width;
        [self createAViewWithRadius:dia-120];
        [self createAViewWithRadius:dia-160];
        [self createAViewWithRadius:dia-200];
    }
    
    [baseView addSubview:self];
}


/**
 *  places Radial Menu Elements
 *
 *  @param animated Boolian
 */
-(void)placeRadialMenuElementsAnimated:(BOOL)animated{
    CGFloat startingAngle = 0;
    CGFloat usableAngle = 2.0*M_PI;
    
    //Placing the objects
    for(int i = 0; i < [self.elementsArray count]; i++){
        UIButton *element = [self.elementsArray objectAtIndex:i];
        element.center = CGPointMake(radialMenuView.frame.size.width/2.0, radialMenuView.frame.size.height/2.0);
        double delayInSeconds = 0.025*i;
        
        void (^elementPositionBlock)(void) = ^{
            element.alpha = 1;
            [radialMenuView bringSubviewToFront:element];
            CGPoint endPoint = CGPointMake(radialMenuView.frame.size.width/2.0+(_menuRadius)*(cos(startingAngle+usableAngle/(self.numberOfButtons)*(float)i)), radialMenuView.frame.size.height/2.0+(_menuRadius)*(sin(startingAngle+usableAngle/(self.numberOfButtons)*(float)i)));
            element.center = endPoint;
        };
        
        if(animated) {
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [UIView animateWithDuration:0.25 animations:elementPositionBlock];
            });
        } else elementPositionBlock();
    }
}


#pragma mark - draw line outer


-(void) drawTheOuterLine {
    [self drawAvatarView];
    [self drawView];
}


-(void)drawView {
    CGFloat dia = 2.0*_menuRadius+20;
    
    [self createAViewWithRadius:dia-40];
    [self createAViewWithRadius:dia-80];
    [self createAViewWithRadius:dia-120];
}
-(void)createAViewWithRadius:(CGFloat)dia {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, dia, dia)];
    view.center = _centerPoint;
    view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.05];
    view.layer.cornerRadius = dia/2;
    view.layer.masksToBounds = true;
    [self addSubview:view];
}



-(void) drawAvatarView {
    CGRect frame = CGRectMake(0, 0, 2.0*(_menuRadius/4), 2.0*(_menuRadius/4));
    UIImageView *view = [[UIImageView alloc] initWithFrame:frame];
    view.layer.cornerRadius = 2.0*(_menuRadius/4)/2;
    view.backgroundColor = [UIColor lightGrayColor];
    view.layer.borderColor = [UIColor whiteColor].CGColor;
    view.layer.borderWidth = 3.0;
    view.center = _centerPoint;
    view.image = self.avatarImage;
    [self addSubview:view];
    
    [self drawCenterLine];
    
}


-(void) drawCenterLine {
    NSArray *buttonViews = [radialMenuView subviews];
    for (UIView *view in buttonViews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIBezierPath *path = [UIBezierPath bezierPath];
            [path moveToPoint:[self convertPoint:view.center fromView:radialMenuView]];
            [path addLineToPoint:_centerPoint];
            
            CAShapeLayer *shapeLayer = [CAShapeLayer layer];
            shapeLayer.path = [path CGPath];
            shapeLayer.strokeColor = [[UIColor lightGrayColor] CGColor];
            shapeLayer.lineWidth = 1.0;
            shapeLayer.lineJoin = kCALineJoinMiter;
            shapeLayer.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:4], nil];
            shapeLayer.lineDashPhase = 3.0f;
            shapeLayer.fillColor = [[UIColor clearColor] CGColor];
            [self.layer insertSublayer:shapeLayer atIndex:0];
        }
    }
}


-(void) drawHighlightedView:(CGContextRef) context {
    [self setNeedsDisplay];
    CGPoint center = _centerPoint;
    CGFloat radius = _menuRadius+10;
    
    CGFloat _startAngle = 360 - ((360/8)*2);
    CGFloat progressAngle = (360/8)*(self.progressNumber-4);
    
    CGFloat barWidth = 20.0;
    
    CGContextSetFillColorWithColor(context, [self.outerCircleColor colorWithAlphaComponent:0.40].CGColor);
    CGContextBeginPath(context);
    CGContextAddArc(context, center.x, center.y, radius, DEGREES_TO_RADIANS(progressAngle), DEGREES_TO_RADIANS(_startAngle + 360), 0);
    CGContextAddArc(context, center.x, center.y, radius - barWidth, DEGREES_TO_RADIANS(_startAngle + 360), DEGREES_TO_RADIANS(progressAngle), 1);
    CGContextClosePath(context);
    CGContextFillPath(context);
    
    CGContextSetFillColorWithColor(context, self.highlightColor.CGColor);
    CGContextBeginPath(context);
    CGContextAddArc(context, center.x, center.y, radius, DEGREES_TO_RADIANS(_startAngle), DEGREES_TO_RADIANS(progressAngle), 0);
    CGContextAddArc(context, center.x, center.y, radius - barWidth, DEGREES_TO_RADIANS(progressAngle), DEGREES_TO_RADIANS(_startAngle), 1);
    CGContextClosePath(context);
    CGContextFillPath(context);
}


@end
