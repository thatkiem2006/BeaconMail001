//
//  LBListMailDetectViewController.h
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LBMailAccountModel.h"
#import "LBMailCell.h"
#import "LBMailDetailViewController.h"
#import "LBWebAppViewController.h"
#import "LBCustomNavigationViewController.h"


#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>

#import <UserNotifications/UserNotifications.h>

@interface LBListMailDetectViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *noMailLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomBarView;
@property (weak, nonatomic) IBOutlet UIButton *addFavoriteButton;
- (IBAction)addFavoriteTouch:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *webButton;
- (IBAction)webButtonTouch:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
- (IBAction)deleteButtonTouch:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *leftMenu;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightButton;



@property (nonatomic, strong) NSArray *messages;
@property (nonatomic, strong) NSMutableDictionary *messagePreviews;

@property (nonatomic) NSInteger totalNumberOfInboxMessages;
@property (nonatomic) BOOL isLoading;
@property (nonatomic, strong) UIActivityIndicatorView *loadMoreActivityView;
@property (nonatomic, strong) LBMailAccountModel *mailAccountModel;
@property (nonatomic, assign) BOOL isEditTableView;
//@property (nonatomic) int mailAccountId;
@property (nonatomic, strong) NSString *mailAccountId;

@property (strong, nonatomic) CLBeaconRegion *beaconRegion;
@property (strong, nonatomic) CLLocationManager *locationManager;



@end
