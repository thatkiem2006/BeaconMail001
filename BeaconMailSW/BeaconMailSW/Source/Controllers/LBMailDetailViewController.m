//
//  LBMailDetailViewController.m
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

#import "LBMailDetailViewController.h"
#import "LBShareInfoModel.h"

@interface LBMailDetailViewController ()
{
    
}
@end

@implementation LBMailDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"viewDidLoad");
    [self initLocalizable];
    // Do any additional setup after loading the view.
}

-(void)initLocalizable {
    [self.webButton setTitle:NSLocalizedString(@"bottom_bar_web_view", nil) forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated{
    NSLog(@"viewWillAppear");
    [self setUpInboxDetail:self.modelMail];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpInboxDetail :(LBMailModel *) model{
    //    self.mailInfo?.beacon = self.beaconInfo
    
    self.modelMail = model;
    //    self.mailInfo?.geofence = self.geofence
    self.subjectLabel.text = model.subject;
    //[self.subjectLabel.sizeToFit()];

    if(model.messageDescription.length > 0){
        [self.contentWebView loadHTMLString:model.messageDescription baseURL:nil];
        self.contentWebView.scalesPageToFit = FALSE;
    }else{
        [self.contentWebView loadHTMLString:model.message baseURL:nil];
        self.contentWebView.scalesPageToFit = FALSE;
        
    }

    self.webButton.hidden = true;
 
    UIBarButtonItem  *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share:)];
    self.navigationItem.rightBarButtonItem = shareButton;
}

- (void)share:(id)sender {
   
    NSString * title =[NSString stringWithFormat:@"%@",self.modelMail.subject];
    NSString * content =[NSString stringWithFormat:@"%@",self.modelMail.messageDescription];
    
    NSArray* dataToShare = @[title,content,@""];
    
    UIActivityViewController *activityViewControntroller = [[UIActivityViewController alloc] initWithActivityItems:dataToShare applicationActivities:nil];
    activityViewControntroller.excludedActivityTypes = @[];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        activityViewControntroller.popoverPresentationController.sourceView = self.view;
        activityViewControntroller.popoverPresentationController.sourceRect = CGRectMake(self.view.bounds.size.width/2, self.view.bounds.size.height/4, 0, 0);
    }
    [self presentViewController:activityViewControntroller animated:true completion:nil];
}

- (void)shareText:(NSString *)text andImage:(UIImage *)image andUrl:(NSURL *)url
{
    NSMutableArray *sharingItems = [NSMutableArray new];
    if (text) {
        [sharingItems addObject:text];
    }
    if (image) {
        [sharingItems addObject:image];
    }
    if (url) {
        [sharingItems addObject:url];
    }
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:sharingItems applicationActivities:nil];
    [self presentViewController:activityController animated:YES completion:nil];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)addFavoriteButtonTouch:(id)sender {

   
}
- (IBAction)webButtonTouch:(id)sender {
}
- (IBAction)buttonDeleteTouch:(id)sender {
    
}
@end
