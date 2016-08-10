//
//  BankAccHelper.h
//  SocialPockets
//
//  Created by Ideas2IT-GaneshM on 21/07/16.
//  Copyright © 2016 Pandiyaraj. All rights reserved.
//

#import <Foundation/Foundation.h>
#define BANKACCHELPER [BankAccHelper sharedInstance]

@interface BankAccHelper : NSObject
+ (BankAccHelper *)sharedInstance;

- (void)createBankAccountForUserId:(NSString *)userId bankName:(NSString *)bankName ifscCode:(NSString *)ifscCode accountNumber:(NSString*)
accountNumber branchName:(NSString *)branchName createdBy:(NSString *)createdBy completion:(void (^)(id obj))completionBlock;

- (void)deleteBankAccountWithId:(NSString *)bankAccountId completion:(void (^)(id obj))completionBlock;

- (void)showAllAccountWithcompletion:(void (^)(id obj))completionBlock;


@end
