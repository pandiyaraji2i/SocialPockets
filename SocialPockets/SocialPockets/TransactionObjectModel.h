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
- (void)downloadTransactionHistory:(id)dict completion:(void (^)(id obj))completionBlock;
@end
