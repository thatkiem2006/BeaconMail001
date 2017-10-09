//
//  LBGeofenceDetectModel.m
//  LBBeaconMail
//
//  Created by longdq on 7/18/17.
//  Copyright © 2017 longdq. All rights reserved.
//

#import "LBGeofenceDetectModel.h"

@implementation LBGeofenceDetectModel

- (id)initWithUniqueId:(int)uniqueIdParam geofenceId:(NSString *)geofenceIdParam createDate:(NSDate *)createDateParam updateDate:(NSDate *)updateDateParam iconUrl:(NSString *)iconUrlParam  bannerUrl:(NSString *)bannerUrlParam  saveMailBox: (NSString *)saveMailBoxParam securityKey: (NSString *)securityKeyParam mailAccountId: (NSNumber *)mailAccountIdParam isHidden: (NSNumber *)isHiddenParam{
    if ((self = [super init])) {
        self.uniqueId = uniqueIdParam;
        self.geofenceId = geofenceIdParam;
        self.createDate = createDateParam;
        self.updateDate = updateDateParam;
        self.iconUrl = iconUrlParam;
        self.bannerUrl = bannerUrlParam;
        self.saveMailBox = saveMailBoxParam;
        self.securityKey = securityKeyParam;
        self.mailAccountId = mailAccountIdParam;
        self.isHidden = isHiddenParam;
    }
    return self;
}

- (id)initWithUniqueId:(int)uniqueIdParam geofenceId:(NSString *)geofenceIdParam createDate:(NSDate *)createDateParam updateDate:(NSDate *)updateDateParam iconUrl:(NSString *)iconUrlParam  bannerUrl:(NSString *)bannerUrlParam  saveMailBox: (NSString *)saveMailBoxParam securityKey: (NSString *)securityKeyParam mailAccountId: (NSNumber *)mailAccountIdParam isHidden: (NSNumber *)isHiddenParam enterRegionDate:(NSDate *)enterRegionDateParam exitRegionDate:(NSDate *)exitRegionDateParam{
    if ((self = [super init])) {
        self.uniqueId = uniqueIdParam;
        self.geofenceId = geofenceIdParam;
        self.createDate = createDateParam;
        self.updateDate = updateDateParam;
        self.iconUrl = iconUrlParam;
        self.bannerUrl = bannerUrlParam;
        self.saveMailBox = saveMailBoxParam;
        self.securityKey = securityKeyParam;
        self.mailAccountId = mailAccountIdParam;
        self.isHidden = isHiddenParam;
        self.enterRegionDate = enterRegionDateParam;
        self.exitRegionDate = exitRegionDateParam;
    }
    return self;
}

- (id)initWithName:(NSString *)geofenceIdParam iconUrl:(NSString *)iconUrlParam bannerUrl:(NSString *)bannerUrlParam saveMailBox:(NSString *)saveMailBoxParam  securityKey:(NSString *)securityKeyParam   mailAccountId: (NSNumber *)mailAccountIdParam{
    if ((self = [super init])) {
        self.geofenceId = geofenceIdParam;
        self.iconUrl = iconUrlParam;
        self.bannerUrl = bannerUrlParam;
        self.saveMailBox = saveMailBoxParam;
        self.securityKey = securityKeyParam;
        self.mailAccountId = mailAccountIdParam;
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary*)dictionary {
    if (self = [super init]) {
        id tmp = [dictionary objectForKey:@"iconUrl"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.iconUrl = dictionary[@"iconUrl"];
        }
        
        tmp = [dictionary objectForKey:@"bannerUrl"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.bannerUrl = dictionary[@"bannerUrl"];
        }
        
        tmp = [dictionary objectForKey:@"saveMailbox"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.saveMailBox = dictionary[@"saveMailbox"];
        }
        
        tmp = [dictionary objectForKey:@"securityKey"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.securityKey = dictionary[@"securityKey"];
        }
    }
    return self;
}


@end
