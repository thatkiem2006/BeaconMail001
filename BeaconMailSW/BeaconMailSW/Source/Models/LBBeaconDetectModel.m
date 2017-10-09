//
//  LBBeaconDetectModel.m
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

#import "LBBeaconDetectModel.h"

@implementation LBBeaconDetectModel

- (id)initWithName:(NSString *)uuidParam major:(NSString *)majorParam minor:(NSString *)minorParam proximity:(NSString *)proximityParam rssi:(NSString *)rssiParam iconUrl:(NSString *)iconUrlParam bannerUrl:(NSString *)bannerUrlParam saveMailBox:(NSString *)saveMailBoxParam  allowProximity:(NSString *)allowProximityParam securityKey:(NSString *)securityKeyParam   mailAccountId: (NSNumber *)mailAccountIdParam{
    if ((self = [super init])) {
        self.uuid = uuidParam;
        self.major = majorParam;
        self.minor = minorParam;
        self.proximity = proximityParam;
        self.rssi = rssiParam;
        self.iconUrl = iconUrlParam;
        self.bannerUrl = bannerUrlParam;
        self.saveMailBox = saveMailBoxParam;
        self.allowProximity = allowProximityParam;
        self.securityKey = securityKeyParam;
        self.mailAccountId = mailAccountIdParam;
    }
    return self;
}

- (id)initWithUniqueId:(int)uniqueIdParam uuid:(NSString *)uuidParam major:(NSString *)majorParam minor:(NSString *)minorParam proximity:(NSString *)proximityParam rssi:(NSString *)rssiParam createDate:(NSDate *)createDateParam updateDate:(NSDate *)updateDateParam iconUrl:(NSString *)iconUrlParam  bannerUrl:(NSString *)bannerUrlParam  saveMailBox: (NSString *)saveMailBoxParam allowProximity: (NSString *)allowProximityParam securityKey: (NSString *)securityKeyParam mailAccountId: (NSNumber *)mailAccountIdParam isHidden: (NSNumber *)isHiddenParam{
    if ((self = [super init])) {
        self.uniqueId = uniqueIdParam;
        self.uuid = uuidParam;
        self.major = majorParam;
        self.minor = minorParam;
        self.proximity = proximityParam;
        self.rssi = rssiParam;
        self.createDate = createDateParam;
        self.updateDate = updateDateParam;
        self.iconUrl = iconUrlParam;
        self.bannerUrl = bannerUrlParam;
        self.saveMailBox = saveMailBoxParam;
        self.allowProximity = allowProximityParam;
        self.securityKey = securityKeyParam;
        self.mailAccountId = mailAccountIdParam;
        self.isHidden = isHiddenParam;
    }
    return self;
}

- (id)initWithUniqueId:(int)uniqueIdParam uuid:(NSString *)uuidParam major:(NSString *)majorParam minor:(NSString *)minorParam proximity:(NSString *)proximityParam rssi:(NSString *)rssiParam createDate:(NSDate *)createDateParam updateDate:(NSDate *)updateDateParam iconUrl:(NSString *)iconUrlParam  bannerUrl:(NSString *)bannerUrlParam  saveMailBox: (NSString *)saveMailBoxParam allowProximity: (NSString *)allowProximityParam securityKey: (NSString *)securityKeyParam mailAccountId: (NSNumber *)mailAccountIdParam isHidden: (NSNumber *)isHiddenParam enterRegionDate:(NSDate *)enterRegionDateParam exitRegionDate:(NSDate *)exitRegionDateParam{
    if ((self = [super init])) {
        self.uniqueId = uniqueIdParam;
        self.uuid = uuidParam;
        self.major = majorParam;
        self.minor = minorParam;
        self.proximity = proximityParam;
        self.rssi = rssiParam;
        self.createDate = createDateParam;
        self.updateDate = updateDateParam;
        self.iconUrl = iconUrlParam;
        self.bannerUrl = bannerUrlParam;
        self.saveMailBox = saveMailBoxParam;
        self.allowProximity = allowProximityParam;
        self.securityKey = securityKeyParam;
        self.mailAccountId = mailAccountIdParam;
        self.isHidden = isHiddenParam;
        self.enterRegionDate = enterRegionDateParam;
        self.exitRegionDate = exitRegionDateParam;
    }
    return self;
}

@end
