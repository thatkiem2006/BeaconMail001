//
//  LBWebAppViewController.h
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBMailAccountModel.h"
#import "LBListMailViewController.h"

#import "LBWebModel.h"

@interface LBWebAppViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *previousButton;
- (IBAction)refreshButtonTouch:(id)sender;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *loadMailButton;


- (IBAction)previousButtonTouch:(id)sender;
- (IBAction)loadMailTouch:(id)sender;
- (IBAction)nextButtonTouch:(id)sender;

@property (nonatomic,assign) int mailAccountId;
@property (nonatomic, strong) LBMailAccountModel *mailAccountModel;

@property (nonatomic, strong) LBWebModel *webModel;


@end
