//
//  ViewController.m
//  KOSignature
//
//  Created by ideas2it-Kovendhan on 20/07/16.
//  Copyright © 2016 ideas2it. All rights reserved.
//

#import "SignatureViewController.h"

@interface SignatureViewController ()
@property (weak, nonatomic) IBOutlet UIButton *getSignatureImage;

@end

@implementation SignatureViewController
@synthesize myActionBlock;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Signature";
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *clearButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Clear"
                                   style:UIBarButtonItemStyleDone
                                   target:self
                                   action:@selector(clearImageBtnPressed:)];
    self.navigationItem.rightBarButtonItem = clearButton;

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
#pragma mark - Buton Action Events

- (IBAction)getImageBtnPressed:(id)sender
{
    if (self.myActionBlock) {
        self.myActionBlock([self.signatureView getSignatureImage]);
    }
//    [REGMACRO verifyOTPForPhoneNumber:self.phoneNumber generatedCode:otpTextField.text completion:^(id obj) {
//        NSLog(@"OTP verification :%@",obj);
//    }];
    [self.navigationController popViewControllerAnimated:YES];
    
    //ImageViewController *imageController = [[ImageViewController alloc] initWithNibName:@"ImageViewController" bundle:nil];
    //imageController.image = [signatureView getSignatureImage];
   // if(imageController.image){
    //    [self.navigationController pushViewController:imageController animated:YES];
    //}
}
- (IBAction)clearImageBtnPressed:(id)sender
{
    [_signatureView clearSignature];
}


@end
