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
        NSMutableDictionary *dict = [@{@"userid":@"43"} mutableCopy];

//        NSMutableDictionary *dict = [@{@"userid":[[NSUserDefaults standardUserDefaults] valueForKey:USERID]} mutableCopy];
        id successObject = [NetworkHelperClass sendSynchronousRequestToServer:@"loanrequest/checkEligibilityStatus" httpMethod:POST requestBody:dict contentType:JSONCONTENTTYPE];
        if (successObject) {
            if (completionBlock) {
                completionBlock(successObject);
            }
        }
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

- (void)requestLoanForUserId:(NSString *)userId amount:(NSString *)amount completion:(void (^)(id obj))completionBlock{
    NSMutableDictionary *dict = [@{@"id":[NSNull null],@"userid":userId,@"amount":amount,@"created_by":userId} mutableCopy];
    id successObject = [NetworkHelperClass sendSynchronousRequestToServer:@"loanrequest" httpMethod:POST requestBody:dict contentType:JSONCONTENTTYPE];
    if (successObject) {
        if (completionBlock) {
            completionBlock(successObject);
        }
    }
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
 *  To repay loan by sending amount from mobile wallet
 *
 *  @param userId          Id of the user
 *  @param loanId          Created Loan id
 *  @param mobileWallet    mobileWallet for the user
 *  @param repayAmount     repayment amount of the user
 *  @param completionBlock responds by sending the repay amount from mobile wallet to the admin 
 */

- (void)repayLoan:(NSString *)loanId  mobileWallet:(NSString *)mobileWallet repayAmount:(NSString *)repayAmount completion:(void (^)(id obj))completionBlock{
    
    NSMutableDictionary *dict = [@{@"user_id":[[NSUserDefaults standardUserDefaults] valueForKey:USERID],@"loan_id":loanId,@"mobile_wallet":mobileWallet,@"repayment_amount":repayAmount} mutableCopy];
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
        NSString *urlString = [NSString stringWithFormat:@"userregistration/%@",[[NSUserDefaults standardUserDefaults] valueForKey:USERID]];
        [NetworkHelperClass sendAsynchronousRequestToServer:urlString httpMethod:GET requestBody:nil contentType:JSONCONTENTTYPE completion:^(id obj) {
            if (completionBlock) {
                completionBlock(obj);
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
@end
