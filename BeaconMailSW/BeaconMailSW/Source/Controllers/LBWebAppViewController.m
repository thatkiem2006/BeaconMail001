//
//  LBWebAppViewController.m
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

#import "LBWebAppViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface LBWebAppViewController ()<UIWebViewDelegate>

@end

@implementation LBWebAppViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   // self.title = self.mailAccountModel.name;
    self.nextButton.hidden = true;
    self.previousButton.hidden = true;
    // Do any additional setup after loading the view.
   
    self.webView.delegate = self;
    [self loadData];
   
    
    NSURL *imageUrl = [NSURL URLWithString:self.webModel.iconUrl];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];

    self.navigationItem.leftBarButtonItem = [self makeDefaultLeftBtn];

    
    [self.loadMailButton setTitle:NSLocalizedString(@"bottom_bar_web_view", nil) forState:UIControlStateNormal];

}


- (UIBarButtonItem*)makeDefaultRigthBtn {    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"edit", nil) style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClick:)];
    return rightBtn;
}

- (UIBarButtonItem*)makeDefaultLeftBtn {
    UIBarButtonItem *barBtn  = [[UIBarButtonItem alloc] initWithCustomView:nil];
    //    barBtn.customView.backgroundColor = LB_COLOR_BLACK;
    return barBtn;
}

- (IBAction) rightBtnClick: (id)sender
{
    NSLog(@"");
}

- (void)loadData{
    NSString *urlString = self.webModel.url;
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:urlRequest];
}

- (void)viewWillAppear:(BOOL)animated{
    //UIWebView *webView = [[UIWebView alloc]init];
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

- (IBAction)loadMailTouch:(id)sender {

}

- (IBAction)refreshButtonTouch:(id)sender {
    NSString *urlString = self.webModel.url;
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:urlRequest];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
   // NSLog(@"canGoForward %d canGoBack %d",[self.webView canGoForward],[self.webView canGoBack]);
    [self loadStateWebActionButton];
    //NSLog(@"WebView Height: %.1f", self.webView.frame.size.height);
}

- (void)loadStateWebActionButton {
    self.nextButton.hidden = ![self.webView canGoForward];
    self.previousButton.hidden = ![self.webView canGoBack];
}

- (IBAction)previousButtonTouch:(id)sender {
    //NSLog(@"previousButtonTouch");
    
    if ([self.webView canGoBack])
    {
        [self.webView goBack];
    }
    [self loadStateWebActionButton];
}

- (IBAction)nextButtonTouch:(id)sender {
  //  NSLog(@"nextButtonTouch");
    if ([self.webView canGoForward])
    {
        [self.webView goForward];
    }
    [self loadStateWebActionButton];
}
@end
