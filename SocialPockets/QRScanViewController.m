//
//  QRScanViewController.m
//  SocialPockets
//
//  Created by ideas2it-Kovendhan on 19/08/16.
//  Copyright © 2016 Pandiyaraj. All rights reserved.
//

#import "QRScanViewController.h"
#import "XMLParser.h"
#import "VerifyAadharViewController.h"

@interface QRScanViewController (){
    NSDictionary *userDict;
    QRCodeReader *qrCodeView;
}

@end

@implementation QRScanViewController
@synthesize updateAadharView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.transprantView.hidden = YES;
    self.verifyAadharView.hidden = YES;
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    qrCodeView = [[QRCodeReader alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [qrCodeView setDelegate:self];
    [qrCodeView startReading];
    [self.view addSubview:qrCodeView];
    self.yesBtn.layer.cornerRadius = 5.0;
    self.noBtn.layer.cornerRadius = 5.0;
    self.noBtn.layer.borderWidth = 1.0;
    self.noBtn.layer.borderColor = [UIColor grayColor].CGColor;

//    self.noBtn.layer.borderColor = [UIColor colorWithRed:136/255 green:136/255 blue:136/255 alpha:1].CGColor;

}

- (NSString *)aadharNumberWithFormat:(NSString*)originalString {
    NSMutableString *resultString = [NSMutableString string];
    
    for(int i = 0; i<[originalString length]/4; i++)
    {
        NSUInteger fromIndex = i * 4;
        NSUInteger len = [originalString length] - fromIndex;
        if (len > 4) {
            len = 4;
        }
        
        [resultString appendFormat:@"%@    ",[originalString substringWithRange:NSMakeRange(fromIndex, len)]];
    }
    return resultString;
}
- (IBAction)cancelBtnTapped:(id)sender {
    //[self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)yesBtntapped:(id)sender {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"AadharCardUpdate"];
    if (updateAadharView) {
        updateAadharView(userDict);
    }
    [self.navigationController popViewControllerAnimated:YES];
   
    // [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)noBtnTapped:(id)sender {
    self.transprantView.hidden = YES;
    self.verifyAadharView.hidden = YES;
    [qrCodeView startReading];
}


- (void)getQRCodeData:(id)qRCodeData {
    userDict = [NSDictionary dictionaryWithXMLString:qRCodeData];
    NSLog(@"userDict ====%@",userDict);
    [self updateLabelsWithDict:userDict];
  //    [self presentViewController:verifyAadharVc animated:YES completion:nil];
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"QR Code" message:qRCodeData preferredStyle:UIAlertControllerStyleAlert];
//    
//    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleDefault handler:nil];
//    [alertController addAction:cancel];
//    
//    UIAlertAction *reScan = [UIAlertAction actionWithTitle:@"Rescan" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [qrCodeView startReading];
//    }];
//    [alertController addAction:reScan];
//    [self presentViewController:alertController animated:YES completion:nil];
}
-(void)updateLabelsWithDict:(NSDictionary *)dict{
    self.nameLbl.text = [[[dict objectForKey:@"_name"] componentsSeparatedByString:@" "] objectAtIndex:0];
    self.fatherLbl.text = [[[dict objectForKey:@"_co"] componentsSeparatedByString:@" "] objectAtIndex:1];
    if ([[dict objectForKey:@"_gender"] isEqualToString:@"M"]) {
        self.genderLbl.text = @"Male";
    }else{
        self.genderLbl.text = @"Female";
    }
    self.dobLbl.text = [dict objectForKey:@"_yob"];
    self.addressLbl.text = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@",[dict objectForKey:@"_street"],[dict objectForKey:@"_lm"],[dict objectForKey:@"_loc"],[dict objectForKey:@"_dist"],[dict objectForKey:@"_state"],[dict objectForKey:@"_pc"]];
    
    //self.aadharNumderLbl.text = [self.userDetails objectForKey:@"_uid"];
    self.aadharNumderLbl.text = [self aadharNumberWithFormat: [dict objectForKey:@"_uid"]];
    self.transprantView.hidden = NO;
    self.verifyAadharView.hidden = NO;
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

@end
