//
//  LoanHelper.h
//  SocialPockets
//
//  Created by Ideas2IT-GaneshM on 20/07/16.
//  Copyright © 2016 Pandiyaraj. All rights reserved.
//

#import <Foundation/Foundation.h>
#define LOANMACRO [LoanHelper sharedInstance]

@interface LoanHelper : NSObject
+ (LoanHelper *)sharedInstance;

- (void)eligibityForUserId:(NSString *)userId completion:(void (^)(id obj))completionBlock;

- (void)requestLoanForUserId:(NSString *)userId amount:(NSString *)amount createdBy:(NSString *)createdBy completion:(void (^)(id obj))completionBlock;

- (void)checkStatusOfLoan:(NSString *)loanId completion:(void (^)(id obj))completionBlock;

- (void)repayLoanForUserId:(NSString *)userId loanId:(NSString *)loanId  mobileWallet:(NSString *)mobileWallet repayAmount:(NSString *)repayAmount completion:(void (^)(id obj))completionBlock;

- (void)getAllLoansWithCompletionBlock:(void(^)(id obj))completionBlock;

- (void)getIndividualLoan:(NSString *)loanId completion:(void(^)(id obj))completionBlock;

- (void)extnLoanForUserId:(NSString *)loanId completion:(void (^)(id obj))completionBlock;

- (void)statusForExtnUserId:(NSString *)loanId completion:(void (^)(id))completionBlock;
@end