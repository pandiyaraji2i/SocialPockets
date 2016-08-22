//
//  QRScanViewController.h
//  SocialPockets
//
//  Created by ideas2it-Kovendhan on 19/08/16.
//  Copyright © 2016 Pandiyaraj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QRCodeReaderFramework/QRCodeReaderFramework.h>
typedef void(^updateAadharCard)(id);


@interface QRScanViewController : UIViewController <QRCodeReaderDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *fatherLbl;
@property (weak, nonatomic) IBOutlet UILabel *dobLbl;
@property (weak, nonatomic) IBOutlet UILabel *genderLbl;
@property (weak, nonatomic) IBOutlet UILabel *addressLbl;
@property (weak, nonatomic) IBOutlet UILabel *aadharNumderLbl;
@property (weak, nonatomic) IBOutlet UIView *transprantView;

@property (weak, nonatomic) IBOutlet UIView *verifyAadharView;

@property(nonatomic,copy)updateAadharCard updateAadharView;
@property (weak, nonatomic) IBOutlet UIButton *yesBtn;

@property (weak, nonatomic) IBOutlet UIButton *noBtn;


@end
