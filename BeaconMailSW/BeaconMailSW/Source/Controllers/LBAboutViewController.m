//
//  LBAboutViewController.m
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

#import "LBAboutViewController.h"
#import "LBTutorialViewController.h"
@interface LBAboutViewController ()

@end

@implementation LBAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void) initLocalizable{
    self.policyLabel.text = NSLocalizedString(@"about_detail_privacy_policy", nil);
    [self.termServiceButton setTitle:NSLocalizedString(@"about_term_service", nil) forState:UIControlStateNormal];
    [self.policyButton setTitle:NSLocalizedString(@"about_privacy_policy", nil) forState:UIControlStateNormal];
    self.receivedBackgroundLabel.text = NSLocalizedString(@"about_receive_background", nil);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [self loadSettingGetMailBG];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"goToTermPolicy"]) {
        LBTutorialViewController * detailVC = segue.destinationViewController;
        detailVC.type = 0;
    }
    if ([segue.identifier isEqualToString:@"goToTermOfUse"]) {
        LBTutorialViewController * detailVC = segue.destinationViewController;
        detailVC.type = 1;
    }
}

- (void)loadSettingGetMailBG {

}

- (IBAction)getMailBGSwichChanged:(id)sender {
    BOOL isSeleted = [self.getMailBGSwich isOn];

    [[NSUserDefaults standardUserDefaults] synchronize];
    [self loadSettingGetMailBG];

}
@end
