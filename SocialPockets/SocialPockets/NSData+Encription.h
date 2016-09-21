//
//  NSData+Encription.h
//  SingleSign
//
//  Created by neo on 8/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Encription)
- (NSData *)AES256EncryptWithKey:(NSString *)key;
- (NSData *)AES256DecryptWithKey:(NSString *)key;
- (NSData *)AES256EncryptWithComputedHash:(NSData *)keyData withInitialitionVector:(NSData *)ivData;
- (NSData *)AES256DecryptWithComputedHash:(NSData *)keyData withivPtr:(NSData *)ivData;
- (NSString *)base64EncodedString;
+ (NSData *)dataFromBase64String:(NSString *)aString;
@end
