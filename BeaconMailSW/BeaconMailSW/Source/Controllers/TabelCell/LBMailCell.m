//
//  LBMailCell.m
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

#import "LBMailCell.h"

@implementation LBMailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
//    return self;
//}

- (void)prepareForReuse
{
   

}

- (void)setUpMailInfo :(LBMailModel *) model{
    
    self.subjectLabel.text = model.subject;
    self.descriptionLabel.text = model.message;
    self.viewNumberUnreadMessage.hidden = model.isRead;
    self.viewNumberUnreadMessage.layer.cornerRadius = self.viewNumberUnreadMessage.frame.size.height/2;
    self.viewNumberUnreadMessage.layer.masksToBounds = YES;
}
@end
