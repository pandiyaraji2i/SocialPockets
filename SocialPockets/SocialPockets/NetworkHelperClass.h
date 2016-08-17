//
//  NetworkHelperClass.h
//  SocialPockets
//
//  Created by Pandiyaraj on 13/07/16.
//  Copyright © 2016 Pandiyaraj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import <UIKit/UIKit.h>
@interface NetworkHelperClass : NSObject

+ (id)sendSynchronousRequestToServer:(NSString *)actionName httpMethod:(NSString *)httpMethod requestBody:(id)body contentType:(NSString *)contentType;

+ (void)sendAsynchronousRequestToServer:(NSString *)actionName httpMethod:(NSString *)httpMethod requestBody:(id)body contentType:(NSString *)contentType completion:(void (^)(id obj))completionBlock;

+ (BOOL)getInternetStatus:(BOOL)shouldShowMessage;
+ (void)uploadImage:(UIImage *)image isUserOrLoan:(int)isUserOrLoan userId:(NSString *)userId  sync:(BOOL)isSync completion:(void (^)(id obj))completionBlock;
+ (void)downloadImage:(NSURL *)url withUserId:(NSString *)userId completionBlock:(void (^)(id obj))completionBlock;
@end
