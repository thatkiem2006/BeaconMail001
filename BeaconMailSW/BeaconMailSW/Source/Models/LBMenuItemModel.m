//
//  LBMenuItemModel.m
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

#import "LBMenuItemModel.h"

@implementation LBMenuItemModel

-(id)initWithName:(NSString *)titleParam iconUrl:(NSString *)iconUrlParam badgeUnreadNumber:(int)badgeUnreadNumberParam;
{
    self = [super init];
    if (self) {
        self.title = titleParam;
        self.iconUrl = iconUrlParam;
        self.badgeUnreadNumber = badgeUnreadNumberParam;
    }
    return self;
}

-(id)initWithName:(NSString *)titleParam iconUrl:(NSString *)iconUrlParam badgeUnreadNumber:(int)badgeUnreadNumberParam isEdit:(BOOL)isEditParam{
    self = [super init];
    if (self) {
        self.title = titleParam;
        self.iconUrl = iconUrlParam;
        self.badgeUnreadNumber = badgeUnreadNumberParam;
        self.editItem = isEditParam;
    }
    return self;
}

-(id)initWithName:(NSString *)titleParam iconUrl:(NSString *)iconUrlParam badgeUnreadNumber:(int)badgeUnreadNumberParam isEdit:(BOOL)isEditParam mailAccountId:(int)mailAccountIdParam{
    self = [super init];
    if (self) {
        self.title = titleParam;
        self.iconUrl = iconUrlParam;
        self.badgeUnreadNumber = badgeUnreadNumberParam;
        self.editItem = isEditParam;
        self.mailAccountId = mailAccountIdParam;
    }
    return self;
}

-(id)initWithName:(NSString *)titleParam iconUrl:(NSString *)iconUrlParam badgeUnreadNumber:(int)badgeUnreadNumberParam isEdit:(BOOL)isEditParam mailAccountId:(int)mailAccountIdParam updateDate:(NSDate *) updateDateParam{
    self = [super init];
    if (self) {
        self.title = titleParam;
        self.iconUrl = iconUrlParam;
        self.badgeUnreadNumber = badgeUnreadNumberParam;
        self.editItem = isEditParam;
        self.mailAccountId = mailAccountIdParam;
        self.updateDate = updateDateParam;
    }
    return self;
}

-(id)initWithName:(NSString *)titleParam iconUrl:(NSString *)iconUrlParam badgeUnreadNumber:(int)badgeUnreadNumberParam isEdit:(BOOL)isEditParam mailAccountId:(int)mailAccountIdParam updateDate:(NSDate *) updateDateParam inRegion:(int)inRegionParam{
    self = [super init];
    if (self) {
        self.title = titleParam;
        self.iconUrl = iconUrlParam;
        self.badgeUnreadNumber = badgeUnreadNumberParam;
        self.editItem = isEditParam;
        self.mailAccountId = mailAccountIdParam;
        self.updateDate = updateDateParam;
        self.inRegion = inRegionParam;
    }
    return self;
}

- (id)initWithUniqueId:(int)uniqueIdParam title:(NSString *)titleParam iconUrl:(NSString *)iconUrlParam badgeUnreadNumber:(int)badgeUnreadNumberParam isEdit:(BOOL)isEditParam mailAccountId:(int)mailAccountIdParam updateDate:(NSDate *) updateDateParam inRegion:(int)inRegionParam{
    if ((self = [super init])) {
        self.uniqueId = uniqueIdParam;
        self.title = titleParam;
        self.iconUrl = iconUrlParam;
        self.badgeUnreadNumber = badgeUnreadNumberParam;
        self.editItem = isEditParam;
        self.mailAccountId = mailAccountIdParam;
        self.updateDate = updateDateParam;
        self.inRegion = inRegionParam;
    }
    return self;
}

- (id)initWithUniqueId:(int)uniqueIdParam title:(NSString *)titleParam iconUrl:(NSString *)iconUrlParam badgeUnreadNumber:(int)badgeUnreadNumberParam isEdit:(BOOL)isEditParam {
    if ((self = [super init])) {
        self.uniqueId = uniqueIdParam;
        self.title = titleParam;
        self.iconUrl = iconUrlParam;
        self.badgeUnreadNumber = badgeUnreadNumberParam;
        self.editItem = isEditParam;
    }
    return self;
}
@end
