//
//  SignatureView.h
//  KOSignature
//
//  Created by ideas2it-Kovendhan on 20/07/16.
//  Copyright © 2016 ideas2it. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignatureView : UIView
{
    CAShapeLayer *shapeLayer;
}

- (UIImage *)getSignatureImage;
- (void)clearSignature;

@end
