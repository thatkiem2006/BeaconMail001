//
//  LBProfileBeaconModel.m
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

#import "LBProfileBeaconModel.h"

@implementation LBProfileBeaconModel

-(id)copyWithZone:(NSZone *)zone {
    LBProfileBeaconModel *model = [[[self class] allocWithZone:zone] init];
    model.iconUrl = self.iconUrl;
    model.bannerUrl = self.bannerUrl;
    model.saveMailBox = self.saveMailBox;
    model.allowProximity = self.allowProximity;
    model.securityKey = self.securityKey;
    return model;
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
        
        tmp = [dictionary objectForKey:@"allowProximity"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.allowProximity = dictionary[@"allowProximity"];
        }
        
        tmp = [dictionary objectForKey:@"securityKey"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.securityKey = dictionary[@"securityKey"];
        }
    }
    return self;
}

-(id)initWithName:(NSString *)iconUrlParam bannerUrl:(NSString *)bannerUrlParam saveMailBox:(NSString *)saveMailBoxParam allowProximity:(NSString *)allowProximityParam securityKey:(NSString *)securityKeyParam
{
    self = [super init];
    if (self) {
        self.iconUrl = iconUrlParam;
        self.bannerUrl = bannerUrlParam;
        self.saveMailBox = saveMailBoxParam;
        self.allowProximity = allowProximityParam;
        self.securityKey = securityKeyParam;
    }
    return self;
}

@end
