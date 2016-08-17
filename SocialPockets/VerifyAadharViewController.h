//
//  VerifyAadharViewController.h
//  SocialPockets
//
//  Created by ideas2it-Kovendhan on 10/08/16.
//  Copyright © 2016 Pandiyaraj. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^updateAadharCard)(id);

@interface VerifyAadharViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *fatherLbl;
@property (weak, nonatomic) IBOutlet UILabel *dobLbl;
@property (weak, nonatomic) IBOutlet UILabel *genderLbl;
@property (weak, nonatomic) IBOutlet UILabel *addressLbl;
@property (weak, nonatomic) IBOutlet UILabel *aadharNumderLbl;
@property(nonatomic,copy)updateAadharCard updateAadharView;

@end
