//
//  LBNotiBeaconModel.h
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LBBeaconModel.h"
#import "LBMailAccountModel.h"
#import "LBProfileBeaconModel.h"
#import "LBProximityWebModel.h"
#import "LBNotiModel.h"

@interface LBNotiBeaconModel : NSObject

@property (nonatomic, assign) int uniqueId;

@property (copy, nonatomic) NSString *uuid;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *message;
@property (copy, nonatomic) NSString *langNoti;
@property (copy, nonatomic) NSNumber *isDefaultNoti;

@property (copy, nonatomic) NSString *iconUrl;
@property (copy, nonatomic) NSString *bannerUrl;
@property (copy, nonatomic) NSString *saveMailBox;
@property (copy, nonatomic) NSString *allowProximity;
@property (copy, nonatomic) NSString *securityKey;

@property (copy, nonatomic) NSString *accountId;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *server;
@property (copy, nonatomic) NSString *encryption;
@property (copy, nonatomic) NSString *port;
@property (copy, nonatomic) NSString *idPrefix;
@property (copy, nonatomic) NSString *idSuffix;
@property (copy, nonatomic) NSString *password;
@property (copy, nonatomic) NSNumber *isDefaultMailAccount;
@property (copy, nonatomic) NSString *langMailAccount;

@property (copy, nonatomic) NSString *proximityWebFarUrl;
@property (copy, nonatomic) NSString *proximityWebFarUserId;
@property (copy, nonatomic) NSString *proximityWebFarPassword;
@property (copy, nonatomic) NSString *proximityWebFarElementIdOfUserId;
@property (copy, nonatomic) NSString *proximityWebFarElementIdOfPassword;

@property (copy, nonatomic) NSString *proximityWebNearUrl;
@property (copy, nonatomic) NSString *proximityWebNearUserId;
@property (copy, nonatomic) NSString *proximityWebNearPassword;
@property (copy, nonatomic) NSString *proximityWebNearElementIdOfUserId;
@property (copy, nonatomic) NSString *proximityWebNearElementIdOfPassword;

@property (copy, nonatomic) NSString *proximityWebImmediateUrl;
@property (copy, nonatomic) NSString *proximityWebImmediateUserId;
@property (copy, nonatomic) NSString *proximityWebImmediatePassword;
@property (copy, nonatomic) NSString *proximityWebImmediateElementIdOfUserId;
@property (copy, nonatomic) NSString *proximityWebImmediateElementIdOfPassword;

@property (copy, nonatomic) NSNumber *isDefaultProximity;
@property (copy, nonatomic) NSString *langProximity;

@property (copy, nonatomic) NSNumber *isHidden;

@property (copy, nonatomic) LBBeaconModel *beaconModel;

@property (copy, nonatomic) LBMailAccountModel *mailAccountModel;

@property (copy, nonatomic) LBProfileBeaconModel *profileBeaconModel;

@property (copy, nonatomic) LBProximityWebModel *proximityWebFarModel;

@property (copy, nonatomic) LBProximityWebModel *proximityWebNearModel;

@property (copy, nonatomic) LBProximityWebModel *proximityWebImmediateModel;


@property (copy, nonatomic) LBNotiModel *notiModel;

//LBNotiModel


- (instancetype)initWithDictionaryMailAccount:(NSDictionary*)dictionary;

- (LBNotiBeaconModel *)initWithDictionaryMailAccountBeacon:(NSDictionary*)dictionary;

- (instancetype)initWithDictionaryProfile:(NSDictionary*)dictionary;

- (instancetype)initWithDictionaryNoti:(NSDictionary*)dictionary;

- (instancetype)initWithDictionaryProximityFar:(NSDictionary*)dictionary;

- (instancetype)initWithDictionaryProximityNear:(NSDictionary*)dictionary;

- (instancetype)initWithDictionaryProximityImmediate:(NSDictionary*)dictionary;


- (id)initWithUniqueId:(NSNumber *)isDefaultParam lang:(NSString *)langParam password:(NSString *)passwordParam port:(NSString *)portParam server:(NSString *)serverParam encryption:(NSString *)encryptionParam;


- (id)initWithName:(LBMailAccountModel *)mailAccountModelParam profileBeaconModel:(LBProfileBeaconModel *)profileBeaconModelParam  beaconModel:(LBBeaconModel *)beaconModelParam notiModel:(LBNotiModel *)notiModelParam proximityWebFarModel:(LBProximityWebModel *)proximityWebFarModelParam proximityWebNearModel:(LBProximityWebModel *)proximityWebNearModelParam proximityWebImmediateModel:(LBProximityWebModel *)proximityWebImmediateModelParam;

@end
