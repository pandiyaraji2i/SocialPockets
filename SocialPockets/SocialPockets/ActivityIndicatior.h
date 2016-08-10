//
//  ActivityIndicatior.h
//  High Plains Mobile
//
//  Created by Pandiyaraj on 19/01/16.
//  Copyright © 2016 High Plains Information Systems, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessagePopUpView.h"
#define ACTIVITY [ActivityIndicatior sharedInstance]

@interface ActivityIndicatior : NSObject
{
    MessagePopUpView *messageView;
}
+ (ActivityIndicatior *)sharedInstance;
+ (void)resetSharedInstance;
- (void)showActivity:(NSString*)message;
- (void)hideActivity;

@end
