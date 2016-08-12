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


- (TransactionHistory *)transactionHistoryInfoFromId:(NSString *)loanId isAddToUser:(BOOL)isAdd context:(NSManagedObjectContext *)context
{
    NSArray *transHistoryArr=[DatabaseObject searchObjectsForEntityChild:@"TransactionHistory" withPredicate:[NSPredicate predicateWithFormat:@"loanId == %@",loanId] andSortKey:nil andSortAscending:YES context:context];
    if (transHistoryArr.count) {
        return transHistoryArr[0];
    }
    TransactionHistory *transactionHistory = [NSEntityDescription insertNewObjectForEntityForName:@"TransactionHistory" inManagedObjectContext:context];
    if (loanId!=nil) {
        transactionHistory.loanId=loanId;
    }
    else{
        transactionHistory.loanId= transactionHistory.objectID.URIRepresentation.absoluteString;
    }
    UserDetails *tempUser = (id)[context objectWithID:USERINFO.objectID];
    if (isAdd) {
        [tempUser addUserTransactionsObject:transactionHistory];
    }
    return transactionHistory;
}

- (TransactionHistory *)transactionHistoryInfoFromId:(NSString *)loanId context:(NSManagedObjectContext *)context
{
    NSArray *travelPlanArr=[DatabaseObject searchObjectsForEntityChild:@"TransactionHistory" withPredicate:[NSPredicate predicateWithFormat:@"loanId == %@",loanId] andSortKey:nil andSortAscending:YES context:context];
    if (travelPlanArr.count) {
        return travelPlanArr[0];
    }
    return nil;
}


- (void)downloadTransactionHistory:(id)dict completion:(void (^)(int value))completionBlock{
    if ([NetworkHelperClass getInternetStatus:NO]) {
        //        NSString *urlString = [NSString stringWithFormat:@"userregistration/%@",[[NSUserDefaults standardUserDefaults] valueForKey:USERID]];
        NSString *urlString = [NSString stringWithFormat:@"showallloansofuser"];
        [NetworkHelperClass sendAsynchronousRequestToServer:urlString httpMethod:POST requestBody:dict contentType:JSONCONTENTTYPE completion:^(id obj) {
            if ([obj isKindOfClass:[NSArray class]] && [obj count]) {
                [self updateTransactionHistory:obj];
                if (completionBlock) {
                    completionBlock(1);
                }
            }
            if (completionBlock) {
                completionBlock(0);
            }
           
            
        }];
    }
}

/**
 *  Get individual loan details
 *
 *  @param loanId          loan id
 *  @param completionBlock response block
 */
- (void)getIndividualLoan:(NSString *)loanId completion:(void(^)(id obj))completionBlock
{
    if ([NetworkHelperClass getInternetStatus:NO]) {
        NSString *urlString = [NSString stringWithFormat:@"showloandetails?loan_id=%@",loanId];
        [NetworkHelperClass sendAsynchronousRequestToServer:urlString httpMethod:GET requestBody:nil contentType:JSONCONTENTTYPE completion:^(id obj) {
            if ([obj isKindOfClass:[NSArray class]]) {
                [self updateTransactionHistory:obj];
            }
        }];
    }
}

- (void)updateTransactionHistory:(NSArray *)array
{
    NSManagedObjectContext *saveUpdateTravelPlanContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [saveUpdateTravelPlanContext performBlockAndWait:^{
        saveUpdateTravelPlanContext.parentContext = DATABASE.managedObjectContext;
        for (int i=0; i<array.count; i++) {
            NSDictionary *transactionHistoryDict = array[i];
            if ([transactionHistoryDict isKindOfClass:[NSDictionary class]]) {
                NSString *loanId = [NSString stringWithFormat:@"%@",transactionHistoryDict[@"USRLN_ID"]];
                TransactionHistory *transHistoryDetails = [self transactionHistoryInfoFromId:loanId context:saveUpdateTravelPlanContext];
                if (!transHistoryDetails) {
                    transHistoryDetails = [self transactionHistoryInfoFromId:loanId isAddToUser:YES context:saveUpdateTravelPlanContext];
                }
                [self updateDetails:transHistoryDetails withDict:transactionHistoryDict context:saveUpdateTravelPlanContext];
            }
        }
        [DATABASE dbSaveRecordChildContext:saveUpdateTravelPlanContext];
    }];
}

- (void)updateDetails:(TransactionHistory *)transactionHistory withDict:(NSDictionary *)transHistoryDict context:(NSManagedObjectContext *)context
{
    NSArray *travelplanEntityKeys = [[transactionHistory.entity attributesByName] allKeys];
    for (id key in travelplanEntityKeys) {
        if ([key isEqualToString:@"loanObject"]) {
            [transactionHistory setValue:transHistoryDict forKey:key];
        }
    }
}

@end
