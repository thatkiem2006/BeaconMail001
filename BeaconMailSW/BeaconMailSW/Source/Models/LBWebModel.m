//
//  LBWebModel.m
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

#import "LBWebModel.h"

@implementation LBWebModel

-(id)copyWithZone:(NSZone *)zone {
    LBWebModel *model = [[[self class] allocWithZone:zone] init];
    model.url = self.url;
    model.userId = self.userId;
    model.password = self.password;
    model.elementIdOfUserId = self.elementIdOfUserId;
    model.elementIdOfPassword = self.elementIdOfPassword;
    model.lang = self.lang;
    model.isDefault = self.isDefault;
    model.beaconDetectId = self.beaconDetectId;
    model.proximity = self.proximity;
    model.geofenceId = self.geofenceId;
    return model;
}

- (id)initWithName:(NSNumber *)beaconDetectIdParam proximity:(NSString *)proximityParam url:(NSString *)urlParam userId:(NSString *)userIdParam password:(NSString *)passwordParam elementIdOfUserId:(NSString *)elementIdOfUserIdParam elementIdOfPassword:(NSString *)elementIdOfPasswordParam lang:(NSString *)langParam isDefault :(NSNumber *)isDefaultParam{
    self = [super init];
    if (self) {
        self.beaconDetectId = beaconDetectIdParam;
        self.proximity = proximityParam;
        self.url = urlParam;
        self.userId = userIdParam;
        self.password = passwordParam;
        self.elementIdOfUserId = elementIdOfUserIdParam;
        self.elementIdOfPassword = elementIdOfPasswordParam;
        self.lang = langParam;
        self.isDefault = isDefaultParam;
    }
    return self;
}

- (id)initWithUniqueId:(int)uniqueIdParam beaconDetectId:(NSNumber *)beaconDetectIdParam proximity:(NSString *)proximityParam url:(NSString *)urlParam userId:(NSString *)userIdParam password:(NSString *)passwordParam elementIdOfUserId:(NSString *)elementIdOfUserIdParam elementIdOfPassword:(NSString *)elementIdOfPasswordParam lang:(NSString *)langParam isDefault :(NSNumber *)isDefaultParam iconUrl:(NSString *)iconUrlParam{
    if ((self = [super init])) {
        self.uniqueId = uniqueIdParam;
        self.beaconDetectId = beaconDetectIdParam;
        self.proximity = proximityParam;
        self.lang = langParam;
        self.isDefault = isDefaultParam;
        self.url = urlParam;
        self.userId = userIdParam;
        self.password = passwordParam;
        self.elementIdOfUserId = elementIdOfUserIdParam;
        self.elementIdOfPassword = elementIdOfPasswordParam;
        self.iconUrl = iconUrlParam;
    }
    return self;

}

- (id)initWithNameGeofence:(NSString *)geofenceIdParam url:(NSString *)urlParam userId:(NSString *)userIdParam password:(NSString *)passwordParam elementIdOfUserId:(NSString *)elementIdOfUserIdParam elementIdOfPassword:(NSString *)elementIdOfPasswordParam lang:(NSString *)langParam isDefault :(NSNumber *)isDefaultParam{
    self = [super init];
    if (self) {
        self.geofenceId = geofenceIdParam;
        self.url = urlParam;
        self.userId = userIdParam;
        self.password = passwordParam;
        self.elementIdOfUserId = elementIdOfUserIdParam;
        self.elementIdOfPassword = elementIdOfPasswordParam;
        self.lang = langParam;
        self.isDefault = isDefaultParam;
    }
    return self;
}


- (instancetype)initWithDictionaryBeacon:(NSDictionary*)dictionary {
    if (self = [super init]) {
        id tmp = [dictionary objectForKey:@"url"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.url = dictionary[@"url"];
        }
        
        tmp = [dictionary objectForKey:@"_lang"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.lang = dictionary[@"_lang"];
        }
        
        tmp = [dictionary objectForKey:@"_default"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.isDefault = [NSNumber numberWithInt:1];
        }else{
            self.isDefault = [NSNumber numberWithInt:0];
        }
        
        tmp = [dictionary objectForKey:@"userId"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.userId = dictionary[@"userId"];
        }
        
        tmp = [dictionary objectForKey:@"passwd"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.password = dictionary[@"passwd"];
        }
        
        tmp = [dictionary objectForKey:@"elementIdOfUserId"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.elementIdOfUserId = dictionary[@"elementIdOfUserId"];
        }
        
        tmp = [dictionary objectForKey:@"elementIdOfPasswd"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.elementIdOfPassword = dictionary[@"elementIdOfPasswd"];
        }
        
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary*)dictionary {
    if (self = [super init]) {
        id tmp = [dictionary objectForKey:@"url"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.url = dictionary[@"url"];
        }
        
        tmp = [dictionary objectForKey:@"_lang"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.lang = dictionary[@"_lang"];
        }
        
        tmp = [dictionary objectForKey:@"_default"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.isDefault = [NSNumber numberWithInt:1];
        }else{
            self.isDefault = [NSNumber numberWithInt:0];
        }
        
        tmp = [dictionary objectForKey:@"userId"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.userId = dictionary[@"userId"];
        }
        
        tmp = [dictionary objectForKey:@"passwd"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.password = dictionary[@"passwd"];
        }
        
        tmp = [dictionary objectForKey:@"elementIdOfUserId"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.elementIdOfUserId = dictionary[@"elementIdOfUserId"];
        }
        
        tmp = [dictionary objectForKey:@"elementIdOfPasswd"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.elementIdOfPassword = dictionary[@"elementIdOfPasswd"];
        }
        
    }
    return self;
}


- (id)initWithUniqueId:(int)uniqueIdParam geofenceId:(NSString *)geofenceIdParam url:(NSString *)urlParam userId:(NSString *)userIdParam password:(NSString *)passwordParam elementIdOfUserId:(NSString *)elementIdOfUserIdParam elementIdOfPassword:(NSString *)elementIdOfPasswordParam lang:(NSString *)langParam isDefault :(NSNumber *)isDefaultParam{
    if ((self = [super init])) {
        self.uniqueId = uniqueIdParam;
        self.geofenceId = geofenceIdParam;
        self.lang = langParam;
        self.isDefault = isDefaultParam;
        self.url = urlParam;
        self.userId = userIdParam;
        self.password = passwordParam;
        self.elementIdOfUserId = elementIdOfUserIdParam;
        self.elementIdOfPassword = elementIdOfPasswordParam;
    }
    return self;
}

- (id)initWithUniqueId:(int)uniqueIdParam geofenceId:(NSString *)geofenceIdParam url:(NSString *)urlParam userId:(NSString *)userIdParam password:(NSString *)passwordParam elementIdOfUserId:(NSString *)elementIdOfUserIdParam elementIdOfPassword:(NSString *)elementIdOfPasswordParam lang:(NSString *)langParam isDefault :(NSNumber *)isDefaultParam iconUrl:(NSString *)iconUrlParam{
    if ((self = [super init])) {
        self.uniqueId = uniqueIdParam;
        self.geofenceId = geofenceIdParam;
        self.lang = langParam;
        self.isDefault = isDefaultParam;
        self.url = urlParam;
        self.userId = userIdParam;
        self.password = passwordParam;
        self.elementIdOfUserId = elementIdOfUserIdParam;
        self.elementIdOfPassword = elementIdOfPasswordParam;
        self.iconUrl = iconUrlParam;
    }
    return self;

}

@end
