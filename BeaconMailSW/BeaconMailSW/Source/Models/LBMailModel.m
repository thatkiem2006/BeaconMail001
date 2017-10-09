//
//  LBMailModel.m
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

#import "LBMailModel.h"

@implementation LBMailModel

- (id)initWithUniqueId:(int)uniqueIdParam mailId:(NSString *)mailIdParam subject:(NSString *)subjectParam messageDescription:(NSString *)messageDescriptionParam message:(NSString *)messageParam isRead:(int)isReadParam isFavorite:(int)isFavoriteParam isHidden:(int)isHiddenParam createDate:(NSDate *)createDateParam  receivedDate:(NSDate *)receivedDateParam  mailAccountModel: (LBMailAccountModel *)mailAccountModelParam
{
    if ((self = [super init])) {
        self.uniqueId = uniqueIdParam;
        self.mailId = mailIdParam;
        self.subject = subjectParam;
        self.messageDescription = messageDescriptionParam;
        self.message = messageParam;
        self.isRead = isReadParam;
        self.isFavorite = isFavoriteParam;
        self.isHidden = isHiddenParam;
        self.createDate = createDateParam;
        self.receivedDate = receivedDateParam;
        self.mailAccountModel = mailAccountModelParam;
    }
    return self;
}

@end
