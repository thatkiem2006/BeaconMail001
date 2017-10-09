//
//  LBAboutViewController.h
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBAboutViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISwitch *getMailBGSwich;
- (IBAction)getMailBGSwichChanged:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *policyLabel;
@property (weak, nonatomic) IBOutlet UIButton *termServiceButton;
@property (weak, nonatomic) IBOutlet UIButton *policyButton;
@property (weak, nonatomic) IBOutlet UILabel *receivedBackgroundLabel;

@end
