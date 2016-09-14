//
//  LoanHelper.m
//  SocialPockets
//
//  Created by Ideas2IT-GaneshM on 20/07/16.
//  Copyright © 2016 Pandiyaraj. All rights reserved.
//

#import "LoanHelper.h"
static LoanHelper* _sharedInstance = nil;


@implementation LoanHelper

/**
 *  Create Singleton instance of class
 *
 *  @return Self Class
 */
+ (LoanHelper *)sharedInstance
{
    @synchronized([LoanHelper class])
    {
        if (!_sharedInstance)
            _sharedInstance =  [[self alloc] init];
        
        return _sharedInstance;
    }
    
    return nil;
}

/**
 *  Check the eligibility status of the user
 *
 *  @param userId          id of the user
 *  @param completionBlock response block
 */
-(void)loanEligibityForUserCompletion:(void (^)(id obj))completionBlock
{
    
    if ([NetworkHelperClass getInternetStatus:YES]) {
        NSMutableDictionary *dict = [@{@"userid":[[NSUserDefaults standardUserDefaults] valueForKey:USERID]} mutableCopy];
        [NetworkHelperClass sendAsynchronousRequestToServer:@"loanrequest/checkEligibilityStatus" httpMethod:POST requestBody:dict contentType:JSONCONTENTTYPE completion:^(id obj) {
            if (completionBlock) {
                completionBlock(obj);
            }
        }];
        //        id successObject = [NetworkHelperClass sendSynchronousRequestToServer:@"loanrequest/checkEligibilityStatus" httpMethod:POST requestBody:dict contentType:JSONCONTENTTYPE];
        //        if (successObject) {
        //            if (completionBlock) {
        //                completionBlock(successObject);
        //            }
        //        }
    }
    else{
        if (completionBlock) {
            completionBlock(nil);
        }
    }
    
}


/**
 *  Send Request for loan
 *
 *  @param userId          Id of the user
 *  @param amount          Amount required as loan
 *  @param createdBy       request sent from userid/admin
 *  @param completionBlock responds with creation of Loan - ID
 */

- (void)requestLoanForUserId:(NSString *)userId amount:(NSString *)amount mobileWallerId:(NSString *)mobileWallerId latitude:(NSString *)latitude longitude:(NSString *)longitude completion:(void (^)(id obj))completionBlock{
    NSMutableDictionary *dict = [@{@"id":[NSNull null],@"userid":userId,@"amount":[amount stringByReplacingOccurrencesOfString:@"," withString:@""],@"created_by":userId,@"mobilewalletid":mobileWallerId,@"latitude":latitude,@"longitude":longitude} mutableCopy];
    [NetworkHelperClass sendAsynchronousRequestToServer:@"loanrequest" httpMethod:POST requestBody:dict contentType:JSONCONTENTTYPE completion:^(id obj) {
        if (completionBlock) {
            completionBlock(obj);
        }
    }];
//    id successObject = [NetworkHelperClass sendSynchronousRequestToServer:@"loanrequest" httpMethod:POST requestBody:dict contentType:JSONCONTENTTYPE];
//    if (successObject) {
//        if (completionBlock) {
//            completionBlock(successObject);
//        }
//    }
}

/**
 *  Checks Status For the Loan
 *
 *  @param loanId          Created Loan id
 *  @param completionBlock responds by sending dictionary within array - "key": "USRLN_STATUS"
 */

- (void)checkStatusOfLoan:(NSString *)loanId completion:(void (^)(id obj))completionBlock{
    
    NSMutableDictionary *dict = [@{@"loanid":loanId} mutableCopy];
    id successObject = [NetworkHelperClass sendSynchronousRequestToServer:@"loanrequest/checkLoanRequestStatus" httpMethod:POST requestBody:dict contentType:JSONCONTENTTYPE];
    if (successObject) {
        if (completionBlock) {
            completionBlock(successObject);
        }
    }
}

