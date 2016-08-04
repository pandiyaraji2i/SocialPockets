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

/**
 *  Mobile wallet creation for the user
 *
 *  @param userdId         Userid for creation of wallet
 *  @param completionBlock <#completionBlock description#>
 */

- (void)mwalletForUserId:(NSString *)userId mobilewallet:(NSString *)mobilewallet createdBy:(NSString *)createdBy completion:(void (^)(id obj))completionBlock
{
    
    if([NetworkHelperClass getInternetStatus:YES]){
        NSMutableDictionary *dict =[@{@"userid":userId,@"mobilewalletid": mobilewallet,@"created_by":createdBy}mutableCopy];
        id successObject = [NetworkHelperClass sendSynchronousRequestToServer:@"/usermobilewallet" httpMethod:POST requestBody:dict contentType:JSONCONTENTTYPE];
        if (successObject){
            if(completionBlock){
                completionBlock(successObject);
            }
        }
    }
}

- (void)deletMwalletUserId:(NSString *)userdId mobilewallet:(NSString *)mobilewallet completion:(void (^)(id obj))completionBlock
{
    if ([NetworkHelperClass getInternetStatus:YES])
    {
        NSMutableDictionary *dict =[@{@"modified_by":userdId,@"usermobilewalletid":mobilewallet}mutableCopy];
        id successObject = [NetworkHelperClass sendSynchronousRequestToServer:@"/usermobilewallet/removeMobilewallet" httpMethod:POST requestBody:dict contentType:JSONCONTENTTYPE];
        if (successObject)
        {
            if(completionBlock)
            {
                completionBlock(successObject);
            }
        }
            
    }
    
}
- (void)showAllAccountWithcompletion:(void (^)(id obj))completionBlock
{
    if ([NetworkHelperClass getInternetStatus:YES])
    {
        id successObject = [NetworkHelperClass sendSynchronousRequestToServer:[NSString stringWithFormat:@"/showAllCreditAccount?user_id=%@",[[NSUserDefaults standardUserDefaults] valueForKey:USERID]] httpMethod:GET requestBody:nil contentType:JSONCONTENTTYPE];
        if (successObject)
        {
            if(completionBlock)
            {
                completionBlock(successObject);
            }
        }
        
    }
    
}

@end
