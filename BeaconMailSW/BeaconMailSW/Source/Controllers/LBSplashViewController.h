//
//  LBSplashViewController.h
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <UserNotifications/UserNotifications.h>



@interface LBSplashViewController : UIViewController<UIApplicationDelegate>
@property (weak, nonatomic) IBOutlet UIButton *tryAgainButton;
- (IBAction)tryAgainTouch:(id)sender;

@property (strong, nonatomic) CLBeaconRegion *beaconRegion;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end
