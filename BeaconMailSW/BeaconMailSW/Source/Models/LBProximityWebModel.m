//
//  LBProximityWebModel.m
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

#import "LBProximityWebModel.h"

@implementation LBProximityWebModel

-(id)copyWithZone:(NSZone *)zone {
    LBProximityWebModel *model = [[[self class] allocWithZone:zone] init];
    model.url = self.url;
    model.userId = self.userId;
    model.password = self.password;
    model.elementIdOfUserId = self.elementIdOfUserId;
    model.elementIdOfPassword = self.elementIdOfPassword;
    model.lang = self.lang;
    model.isDefault = self.isDefault;
    return model;
}

- (id)initWithName:(int)proximityParam url:(NSString *)urlParam userId:(NSString *)userIdParam password:(NSString *)passwordParam elementIdOfUserId:(NSString *)elementIdOfUserIdParam elementIdOfPassword:(NSString *)elementIdOfPasswordParam{
    self = [super init];
    if (self) {
        self.proximity = proximityParam;
        self.url = urlParam;
        self.userId = userIdParam;
        self.password = passwordParam;
        self.elementIdOfUserId = elementIdOfUserIdParam;
        self.elementIdOfPassword = elementIdOfPasswordParam;
    }
    return self;
}

- (id)initWithName:(NSNumber *)beaconDetectIdParam proximity:(int)proximityParam url:(NSString *)urlParam userId:(NSString *)userIdParam password:(NSString *)passwordParam elementIdOfUserId:(NSString *)elementIdOfUserIdParam elementIdOfPassword:(NSString *)elementIdOfPasswordParam{
    self = [super init];
    if (self) {
        self.beaconDetectId = beaconDetectIdParam;
        self.proximity = proximityParam;
        self.url = urlParam;
        self.userId = userIdParam;
        self.password = passwordParam;
        self.elementIdOfUserId = elementIdOfUserIdParam;
        self.elementIdOfPassword = elementIdOfPasswordParam;
    }
    return self;
}
@end
