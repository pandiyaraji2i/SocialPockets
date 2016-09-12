//
//  BaseViewController.m
//  CubeDemo
//
//  Created by Vikas Singh on 8/25/15.
//  Copyright (c) 2015 Vikas Singh. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initializeLayers];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - initializers

// Initialize the SDK layer viz CTSAuthLayer/CTSProfileLayer/CTSPaymentLayer
-(void)initializeLayers{
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    
    CTSKeyStore *keyStore = [[CTSKeyStore alloc] init];
    keyStore.signinId = SignInId;
    keyStore.signinSecret = SignInSecretKey;
    keyStore.signUpId = SubscriptionId;
    keyStore.signUpSecret = SubscriptionSecretKey;
    keyStore.vanity = VanityUrl;
    

    [CitrusPaymentSDK initializeWithKeyStore:keyStore environment:(PRODUCTIONMODE)?CTSEnvProduction:CTSEnvSandbox];

    [CitrusPaymentSDK enableDEBUGLogs];
    
    [CitrusPaymentSDK enableLoader];
    
    [CitrusPaymentSDK setLoaderColor:[UIColor orangeColor]];

    authLayer = [CTSAuthLayer fetchSharedAuthLayer];
    proifleLayer = [CTSProfileLayer fetchSharedProfileLayer];
    paymentLayer = [CTSPaymentLayer fetchSharedPaymentLayer];

    contactInfo = [[CTSContactUpdate alloc] init];
    contactInfo.firstName = USERINFO.user_name;
    contactInfo.lastName = USERINFO.user_name;
    contactInfo.email = @"kreonfintech@gmail.com";
    contactInfo.mobile = USERINFO.user_name;
    
    addressInfo = [[CTSUserAddress alloc] init];
    addressInfo.city = @"Chennai";
    addressInfo.country = @"India";
    addressInfo.state = @"TamilNadu";
    addressInfo.street1 = @"RR Towers 5, TVK Industrial Estate";
    addressInfo.street2 = @"Guindy";
    addressInfo.zip = @"600032";
    
    customParams = @{
                     @"USERDATA2":@"MOB_RC|9988776655",
                     @"USERDATA10":@"test",
                     @"USERDATA4":@"MOB_RC|test@gmail.com",
                     @"USERDATA3":@"MOB_RC|4111XXXXXXXX1111",
                     };
}

@end
