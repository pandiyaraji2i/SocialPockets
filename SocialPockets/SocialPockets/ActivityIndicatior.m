//
//  ActivityIndicatior.m
//  High Plains Mobile
//
//  Created by Pandiyaraj on 19/01/16.
//  Copyright © 2016 High Plains Information Systems, Inc. All rights reserved.
//

#import "ActivityIndicatior.h"

static ActivityIndicatior* _sharedInstance = nil;

@implementation ActivityIndicatior

/**
 *  Singleton Instance
 *
 *  @return Shared Instance object of Activity
 */
+ (ActivityIndicatior *)sharedInstance
{
    @synchronized([ActivityIndicatior class])
    {
        if (!_sharedInstance)
            _sharedInstance =  [[self alloc] init];
        
        return _sharedInstance;
    }
    
    return nil;
}

+ (void)resetSharedInstance {
    _sharedInstance = nil;
}


- (id)init
{
    self = [super init];
    
    if (self) {
        
        UIViewController *topView = [SharedMethods topMostController];
        
        if(messageView)[messageView HideActivityIndicator];
        float width = topView.view.frame.size.width - 60;
        float height = 80;
        messageView = [[MessagePopUpView alloc] initWithFrame:CGRectMake((topView.view.frame.size.width-width)/2.0, (topView.view.frame.size.height-height)/2.0, width, height)];
        messageView.hidden = YES;
        [topView.view addSubview:messageView];
        
    }
    
    return self;
}

/**
 *  Show Activity Loader to the top view
 *
 *  @param message Displayed Message
 */
- (void)showActivity:(NSString*)message
{
    dispatch_async(dispatch_get_main_queue(), ^{
        messageView.loadingLabel.text = @"";
        UIViewController *topView = [SharedMethods topMostController];
        topView.view.userInteractionEnabled = NO;
        messageView.hidden = NO;
        messageView.loadingLabel.text = message;
    });
}

/**
 *  Hide Activity from the view
 */

- (void)hideActivity
{
//    dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController *topView = [SharedMethods topMostController];
        topView.view.userInteractionEnabled = YES;
        messageView.hidden = YES;
//    });
    
}



@end
