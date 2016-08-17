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
@property (weak, nonatomic) IBOutlet UIImageView *signatureImageView;
@property (weak, nonatomic) IBOutlet UIView *SignView;

@end

@implementation SignatureViewController
@synthesize myActionBlock,updateSignatureView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Signature";
    // Do any additional setup after loading the view from its nib.
    NSLog(@" image data -- %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"SignatureImage"]);
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"SignatureImage"]) {
        self.SignView.hidden = NO;
        NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"SignatureImage"];
        self.signatureImageView.image = [UIImage imageWithData:imageData];
    }else{
        self.SignView.hidden  = YES;
        UIBarButtonItem *clearButton = [[UIBarButtonItem alloc]
                                        initWithTitle:@"Clear"
                                        style:UIBarButtonItemStyleDone
                                        target:self
                                        action:@selector(clearImageBtnPressed:)];
        self.navigationItem.rightBarButtonItem = clearButton;
    }
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
   UIImage *signImage = [self.signatureView getSignatureImage];
    [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(signImage) forKey:@"SignatureImage"];
    if (signImage) {
        [self.navigationController popViewControllerAnimated:YES];

    }

    if (self.myActionBlock) {
        self.myActionBlock([self.signatureView getSignatureImage]);
    }
    if (updateSignatureView) {
        updateSignatureView();
    }
}
- (IBAction)clearImageBtnPressed:(id)sender
{
    [_signatureView clearSignature];
}
- (IBAction)editBtnTapped:(id)sender {
    self.SignView.hidden = YES;
}
- (IBAction)closeBtnTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
