//
//  ViewController.h
//  KOSignature
//
//  Created by ideas2it-Kovendhan on 20/07/16.
//  Copyright © 2016 ideas2it. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignatureView.h"
typedef void  (^MyActionBlockType)(UIImage *);
typedef void (^UpdateSignature) (void);


@interface SignatureViewController : UIViewController
@property (nonatomic, copy) MyActionBlockType myActionBlock;
@property(nonatomic, copy)UpdateSignature updateSignatureView;
@property (weak, nonatomic) IBOutlet SignatureView *signatureView;

- (IBAction)getImageBtnPressed:(id)sender;
- (IBAction)clearImageBtnPressed:(id)sender;


@end

