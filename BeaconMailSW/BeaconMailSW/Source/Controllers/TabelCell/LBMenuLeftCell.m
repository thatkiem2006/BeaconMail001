
//
//  LBMenuLeftCell.m
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

#import "LBMenuLeftCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation LBMenuLeftCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUpMenuItemInfo :(LBMenuItemModel *) model{
    self.menuModel = model;
   
    self.nameLabel.text = model.title;
    
    [self.iconImageView setBounds:CGRectMake(0, 0, 32, 32)];
    [self.iconImageView setClipsToBounds:NO];
    [self.iconImageView setFrame:CGRectMake(0, 0, 32, 32)];
    [self.iconImageView setContentMode:UIViewContentModeScaleAspectFill];
    self.badgeLabel.layer.cornerRadius = self.badgeLabel.frame.size.height/2;
    self.badgeLabel.layer.masksToBounds = YES;

    self.trashButton.hidden = !model.editItem;
    self.lockButton.hidden = !model.editItem;
    if(!self.trashButton.hidden){
        self.badgeLabel.hidden = true;
        self.iconImageView.hidden = true;
    }else{
        self.badgeLabel.hidden = false;
        self.iconImageView.hidden = false;
    }
   
    if(model.badgeUnreadNumber > 0 && self.trashButton.hidden){
        self.badgeLabel.text = [NSString stringWithFormat:@"%d",model.badgeUnreadNumber];
        self.badgeLabel.hidden = false;
    }else{
        self.badgeLabel.hidden = true;
    }

}

- (IBAction)lockTouch:(id)sender {
    NSLog(@"lockTouch mail %d",self.menuModel.mailAccountId);
    self.trashButton.hidden = !self.trashButton.hidden;
    self.lockButton.hidden = !self.lockButton.hidden;
    if(!self.trashButton.hidden){
        self.badgeLabel.hidden = true;
        self.iconImageView.hidden = true;
    }else{
        self.badgeLabel.hidden = false;
        self.iconImageView.hidden = false;
    }
    if(self.menuModel.badgeUnreadNumber > 0 && self.trashButton.hidden){
        self.badgeLabel.text = [NSString stringWithFormat:@"%d",self.menuModel.badgeUnreadNumber];
        self.badgeLabel.hidden = false;
    }else{
        self.badgeLabel.hidden = true;
    }
}

- (IBAction)trashButtonTouch:(id)sender {

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"dialog_message_you_want_to_delete_account", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"no", nil) otherButtonTitles:NSLocalizedString(@"yes", nil), nil];
    alertView.delegate = self;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    if (buttonIndex == 0)
    {
         NSLog(@"cancel");
    }
    
}

@end