/**
 *  Loan RepayMent
 *
 *  @param loanId          selected loan id
 *  @param mobileWallet    mobilewallet id * Not required
 *  @param repayAmount     amount to be repay
 *  @param txRefNum        Citrus Txn ReferenceNumber
 *  @param txId            Citrus Txn Id
 *  @param pgTxnNum        Citrus PG Txn Number
 *  @param transactionId   Citrus PG Txn ID
 *  @param completionBlock response block
 */

- (void)repayLoan:(NSString *)loanId  mobileWallet:(NSString *)mobileWallet repayAmount:(NSString *)repayAmount txRefNum:(NSString *)txRefNum txId:(NSString *)txId pgTxnNum:(NSString *)pgTxnNum transactionId:(NSString *)transactionId completion:(void (^)(id obj))completionBlock{
    
    NSMutableDictionary *dict = [@{@"user_id":[[NSUserDefaults standardUserDefaults] valueForKey:USERID],@"loan_id":loanId,@"mobile_wallet":mobileWallet,@"repayment_amount":[repayAmount stringByReplacingOccurrencesOfString:@"," withString:@""],@"TxRefNo":txRefNum,@"TxId":txId,@"pgTxnNo":pgTxnNum,@"transactionId":transactionId} mutableCopy];
    id successObject = [NetworkHelperClass sendSynchronousRequestToServer:@"loanRepayment" httpMethod:POST requestBody:dict contentType:JSONCONTENTTYPE];
    if (successObject) {
        if (completionBlock) {
            completionBlock(successObject);
        }
    }
}

/**
 *  Get all loans of the user
 *
 *  @param completionBlock response block
 */
- (void)getAllLoansWithCompletionBlock:(void(^)(id obj))completionBlock
{
    if ([NetworkHelperClass getInternetStatus:NO]) {
        //        NSString *urlString = [NSString stringWithFormat:@"userregistration/%@",[[NSUserDefaults standardUserDefaults] valueForKey:USERID]];
        NSString *urlString = [NSString stringWithFormat:@"showallloansofuser?user_id=%@",[[NSUserDefaults standardUserDefaults] valueForKey:USERID]];
        [NetworkHelperClass sendAsynchronousRequestToServer:urlString httpMethod:POST requestBody:nil contentType:JSONCONTENTTYPE completion:^(id obj) {
            if (completionBlock) {
                completionBlock(obj);
            }
            
        }];
    }
}



/**
 *  Request For the Loan Extension
 *
 *  @param loanId          Created Loan id
 *  @param completionBlock response block
 */
- (void)extnLoanForUserId:(NSString *)loanId completion:(void (^)(id obj))completionBlock{
    
    NSMutableDictionary *dict = [@{@"loanid":loanId} mutableCopy];
    id successObject = [NetworkHelperClass sendSynchronousRequestToServer:@"ExtendedLoanRequest" httpMethod:POST requestBody:dict contentType:JSONCONTENTTYPE];
    if (successObject) {
        if (completionBlock) {
            completionBlock(successObject);
        }
    }
}

/**
 *  Status on the Loan Extension request
 *
 *  @param loanId          Created Loan id
 *  @param completionBlock response block
 */
- (void)statusForExtnUserId:(NSString *)loanId completion:(void (^)(id))completionBlock{
    
    NSMutableDictionary *dict = [@{@"loanid":loanId} mutableCopy];
    id successObject = [NetworkHelperClass sendSynchronousRequestToServer:@"ExtendedLoanRequest/checkExtendedLoanRequestStatus" httpMethod:POST requestBody:dict contentType:JSONCONTENTTYPE];
    if (successObject) {
        if (completionBlock) {
            completionBlock(successObject);
        }
    }
}

- (void)getUserCurrentLoanStatusWithCompletionBlock:(void(^)(id))completionBlock
{
    if ([NetworkHelperClass getInternetStatus:NO]) {
        NSString *urlString = [NSString stringWithFormat:@"showusercurrentloanstatus?user_id=%@",[[NSUserDefaults standardUserDefaults] valueForKey:USERID]];
        [NetworkHelperClass sendAsynchronousRequestToServer:urlString httpMethod:GET requestBody:nil contentType:JSONCONTENTTYPE completion:^(id obj) {
            if (completionBlock) {
                completionBlock(obj);
            }
            
        }];
    }
}
@end
