//
//  LBStatusScreenViewController.h
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBProfileModel.h"
#import "LBBeaconModel.h"
#import "LBGeofenceModel.h"
@interface LBStatusScreenViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *dfvTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *dayToLiveTextField;
@property (weak, nonatomic) IBOutlet UITextView *readRecipeUrlTextView;
@property (weak, nonatomic) IBOutlet UITableView *iBeaconTableView;
@property (weak, nonatomic) IBOutlet UITableView *geoFenceTableView;
@property (nonatomic, strong) LBProfileModel *profileModel;

@end
