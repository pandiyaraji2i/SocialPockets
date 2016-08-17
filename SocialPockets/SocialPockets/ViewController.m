//
//  ViewController.m
//  SocialPockets
//
//  Created by Pandiyaraj on 18/07/16.
//  Copyright © 2016 Pandiyaraj. All rights reserved.
//

#import "ViewController.h"

#import "LoginViewController.h"
#import "RegistrationViewController.h"
#import "ManageAccountsViewController.h"
#import "ProgressViewController.h"

@interface ViewController ()<UIScrollViewDelegate>
{
    UIView *subView;
    UIPageControl *pageControl;
    UIScrollView *scrollView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@" " style:UIBarButtonItemStylePlain target:self action:nil];
    
    pageTitles = @[@"Rating user according to social feeds", @"Instant loans for user", @"Social sites liabalize", @"Mobile wallet to get loan and repay"];
    pageImages = @[@"rating.jpg", @"loan.jpg", @"Social.jpg", @"mobile pocket.jpg"];
    
    //#-- Edit By Pandi
    int count = (int)pageImages.count;
    subView = [[UIView alloc]initWithFrame:CGRectMake(20, 150, (self.view.frame.size.width-40), self.view.frame.size.height-240)];
    subView.backgroundColor = [UIColor whiteColor];
    subView.layer.cornerRadius = 5.0;
    subView.layer.masksToBounds = YES;
    
    CGRect scrollViewFrame = CGRectMake(0, 0, subView.frame.size.width,subView.frame.size.height-50);
    scrollView = [[UIScrollView alloc] initWithFrame:scrollViewFrame];
    scrollView.delegate = self;
    [subView addSubview:scrollView];
    CGSize scrollViewContentSize = CGSizeMake(subView.frame.size.width*count, scrollView.frame.size.height);
    [scrollView setContentSize:scrollViewContentSize];
    
    int x = 10;
    for (int pageIndex = 0; pageIndex < pageImages.count; pageIndex ++) {
    
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(x, 10, scrollView.frame.size.width - 20, scrollView.frame.size.height - 100)];
        imgView.image =[UIImage imageNamed:pageImages[pageIndex]];
        [scrollView addSubview:imgView];
        
        UILabel *label  = [[UILabel alloc] initWithFrame:CGRectMake(x, CGRectGetMaxY(imgView.frame)+20,imgView.frame.size.width, 50)];
        label.text = pageTitles[pageIndex];
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        [scrollView addSubview:label];
       
        x = x + scrollView.frame.size.width;

    }
    [scrollView setPagingEnabled:YES];
    scrollView.showsHorizontalScrollIndicator = NO;
   
    pageControl = [[UIPageControl alloc] init];
    pageControl.frame = CGRectMake(subView.frame.size.width/2-100,CGRectGetMaxY(scrollView.frame),200,30);
    pageControl.numberOfPages = count;
    pageControl.currentPage = 0;
    [pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    [subView addSubview:pageControl];
    pageControl.backgroundColor = [UIColor blackColor];
    
    //#-- Status Bar Color Change
    [self setNeedsStatusBarAppearanceUpdate];
   
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView2 {
    CGFloat pageWidth = scrollView2.frame.size.width; // you need to have a **iVar** with getter for scrollView
    float fractionalPage = scrollView2.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    pageControl.currentPage = page; // you need to have a **iVar** with getter for pageControl
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.view addSubview:subView];
    [self.view bringSubviewToFront:subView];
}
- (void)changePage:(int)index
{
    CGFloat x = pageControl.currentPage * scrollView.frame.size.width;
    [scrollView setContentOffset:CGPointMake(x, 0) animated:YES];
}
- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}
- (IBAction)loginButtonAction:(id)sender
{
    LoginViewController *loginVc =[self.storyboard instantiateViewControllerWithIdentifier:@"LoginVc"];
    [self.navigationController pushViewController:loginVc animated:YES];
    
}

- (IBAction)registerButtonAction:(id)sender
{
    
        ProgressViewController *progressVc =[self.storyboard instantiateViewControllerWithIdentifier:@"ProgressVc"];
        [self.navigationController pushViewController:progressVc animated:YES];
    
//    ErrorMessageWithTitle(@"Message", @"In Progress");
//    RegistrationViewController *registerVc =[self.storyboard instantiateViewControllerWithIdentifier:@"registerVc"];
//    [self.navigationController pushViewController:registerVc animated:YES];
}

#pragma mark Status Bar Style
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}
@end
