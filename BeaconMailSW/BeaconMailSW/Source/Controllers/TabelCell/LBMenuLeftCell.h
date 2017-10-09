//
//  LBMenuLeftCell.h
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBMenuItemModel.h"


@interface LBMenuLeftCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *trashButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *badgeLabel;
@property (weak, nonatomic) IBOutlet UIButton *lockButton;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (strong, nonatomic) LBMenuItemModel *menuModel;

- (IBAction)trashButtonTouch:(id)sender;
- (IBAction)lockTouch:(id)sender;

- (void)setUpMenuItemInfo :(LBMenuItemModel *) model;

@property (nonatomic, assign) BOOL editItem;
@end
