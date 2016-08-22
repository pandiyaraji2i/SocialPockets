//
//  VerifyAadharViewController.m
//  SocialPockets
//
//  Created by ideas2it-Kovendhan on 10/08/16.
//  Copyright © 2016 Pandiyaraj. All rights reserved.
//

#import "VerifyAadharViewController.h"

@interface VerifyAadharViewController (){
    NSDictionary *obj;
}

@end

@implementation VerifyAadharViewController
@synthesize updateAadharView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    obj= @{
           @"name":@"Ganesh",
           @"fathername" : @"Muralidharan",
           @"yearofbirth" : @"1987",
           @"gender" : @"Male",
           @"address" : @"no :1 , fourth cross street , Krishna nagar, Pammal, Chennai "
           
           };
    self.nameLbl.text = [[[self.userDetails objectForKey:@"_name"] componentsSeparatedByString:@" "] objectAtIndex:0];
    self.fatherLbl.text = [[[self.userDetails objectForKey:@"_co"] componentsSeparatedByString:@" "] objectAtIndex:1];
    if ([[self.userDetails objectForKey:@"_gender"] isEqualToString:@"M"]) {
        self.genderLbl.text = @"Male";
    }else{
        self.genderLbl.text = @"Female";
    }
    self.genderLbl.text = [self.userDetails objectForKey:@"_gender"];
    self.dobLbl.text = [self.userDetails objectForKey:@"_yob"];
    self.addressLbl.text = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@",[self.userDetails objectForKey:@"_street"],[self.userDetails objectForKey:@"_lm"],[self.userDetails objectForKey:@"_loc"],[self.userDetails objectForKey:@"_dist"],[self.userDetails objectForKey:@"_state"],[self.userDetails objectForKey:@"_pc"]];
    
    //self.aadharNumderLbl.text = [self.userDetails objectForKey:@"_uid"];
    self.aadharNumderLbl.text = [self resetCardNumberAsVisa: [self.userDetails objectForKey:@"_uid"]];

}

- (NSString *)resetCardNumberAsVisa:(NSString*)originalString {
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
    [self dismissViewControllerAnimated:YES completion:nil];
    if (updateAadharView) {
        updateAadharView(obj);
    }
    // [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)noBtnTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
