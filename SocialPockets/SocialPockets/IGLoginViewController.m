//
//  LoginViewController.m
//  InstagramUnsignedAuthentication
//
//  Created by user on 11/13/14.
//  Copyright (c) 2014 Neuron. All rights reserved.
//

#import "IGLoginViewController.h"
#import "AppDelegate.h"

@interface IGLoginViewController ()

@end

@implementation IGLoginViewController
@synthesize typeOfAuthentication;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    NSString* authURL = nil;
    
    if ([typeOfAuthentication isEqualToString:@"UNSIGNED"])
    {
         authURL = [NSString stringWithFormat: @"%@?client_id=%@&redirect_uri=%@&response_type=token&scope=%@&DEBUG=True",
         INSTAGRAM_AUTHURL,
         INSTAGRAM_CLIENT_ID,
         INSTAGRAM_REDIRECT_URI,
         INSTAGRAM_SCOPE];

    }
    else
    {
         authURL = [NSString stringWithFormat: @"%@?client_id=%@&redirect_uri=%@&response_type=code&scope=%@&DEBUG=True",
                             INSTAGRAM_AUTHURL,
                             INSTAGRAM_CLIENT_ID,
                             INSTAGRAM_REDIRECT_URI,
                             INSTAGRAM_SCOPE];
    }
    
    
    [loginWebView loadRequest: [NSURLRequest requestWithURL: [NSURL URLWithString: authURL]]];
    [loginWebView setDelegate:self];
    
}


#pragma mark -
#pragma mark delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
    return [self checkRequestForCallbackURL: request];
}

- (void) webViewDidStartLoad:(UIWebView *)webView
{
    [loginIndicator startAnimating];
    loadingLabel.hidden = NO;
    [loginWebView.layer removeAllAnimations];
    loginWebView.userInteractionEnabled = NO;
    [UIView animateWithDuration: 0.1 animations:^{
      //  loginWebView.alpha = 0.2;
    }];
}

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    [loginIndicator stopAnimating];
    loadingLabel.hidden = YES;
    [loginWebView.layer removeAllAnimations];
    loginWebView.userInteractionEnabled = YES;
    [UIView animateWithDuration: 0.1 animations:^{
        //loginWebView.alpha = 1.0;
    }];
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self webViewDidFinishLoad: webView];
}

#pragma mark -
#pragma mark auth logic


- (BOOL) checkRequestForCallbackURL: (NSURLRequest*) request
{
    NSString* urlString = [[request URL] absoluteString];
    
    if ([typeOfAuthentication isEqualToString:@"UNSIGNED"])
    {
        // check, if auth was succesfull (check for redirect URL)
          if([urlString hasPrefix: INSTAGRAM_REDIRECT_URI])
         {
             // extract and handle access token
             NSRange range = [urlString rangeOfString: @"#access_token="];
             [self handleAuth: [urlString substringFromIndex: range.location+range.length]];
             return NO;
         }
    }
    else
    {
        if([urlString hasPrefix: INSTAGRAM_REDIRECT_URI])
        {
            // extract and handle access token
            NSRange range = [urlString rangeOfString: @"code="];
            [self makePostRequest:[urlString substringFromIndex: range.location+range.length]];
            return NO;
        }
    }
    
    return YES;
}

-(void)makePostRequest:(NSString *)code
{
    
    NSString *post = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&grant_type=authorization_code&redirect_uri=%@&code=%@",INSTAGRAM_CLIENT_ID,INSTAGRAM_CLIENTSERCRET,INSTAGRAM_REDIRECT_URI,code];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSMutableURLRequest *requestData = [NSMutableURLRequest requestWithURL:
                                        [NSURL URLWithString:@"https://api.instagram.com/oauth/access_token"]];
    [requestData setHTTPMethod:@"POST"];
    [requestData setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [requestData setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [requestData setHTTPBody:postData];
    
    NSURLResponse *response = NULL;
    NSError *requestError = NULL;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:requestData returningResponse:&response error:&requestError];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    [self handleAuth:[dict valueForKey:@"access_token"]];
    
}

- (void) handleAuth: (NSString*) authToken
{
    NSLog(@"successfully logged in with Tocken == %@",authToken);
    
    [self dismissViewControllerAnimated:true completion:nil];
    if (self.onLogin){
        self.onLogin(authToken);
    }
    
}


@end
