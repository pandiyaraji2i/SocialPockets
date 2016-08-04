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

- (void)mwalletForUserId:(NSString *)userId mobilewallet:(NSString *)mobilewallet createdBy:(NSString *)createdBy completion:(void (^)(id obj))completionBlock;

- (void)deletMwalletUserId:(NSString *)userdId mobilewallet:(NSString *)mobilewallet completion:(void (^)(id obj))completionBlock;
- (void)showAllAccountWithcompletion:(void (^)(id obj))completionBlock;


@end
