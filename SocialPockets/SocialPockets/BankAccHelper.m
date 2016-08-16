//
//  BankAccHelper.m
//  SocialPockets
//
//  Created by Ideas2IT-GaneshM on 21/07/16.
//  Copyright © 2016 Pandiyaraj. All rights reserved.
//

#import "BankAccHelper.h"
static BankAccHelper* _sharedInstance = nil;

@implementation BankAccHelper

/**
 *  Create Singleton instance of class
 *
 *  @return Self Class
 */

+ (BankAccHelper *)sharedInstance
{
    @synchronized ([BankAccHelper class]) {
        if(!_sharedInstance)
            _sharedInstance = [[self alloc] init];
        return _sharedInstance;
    }
    return nil;
}


- (void)createBankAccountForUserId:(NSString *)userId bankName:(NSString *)bankName ifscCode:(NSString *)ifscCode accountNumber:(NSString*)accountNumber branchName:(NSString *)branchName createdBy:(NSString *)createdBy completion:(void (^)(id obj))completionBlock
{
    if([NetworkHelperClass getInternetStatus:YES]){
        NSMutableDictionary *dict =[@{@"userid":userId,@"bank_name":bankName,@"ifsc_code":ifscCode,@"account_number":accountNumber,@"branch":branchName,@"created_by":createdBy}mutableCopy];
        [NetworkHelperClass sendAsynchronousRequestToServer:@"createCreditAccount" httpMethod:POST requestBody:dict contentType:JSONCONTENTTYPE completion:^(id obj) {
            if(completionBlock){
                completionBlock(obj);
            }
        }];
//        id successObject = [NetworkHelperClass sendSynchronousRequestToServer:@"createCreditAccount" httpMethod:POST requestBody:dict contentType:JSONCONTENTTYPE];
//        if (successObject){
//            if(completionBlock){
//                completionBlock(successObject);
//            }
//        }
    }
}


- (void)deleteBankAccountWithId:(NSString *)bankAccountId completion:(void (^)(id obj))completionBlock
{

    if([NetworkHelperClass getInternetStatus:YES]){
        NSMutableDictionary *dict =[@{@"bankAccount_id":bankAccountId,@"user_id":[[NSUserDefaults standardUserDefaults] valueForKey:USERID]}mutableCopy];
        [NetworkHelperClass sendAsynchronousRequestToServer:@"deleteCreditAccount" httpMethod:POST requestBody:dict contentType:JSONCONTENTTYPE completion:^(id obj) {
            if(completionBlock){
                completionBlock(obj);
            }
        }];
//        id successObject = [NetworkHelperClass sendSynchronousRequestToServer:@"/deleteCreditAccount" httpMethod:POST requestBody:dict contentType:JSONCONTENTTYPE];
//        if (successObject){
//            if(completionBlock){
//                completionBlock(successObject);
//            }
//        }
    }
}

- (void)showAllAccountWithcompletion:(void (^)(id obj))completionBlock
{
    NSString *urlString = [NSString stringWithFormat:@"showAllCreditAccount?user_id=%@",[[NSUserDefaults standardUserDefaults] valueForKey:USERID]];
    [NetworkHelperClass sendAsynchronousRequestToServer:urlString httpMethod:GET requestBody:nil contentType:JSONCONTENTTYPE completion:^(id obj) {
        if (completionBlock) {
            completionBlock(obj);
        }
    }];
//        id successObject = [NetworkHelperClass sendSynchronousRequestToServer: httpMethod:GET requestBody:nil contentType:JSONCONTENTTYPE];
//        if (successObject)
//        {
//            if(completionBlock)
//            {
//                completionBlock(successObject);
//            }
//        }
}

@end
