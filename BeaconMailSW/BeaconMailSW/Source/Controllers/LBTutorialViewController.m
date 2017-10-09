//
//  LBTutorialViewController.m
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

#import "LBTutorialViewController.h"

@interface LBTutorialViewController (){
}

@end

@implementation LBTutorialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textView.scrollEnabled = true;

    NSString* path;
   
    if(self.type == 0){
        self.title = NSLocalizedString(@"tutorial_term_conditions", nil);
        
        path = [[NSBundle mainBundle] pathForResource:NSLocalizedString(@"tutorial_term_service_html", nil) ofType:@"html"];
        
    }else if(self.type == 1){
        self.title = NSLocalizedString(@"tutorial_policy", nil);
        path = [[NSBundle mainBundle] pathForResource:NSLocalizedString(@"tutorial_policy_content_html", nil) ofType:@"html"];
    }
    
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:path];
    NSData *htmlData = [NSData dataWithContentsOfURL:fileURL];

    
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithData:htmlData options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)} documentAttributes:nil error:nil];
    
    self.textView.attributedText =attrString;
    

    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"Custom"
                                                                 style:UIBarButtonItemStylePlain
                                                                target:nil
                                                                action:nil];
    
    [self.navigationItem setBackBarButtonItem:backItem];
   // [self.navigationController a]
    // Do any additional setup after loading the view.
    
}

-(void)viewWillAppear:(BOOL)animated{

   
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
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}
@end
