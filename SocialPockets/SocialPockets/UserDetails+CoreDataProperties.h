//
//  UserDetails+CoreDataProperties.h
//  SocialPockets
//
//  Created by Pandiyaraj on 11/08/16.
//  Copyright © 2016 Pandiyaraj. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "UserDetails.h"
#import "TransactionHistory.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserDetails (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *userId;
@property (nullable, nonatomic, retain) NSString *user_eligible_status;
@property (nullable, nonatomic, retain) NSString *user_email;
@property (nullable, nonatomic, retain) NSString *user_phone_number;
@property (nullable, nonatomic, retain) NSString *user_name;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSSet<TransactionHistory *> *userTransactions;

@end

@interface UserDetails (CoreDataGeneratedAccessors)

- (void)addUserTransactionsObject:(TransactionHistory *)value;
- (void)removeUserTransactionsObject:(TransactionHistory *)value;
- (void)addUserTransactions:(NSSet<TransactionHistory *> *)values;
- (void)removeUserTransactions:(NSSet<TransactionHistory *> *)values;

@end

NS_ASSUME_NONNULL_END
