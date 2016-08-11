//
//  TransactionObjectModel.m
//  SocialPockets
//
//  Created by Pandiyaraj on 11/08/16.
//  Copyright © 2016 Pandiyaraj. All rights reserved.
//

#import "TransactionObjectModel.h"

@implementation TransactionObjectModel

+ (TransactionObjectModel *)sharedTransactionHistory{
    @synchronized([TransactionObjectModel class])
    {
        static TransactionObjectModel *_sharedTransactionHistory;
        if (!_sharedTransactionHistory)
        {
            _sharedTransactionHistory=[[TransactionObjectModel alloc] init];
        }
        return _sharedTransactionHistory;
    }
    return nil;
}

- (NSArray *)getAllTransactionHistory
{
    return USERINFO.userTransactions.allObjects;
}

- (void)downloadTransactionHistory:(id)dict completion:(void (^)(id obj))completionBlock{
    if ([NetworkHelperClass getInternetStatus:NO]) {
        //        NSString *urlString = [NSString stringWithFormat:@"userregistration/%@",[[NSUserDefaults standardUserDefaults] valueForKey:USERID]];
        NSString *urlString = [NSString stringWithFormat:@"showallloansofuser"];
        [NetworkHelperClass sendAsynchronousRequestToServer:urlString httpMethod:POST requestBody:dict contentType:JSONCONTENTTYPE completion:^(id obj) {
            if (completionBlock) {
                completionBlock(obj);
            }
            
        }];
    }
}
@end
