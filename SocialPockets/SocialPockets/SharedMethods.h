//
//  SharedMethods.h
//  SocialPockets
//
//  Created by Pandiyaraj on 21/07/16.
//  Copyright © 2016 Pandiyaraj. All rights reserved.
//

#import <Foundation/Foundation.h>
#define ErrorMessageWithTitle(titleStr,messageStr) [SharedMethods showAlertWithTitle:titleStr message:messageStr]
#define NULL_TO_NIL(obj) ({ __typeof__ (obj) __obj = (obj); (__obj == [NSNull null] || ([__obj isKindOfClass:[NSString class]] && [__obj isEqualToString:@"(null)"])) ? @"" : obj; })

@interface SharedMethods : NSObject

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message;
+ (void)showAlertActionWithTitle:(NSString *)title message:(NSString *)message completion:(void (^)(id obj))completionBlock;
+ (UIViewController*)topMostController;
+ (UIViewController *)visibleViewController;
+ (NSString *)stringFromGivenDate:(NSDate *)date formatType:(NSString *)formatType;
+ (NSDate *)dateFromGivenString:(NSString *)dateString formatType:(NSString *)formatType;
+ (NSString*)convertString:(NSString*)dateString fromFormat:(NSString*)format1 toFormat:(NSString*)format2;
+ (NSDate *)addDaysToDate:(int)days startDate:(NSDate *)date;
+ (NSString*)documentPathWithPath:(NSString*)path;
+ (NSString *)hmacsha1:(NSString *)data secret:(NSString *)key;
@end
