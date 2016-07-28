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

@interface SignatureViewController : UIViewController
@property (nonatomic, copy) MyActionBlockType myActionBlock;
@property (weak, nonatomic) IBOutlet SignatureView *signatureView;

- (IBAction)getImageBtnPressed:(id)sender;
- (IBAction)clearImageBtnPressed:(id)sender;


@end

