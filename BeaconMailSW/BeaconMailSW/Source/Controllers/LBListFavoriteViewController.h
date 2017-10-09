//
//  LBListFavoriteViewController.h
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBMailModel.h"
#import "LBMailCell.h"
#import "LBMailDetailViewController.h"

@interface LBListFavoriteViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *noMailList;
@property (weak, nonatomic) IBOutlet UIView *bottomBarView;
@property (nonatomic, strong) UIActivityIndicatorView *loadMoreActivityView;
@property (nonatomic, assign) BOOL isEditTableView;
- (IBAction)deleteButtonTouch:(id)sender;

@end
