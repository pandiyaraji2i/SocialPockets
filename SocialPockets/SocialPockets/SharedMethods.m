//
//  SharedMethods.m
//  SocialPockets
//
//  Created by Pandiyaraj on 21/07/16.
//  Copyright © 2016 Pandiyaraj. All rights reserved.
//

#import "SharedMethods.h"

@implementation SharedMethods

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *errorMessageAlert=[[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        
        [errorMessageAlert show];
    });
    return;
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"My Title"
                                  message:@"Enter User Credentials"
                                  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action){
                                                     }] ;
    [alert addAction:actionOk];
    
    [[self visibleViewController] presentViewController:alert animated:YES completion:nil];
}

+ (void)showAlertActionWithTitle:(NSString *)title message:(NSString *)message completion:(void (^)(id obj))completionBlock
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    //We add buttons to the alert controller by creating UIAlertActions:
    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action){
                                                         completionBlock(nil);
                                                     }] ;
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:actionOk];
    [alertController addAction:actionCancel];
    [[self visibleViewController] presentViewController:alertController animated:YES completion:nil];
}

+ (UIViewController*)topMostController
{
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (topController.presentedViewController)
    {
        topController = topController.presentedViewController;
    }
    return topController;
}

+ (UIViewController *)visibleViewController
{
    UIViewController *topController = [SharedMethods topMostController];
    if ([topController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *tempC = (id)topController;
        return tempC.visibleViewController;
    }
    
    if ([topController isKindOfClass:[MFSideMenuContainerViewController class]]){
        MFSideMenuContainerViewController *tempC = (id)topController;
        return tempC.centerViewController;
    }
    return nil;
}

+ (NSString *)stringFromGivenDate:(NSDate *)date formatType:(NSString *)formatType
{
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:formatType];
    NSString *afterString=[dateformatter stringFromDate:date];
    return afterString;
}

+ (NSDate *)dateFromGivenString:(NSString *)dateString formatType:(NSString *)formatType
{
    NSDateFormatter *formater=[[NSDateFormatter alloc]init];
    [formater setDateFormat:formatType];
    NSDate *curntdate =[formater dateFromString:dateString];
    return curntdate;
}

+(NSString*)convertString:(NSString*)dateString fromFormat:(NSString*)format1 toFormat:(NSString*)format2{
    NSDate *tempDate=[SharedMethods dateFromGivenString:dateString formatType:format1];
    return [SharedMethods stringFromGivenDate:tempDate formatType:format2];
}

+ (NSDate *)addDaysToDate:(int)days startDate:(NSDate *)date
{
    NSCalendar *cal         = [NSCalendar currentCalendar];
    NSDateComponents *comps = [cal components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekOfYear fromDate:date];
    comps.day+=days;
    return [cal dateFromComponents:comps];
}

+ (NSString*)documentPathWithPath:(NSString*)path {
    NSString *pathWithUserId=path;
    if (USERINFO.userId.length) {
        if (path.length) {
            pathWithUserId = [USERINFO.userId stringByAppendingPathComponent:path];
        }
        else {
            pathWithUserId = USERINFO.userId;
        }
        
    }
    [pathWithUserId createFolderAtPath];
    return [DOCUMENT_DIRECTORY stringByAppendingPathComponent:pathWithUserId];
}


@end
