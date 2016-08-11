//
//  NSString+AdditionalMethods.h
//  SocialPockets
//
//  Created by Pandiyaraj on 19/07/16.
//  Copyright © 2016 Pandiyaraj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (AdditionalMethods)
- (BOOL)isValidEmail;
- (BOOL)isValidPhoneNumber;
- (BOOL)isValidPanNumber;
- (NSString *)rupeesFormat;
- (void)createFolderAtPath;
@end
