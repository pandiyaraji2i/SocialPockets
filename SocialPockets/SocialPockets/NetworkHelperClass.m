//
//  NetworkHelperClass.m
//  SocialPockets
//
//  Created by Pandiyaraj on 13/07/16.
//  Copyright © 2016 Pandiyaraj. All rights reserved.
//

#import "NetworkHelperClass.h"
#import "NSJSONSerialization+RemovingNulls.h"
#import "NSURLSession+SynchronousTask.h"
#import "Reachability.h"


static Reachability *reachability;

@implementation NetworkHelperClass

+ (NSURLSession *)getSessionWithContentType:(NSString *)contentType
{
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfiguration.HTTPAdditionalHeaders = @{@"Content-Type": contentType};
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    return session;
}

+ (NSMutableURLRequest *)getUrlRequest:(NSString *)actionName httpMethod:(NSString *)httpMethod requestBody:(id)body contentType:(NSString *)contentType
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",BASEURL,actionName];
    NSURL *requestUrl=[NSURL URLWithString:urlString]; // encode url if + or some symbols occurs in action name
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:requestUrl];
    request.HTTPMethod = httpMethod;
    request.timeoutInterval = 300;
    NSString *jsonString;
    NSError *error;
    if ([contentType isEqualToString:URLENCODEDCONTENTTYPE]) {
    }
    else
    {
        if (body) {
           NSData *jsonData = [NSJSONSerialization dataWithJSONObject:body
                                                               options:0
                                                                 error:&error];
            jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            if (!error) {
                [request setHTTPBody:jsonData];
            }
            NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[jsonData length]];
            [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
            [request setValue:contentType forHTTPHeaderField:@"Content-type"];
        }
    }
    [request setValue:@"Basic YWRtaW46YWRtaW4=" forHTTPHeaderField:@"Authorization"];
    return  request;
}

/**
 *  Get the data from API, send request to server
 *
 *  @param actionName      Action Name like : login
 *  @param httpMethod      Post or Get
 *  @param body            Parameters
 *  @param completionBlock response block from the server
 */

+ (void)sendAsynchronousRequestToServer:(NSString *)actionName httpMethod:(NSString *)httpMethod requestBody:(id)body contentType:(NSString *)contentType completion:(void (^)(id obj))completionBlock
{
    
    NSMutableURLRequest *request = [self getUrlRequest:actionName httpMethod:httpMethod requestBody:body contentType:contentType];
    NSURLSessionDataTask *postDataTask = [[self getSessionWithContentType:contentType] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)        {
        if (completionBlock) {
            id responseObj = [self getResponseBasedOnData:data response:response];
            completionBlock(responseObj);
        }
    }];
    [postDataTask resume];
}


+ (id)sendSynchronousRequestToServer:(NSString *)actionName httpMethod:(NSString *)httpMethod requestBody:(id)body contentType:(NSString *)contentType
{
    NSURLResponse *response;
    NSError *error;
    
    NSMutableURLRequest *request = [self getUrlRequest:actionName httpMethod:httpMethod requestBody:body contentType:contentType];
    NSData *responseData = [[self getSessionWithContentType:contentType] sendSynchronousDataTaskWithRequest:request returningResponse:&response error:&error];
    return [self getResponseBasedOnData:responseData response:response];
}

/**
 *  Get JSON OR String from the API Request
 *
 *  @param responseData response Data returned from the server
 *  @param response HttpResponse 
 *
 *  @return Connection is Reachable or Not
 */
+(id)getResponseBasedOnData:(NSData *)responseData response:(NSURLResponse *)response
{
    NSDictionary *contentType = [(NSHTTPURLResponse *)response allHeaderFields];
    if ([(NSHTTPURLResponse *)response statusCode] ==200) {
        //#-- Response accept type is json
        if ([[contentType valueForKey:@"Content-Type"] rangeOfString:JSONCONTENTTYPE].length) {
            id responseJson = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil removingNulls:YES ignoreArrays:NO];
            if (responseJson) {
                return responseJson;
            }
        }
        else{ //#-- Response accept type is string
            NSString *responseStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
            if (responseStr) {
                return responseStr;
            }
        }
        return @"Error in parsing";
    }else /*if ([(NSHTTPURLResponse *)response statusCode] == 422)*/
    {
        //#-- Request is successful but error in response
        id responseJson = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil removingNulls:YES ignoreArrays:NO];

        NSString *errorMessageTitle = [responseJson valueForKey:@"message"];
        NSString *errorMessage = [[[responseJson valueForKey:@"missing parameters"] valueForKey:USERID] objectAtIndex:0];
        NSLog(@"error message title %@ -- %@",errorMessageTitle,errorMessage);
        if (errorMessageTitle.length) {
          return errorMessageTitle;
        }else{
            return @"Error while send request";
        }
        
    }
//    else{
//        return @"Error while send request";
//    }
}

/**
 *  Upload image to the server
 *
 *  @param image           Image to send
 *  @param isUserOrLoan    IF 1 - User & 2 - Loan Process
 *  @param userId          Logged User id
 *  @param isSync          If yes - Sync else async
 *  @param completionBlock response back to the user
 */

+ (void)uploadImage:(UIImage *)image isUserOrLoan:(int)isUserOrLoan userId:(NSString *)userId  sync:(BOOL)isSync completion:(void (^)(id obj))completionBlock
{
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    NSString *urlString,*fileName;
    fileName = @"image";
    if (isUserOrLoan == 1) {
        urlString = [NSString stringWithFormat:@"%@/userregistration/uploadProfileFile?userid=%@",BASEURL,userId];
    }else{
        urlString = [NSString stringWithFormat:@"%@/userregistration/uploadProfileFileLoanRequest?loanid=%@",BASEURL,userId];
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:POST];
    
    NSString *boundary = [NSString stringWithFormat:@"---------------------------14737809831466499882746641449"];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    [request setValue:@"Basic YWRtaW46YWRtaW4=" forHTTPHeaderField:@"Authorization"];
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"profile_filename\"; filename=\"%@.png\"\r\n",fileName] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [request setHTTPBody:body];  //#-- If session means no need to add http body
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionUploadTask *uploadTask;
    if (!isSync) {
        uploadTask = [session uploadTaskWithRequest:request fromData:body completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                        id responseJson = [self getResponseBasedOnData:data response:response];
                        completionBlock (responseJson);
        }];
    }
    else{
        NSURLResponse *response;
        NSError *error;
        NSData *data = [session sendSynchronousUploadTaskWithRequest:request fromData:body returningResponse:&response error:&error];
        id responseJson = [self getResponseBasedOnData:data response:response];
        completionBlock (responseJson);
    }
    [uploadTask resume];

}

/**
 *  Checking Network Connection
 *
 *  @param shouldShowMessage IF yes show the pop up alert or not
 *
 *  @return Connection is Reachable or Not
 */
+ (BOOL)getInternetStatus:(BOOL)shouldShowMessage
{
    if (!reachability) {
        reachability =[Reachability reachabilityForInternetConnection];
        [reachability startNotifier];
    }
    NetworkStatus status=[reachability currentReachabilityStatus];
    
    if(status==NotReachable)
    {
        if (shouldShowMessage)
        {
            NSLog(@"Your device is not connected to the internet");
        }
        
    }
    return status!=NotReachable;
}
@end
