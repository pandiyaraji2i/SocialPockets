//
//  TransactionHistory+CoreDataProperties.h
//  SocialPockets
//
//  Created by Pandiyaraj on 11/08/16.
//  Copyright © 2016 Pandiyaraj. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "TransactionHistory.h"

NS_ASSUME_NONNULL_BEGIN

@interface TransactionHistory (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *loanId;
@property (nullable, nonatomic, retain) id loanObject;
@property (nullable, nonatomic, retain) UserDetails *transctionToUser;

@end

NS_ASSUME_NONNULL_END
