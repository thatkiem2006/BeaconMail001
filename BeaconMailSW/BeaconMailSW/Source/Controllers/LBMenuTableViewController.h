//
//  LBMenuTableViewController.h
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBMenuItemModel.h"
#import "LBMenuLeftCell.h"

@interface LBMenuTableViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *btnEdit;
- (IBAction)btnEditTouch:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
