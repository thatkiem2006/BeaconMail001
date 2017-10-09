//
//  LBStatusManagerTabbarViewController.m
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

#import "LBStatusManagerTabbarViewController.h"
#import "LBStatusScreenViewController.h"
#import "LBIBeaconMonitorTableViewController.h"
#import "LBGeoFenceMonitorTableViewController.h"
@interface LBStatusManagerTabbarViewController ()<UITabBarControllerDelegate>

@end

@implementation LBStatusManagerTabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
}

- (void)showTitle:(NSNotification *)noti {
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:      (UIViewController *)viewController
{
    NSLog(@"Selected index: %lu", (unsigned long)tabBarController.selectedIndex);
}
@end
