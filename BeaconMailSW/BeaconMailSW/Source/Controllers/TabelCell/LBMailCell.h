//
//  LBMailCell.h
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBMailModel.h"

@interface LBMailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *updateDateLabel;
@property (weak, nonatomic) IBOutlet UIView *viewNumberUnreadMessage;
@property (weak, nonatomic) IBOutlet UILabel *subjectLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

- (void)setUpMailInfo :(LBMailModel *) model;

@end
