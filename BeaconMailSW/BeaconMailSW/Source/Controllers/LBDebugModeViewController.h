//
//  LBDebugModeViewController.h
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBDebugModeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
@property (weak, nonatomic) IBOutlet UIButton *xmlConfigOptionButton1;
@property (weak, nonatomic) IBOutlet UIButton *xmlConfigOptionButton2;
@property (weak, nonatomic) IBOutlet UIButton *xmlConfigOptionButton3;
- (IBAction)xmlConfigOptionButtonTouch:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
- (IBAction)saveButtonTouch:(id)sender;

@end
