//
//  LBGeofenceDetectModel.h
//  LBBeaconMail
//
//  Created by longdq on 7/18/17.
//  Copyright © 2017 longdq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LBMailAccountModel.h"

@interface LBGeofenceDetectModel : NSObject
@property (nonatomic, strong) NSMutableArray *geotifications;

@property (nonatomic, assign) int uniqueId;
@property (copy, nonatomic) NSString *geofenceId;

@property (copy, nonatomic) NSDate *createDate;
@property (copy, nonatomic) NSDate *updateDate;

@property (copy, nonatomic) NSString *iconUrl;
@property (copy, nonatomic) NSString *bannerUrl;
@property (copy, nonatomic) NSString *saveMailBox;
//@property (copy, nonatomic) NSString *allowProximity;
@property (copy, nonatomic) NSString *securityKey;

@property (copy, nonatomic) NSNumber *mailAccountId;

@property (copy, nonatomic) NSNumber *isHidden;

@property (copy, nonatomic) NSDate *enterRegionDate;

@property (copy, nonatomic) NSDate *exitRegionDate;

@property (copy, nonatomic) LBMailAccountModel *mailAccountModel;

- (id)initWithName:(NSString *)geofenceIdParam iconUrl:(NSString *)iconUrlParam bannerUrl:(NSString *)bannerUrlParam saveMailBox:(NSString *)saveMailBoxParam  securityKey:(NSString *)securityKeyParam   mailAccountId: (NSNumber *)mailAccountIdParam;

- (id)initWithUniqueId:(int)uniqueIdParam geofenceId:(NSString *)geofenceIdParam createDate:(NSDate *)createDateParam updateDate:(NSDate *)updateDateParam iconUrl:(NSString *)iconUrlParam  bannerUrl:(NSString *)bannerUrlParam  saveMailBox: (NSString *)saveMailBoxParam securityKey: (NSString *)securityKeyParam mailAccountId: (NSNumber *)mailAccountIdParam isHidden: (NSNumber *)isHiddenParam;

- (id)initWithUniqueId:(int)uniqueIdParam geofenceId:(NSString *)geofenceIdParam createDate:(NSDate *)createDateParam updateDate:(NSDate *)updateDateParam iconUrl:(NSString *)iconUrlParam  bannerUrl:(NSString *)bannerUrlParam  saveMailBox: (NSString *)saveMailBoxParam securityKey: (NSString *)securityKeyParam mailAccountId: (NSNumber *)mailAccountIdParam isHidden: (NSNumber *)isHiddenParam enterRegionDate:(NSDate *)enterRegionDateParam exitRegionDate:(NSDate *)exitRegionDateParam;

- (instancetype)initWithDictionary:(NSDictionary*)dictionary;
@end
