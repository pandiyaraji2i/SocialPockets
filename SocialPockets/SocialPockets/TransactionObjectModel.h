//
//  TransactionObjectModel.h
//  SocialPockets
//
//  Created by Pandiyaraj on 11/08/16.
//  Copyright © 2016 Pandiyaraj. All rights reserved.
//

#import <Foundation/Foundation.h>
#define TRANSACTHISTORY [TransactionObjectModel sharedTransactionHistory]
@interface TransactionObjectModel : NSObject
+ (TransactionObjectModel *)sharedTransactionHistory;
- (NSArray *)getAllTransactionHistory;
- (void)downloadTransactionHistory:(id)dict completion:(void (^)(int value))completionBlock;
- (void)getIndividualLoan:(NSString *)loanId completion:(void(^)(id obj))completionBlock;
- (void)updateTransactionHistory:(NSArray *)array;
- (void)updateSingleLoanTransaction:(id)transactionHistoryDict context:(NSManagedObjectContext *)context;
@end
