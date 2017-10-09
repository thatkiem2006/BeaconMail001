//
//  LBMailDetailViewController.h
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBMailModel.h"
@interface LBMailDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *updateDataLabel;
@property (weak, nonatomic) IBOutlet UILabel *subjectLabel;
@property (weak, nonatomic) IBOutlet UIWebView *contentWebView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorActivity;

@property (weak, nonatomic) IBOutlet UIButton *addFavoriteButton;
- (IBAction)addFavoriteButtonTouch:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *webButton;
- (IBAction)webButtonTouch:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
- (IBAction)buttonDeleteTouch:(id)sender;

- (void)setUpInboxDetail :(LBMailModel *) model;
@property (strong, nonatomic) LBMailModel *modelMail;
@end
