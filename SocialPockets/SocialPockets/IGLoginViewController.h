//
//  LoginViewController.h
//  InstagramUnsignedAuthentication
//
//  Created by user on 11/13/14.
//  Copyright (c) 2014 Neuron. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^onLoginSuccess)(id);
@interface IGLoginViewController : UIViewController<UIWebViewDelegate>
{
    IBOutlet UIWebView *loginWebView;
    IBOutlet UIActivityIndicatorView* loginIndicator;
    IBOutlet UILabel *loadingLabel;
}
@property (nonatomic,copy) onLoginSuccess onLogin;
@property(strong,nonatomic)NSString *typeOfAuthentication;
@end
