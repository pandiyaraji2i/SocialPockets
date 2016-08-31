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
//    QRCodeReader *qrCodeView;
    UILabel *statusLbl;
}

@end

@implementation QRScanViewController
@synthesize updateAadharView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"QRCode Scanner";
    self.transprantView.hidden = YES;
    self.verifyAadharView.hidden = YES;
    // Do any additional setup after loading the view.
//    qrCodeView = [[QRCodeReader alloc]initWithFrame:CGRectMake(0, 114, self.view.frame.size.width, self.view.frame.size.height-178)];
    UILabel *QRTitleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 50)];
    QRTitleLbl.text = @"Scan your QR code";
    QRTitleLbl.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:QRTitleLbl];
    
    statusLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-50, self.view.frame.size.width, 50)];
    statusLbl.text = @"Scanning.....";
    statusLbl.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:statusLbl];
//    [qrCodeView setDelegate:self];
    statusLbl.text = @"Please focus your QR Code";
//    [qrCodeView startReading];
//    [self.view addSubview:qrCodeView];
    self.yesBtn.layer.cornerRadius = 5.0;
    self.noBtn.layer.cornerRadius = 5.0;
    self.noBtn.layer.borderWidth = 1.0;
    self.noBtn.layer.borderColor = [UIColor grayColor].CGColor;
    
    self.noBtn.layer.borderColor = [UIColor colorWithRed:136/255 green:136/255 blue:136/255 alpha:1].CGColor;
    
}


#pragma mark Verify Aadhar View Button Actions

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
//    [qrCodeView startReading];
}

#pragma mark Response from QR code

- (void)getQRCodeData:(id)qRCodeData {
    if ([[qRCodeData substringToIndex:1] isEqualToString:@"<"]) {
        userDict = [NSDictionary dictionaryWithXMLString:qRCodeData];
        NSLog(@"userDict ====%@",userDict);
        statusLbl.text = @"Scanning process completed";
        [ACTIVITY showActivity:@"Getting Data..."];
        [self performSelector:@selector(updateLabels) withObject:self afterDelay:2.0];
        
    }else{
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                 message:@"Please scan Aadhar QR code only"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action){
//                                                             [qrCodeView startReading];
                                                             
                                                         }] ;
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
        
        
        
    }
    
}
#pragma mark Helper Methods

-(void)updateLabels{
    [ACTIVITY performSelectorOnMainThread:@selector(hideActivity) withObject:nil waitUntilDone:YES];
    self.nameLbl.text = [[[userDict objectForKey:@"_name"] componentsSeparatedByString:@" "] objectAtIndex:0];
    self.fatherLbl.text = [[[userDict objectForKey:@"_co"] componentsSeparatedByString:@" "] objectAtIndex:1];
    if ([[userDict objectForKey:@"_gender"] isEqualToString:@"M"]) {
        self.genderLbl.text = @"Male";
    }else{
        self.genderLbl.text = @"Female";
    }
    self.dobLbl.text = [userDict objectForKey:@"_yob"];
    self.addressLbl.text = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@",[userDict objectForKey:@"_street"],[userDict objectForKey:@"_lm"],[userDict objectForKey:@"_loc"],[userDict objectForKey:@"_dist"],[userDict objectForKey:@"_state"],[userDict objectForKey:@"_pc"]];
    [self.addressLbl sizeToFit];
    
    
    //self.aadharNumderLbl.text = [self.userDetails objectForKey:@"_uid"];
    self.aadharNumderLbl.text = [self aadharNumberWithFormat: [userDict objectForKey:@"_uid"]];
    self.transprantView.hidden = NO;
    self.verifyAadharView.hidden = NO;
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
