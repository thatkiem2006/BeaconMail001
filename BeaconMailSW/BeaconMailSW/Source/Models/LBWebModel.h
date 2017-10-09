//
//  LBWebModel.h
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBWebModel : NSObject

@property (nonatomic, assign) int uniqueId;
@property (copy, nonatomic) NSString *url;
@property (copy, nonatomic) NSString *userId;
@property (copy, nonatomic) NSString *password;
@property (copy, nonatomic) NSString *elementIdOfUserId;
@property (copy, nonatomic) NSString *elementIdOfPassword;
@property (copy, nonatomic) NSString *lang;
@property (copy, nonatomic) NSNumber *isDefault;

@property (copy, nonatomic) NSString *iconUrl;

@property (strong, nonatomic) NSNumber *beaconDetectId;
@property (assign, nonatomic) NSString *proximity;

@property (copy, nonatomic) NSString *geofenceId;

-(id)copyWithZone:(NSZone *)zone;

- (id)initWithName:(NSNumber *)beaconDetectIdParam proximity:(NSString *)proximityParam url:(NSString *)urlParam userId:(NSString *)userIdParam password:(NSString *)passwordParam elementIdOfUserId:(NSString *)elementIdOfUserIdParam elementIdOfPassword:(NSString *)elementIdOfPasswordParam lang:(NSString *)langParam isDefault :(NSNumber *)isDefaultParam;

- (instancetype)initWithDictionaryBeacon:(NSDictionary*)dictionary;

- (instancetype)initWithDictionary:(NSDictionary*)dictionary;

- (id)initWithNameGeofence:(NSString *)geofenceIdParam url:(NSString *)urlParam userId:(NSString *)userIdParam password:(NSString *)passwordParam elementIdOfUserId:(NSString *)elementIdOfUserIdParam elementIdOfPassword:(NSString *)elementIdOfPasswordParam lang:(NSString *)langParam isDefault :(NSNumber *)isDefaultParam;

- (id)initWithUniqueId:(int)uniqueIdParam geofenceId:(NSString *)geofenceIdParam url:(NSString *)urlParam userId:(NSString *)userIdParam password:(NSString *)passwordParam elementIdOfUserId:(NSString *)elementIdOfUserIdParam elementIdOfPassword:(NSString *)elementIdOfPasswordParam lang:(NSString *)langParam isDefault :(NSNumber *)isDefaultParam;

- (id)initWithUniqueId:(int)uniqueIdParam geofenceId:(NSString *)geofenceIdParam url:(NSString *)urlParam userId:(NSString *)userIdParam password:(NSString *)passwordParam elementIdOfUserId:(NSString *)elementIdOfUserIdParam elementIdOfPassword:(NSString *)elementIdOfPasswordParam lang:(NSString *)langParam isDefault :(NSNumber *)isDefaultParam iconUrl:(NSString *)iconUrlParam;

- (id)initWithUniqueId:(int)uniqueIdParam beaconDetectId:(NSNumber *)beaconDetectIdParam proximity:(NSString *)proximityParam url:(NSString *)urlParam userId:(NSString *)userIdParam password:(NSString *)passwordParam elementIdOfUserId:(NSString *)elementIdOfUserIdParam elementIdOfPassword:(NSString *)elementIdOfPasswordParam lang:(NSString *)langParam isDefault :(NSNumber *)isDefaultParam iconUrl:(NSString *)iconUrlParam;

@end
