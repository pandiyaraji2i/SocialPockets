//
//  NSString+AdditionalMethods.m
//  SocialPockets
//
//  Created by Pandiyaraj on 19/07/16.
//  Copyright © 2016 Pandiyaraj. All rights reserved.
//

#import "NSString+AdditionalMethods.h"

@implementation NSString (AdditionalMethods)

-(BOOL)isValidEmail
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

- (BOOL)isValidPhoneNumber
{
//    NSString *mobileNumber = [self formatMobileNumber];
    NSString *numberRegEx = @"[0-9]{10}";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegEx];
    return [numberTest evaluateWithObject:self];
}

- (BOOL)isValidPanNumber
{
    NSString *panRegex = @"^[A-Z]{5}[0-9]{4}[A-Z]$";
    NSPredicate *cardTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", panRegex];
    return [cardTest evaluateWithObject:self];
}

- (NSString *)rupeesFormat
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
    NSString *numberAsString = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:[self doubleValue]]];
    return numberAsString;
}
@end
