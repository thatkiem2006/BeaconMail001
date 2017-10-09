//
//  LBBeaconDetectModel.h
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LBMailAccountModel.h"
#import "LBProfileBeaconModel.h"
#import "LBProximityWebModel.h"


@interface LBBeaconDetectModel : NSObject

@property (nonatomic, assign) int uniqueId;
@property (copy, nonatomic) NSString *uuid;
@property (copy, nonatomic) NSString *major;
@property (copy, nonatomic) NSString *minor;
@property (copy, nonatomic) NSString *proximity;
@property (copy, nonatomic) NSString *rssi;

@property (copy, nonatomic) NSDate *createDate;
@property (copy, nonatomic) NSDate *updateDate;

@property (copy, nonatomic) NSString *iconUrl;
@property (copy, nonatomic) NSString *bannerUrl;
@property (copy, nonatomic) NSString *saveMailBox;
@property (copy, nonatomic) NSString *allowProximity;
@property (copy, nonatomic) NSString *securityKey;

@property (copy, nonatomic) NSNumber *mailAccountId;

@property (copy, nonatomic) NSNumber *isHidden;

@property (copy, nonatomic) NSDate *enterRegionDate;
@property (copy, nonatomic) NSDate *exitRegionDate;

@property (copy, nonatomic) LBMailAccountModel *mailAccountModel;

- (id)initWithName:(NSString *)uuidParam major:(NSString *)majorParam minor:(NSString *)minorParam proximity:(NSString *)proximityParam rssi:(NSString *)rssiParam iconUrl:(NSString *)iconUrlParam bannerUrl:(NSString *)bannerUrlParam saveMailBox:(NSString *)saveMailBoxParam  allowProximity:(NSString *)allowProximityParam securityKey:(NSString *)securityKeyParam   mailAccountId: (NSNumber *)mailAccountIdParam;

- (id)initWithUniqueId:(int)uniqueIdParam uuid:(NSString *)uuidParam major:(NSString *)majorParam minor:(NSString *)minorParam proximity:(NSString *)proximityParam rssi:(NSString *)rssiParam createDate:(NSDate *)createDateParam updateDate:(NSDate *)updateDateParam iconUrl:(NSString *)iconUrlParam  bannerUrl:(NSString *)bannerUrlParam  saveMailBox: (NSString *)saveMailBoxParam allowProximity: (NSString *)allowProximityParam securityKey: (NSString *)securityKeyParam mailAccountId: (NSNumber *)mailAccountIdParam isHidden: (NSNumber *)isHiddenParam;

- (id)initWithUniqueId:(int)uniqueIdParam uuid:(NSString *)uuidParam major:(NSString *)majorParam minor:(NSString *)minorParam proximity:(NSString *)proximityParam rssi:(NSString *)rssiParam createDate:(NSDate *)createDateParam updateDate:(NSDate *)updateDateParam iconUrl:(NSString *)iconUrlParam  bannerUrl:(NSString *)bannerUrlParam  saveMailBox: (NSString *)saveMailBoxParam allowProximity: (NSString *)allowProximityParam securityKey: (NSString *)securityKeyParam mailAccountId: (NSNumber *)mailAccountIdParam isHidden: (NSNumber *)isHiddenParam enterRegionDate:(NSDate *)enterRegionDateParam exitRegionDate:(NSDate *)exitRegionDateParam;
@end
