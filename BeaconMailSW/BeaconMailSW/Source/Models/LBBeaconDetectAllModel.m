//
//  LBBeaconDetectAllModel.m
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

#import "LBBeaconDetectAllModel.h"

@implementation LBBeaconDetectAllModel

- (LBBeaconDetectAllModel *)initWithDictionaryMailAccountBeacon:(NSDictionary*)dictionary {
    
    id tmp = [dictionary objectForKey:@"name"];
    if ([tmp isKindOfClass:[NSString class]]) {
        self.name = dictionary[@"name"];
    }
    
    tmp = [dictionary objectForKey:@"server"];
    if ([tmp isKindOfClass:[NSString class]]) {
        self.server = dictionary[@"server"];
    }
    
    tmp = [dictionary objectForKey:@"encryption"];
    if ([tmp isKindOfClass:[NSString class]]) {
        self.encryption = dictionary[@"encryption"];
    }
    
    tmp = [dictionary objectForKey:@"port"];
    if ([tmp isKindOfClass:[NSString class]]) {
        self.port = dictionary[@"port"];
    }
    
    tmp = [dictionary objectForKey:@"passwd"];
    if ([tmp isKindOfClass:[NSString class]]) {
        self.password = dictionary[@"passwd"];
    }
    
    tmp = [dictionary objectForKey:@"_lang"];
    if ([tmp isKindOfClass:[NSString class]]) {
        self.langMailAccount = dictionary[@"_lang"];
    }
    
    tmp = [dictionary objectForKey:@"_default"];
    if ([tmp isKindOfClass:[NSString class]]) {
        self.isDefaultMailAccount = [NSNumber numberWithInt:1];
    }else{
        self.isDefaultMailAccount = [NSNumber numberWithInt:0];
    }
    return  self;
    
}

- (instancetype)initWithDictionaryMailAccountArray:(NSArray*)arrayElement {
    if (self = [super init]) {
        
    }
    return self;
}

- (instancetype)initWithDictionaryMailAccount:(NSDictionary*)dictionary {
    if (self = [super init]) {
        id tmp = [dictionary objectForKey:@"name"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.name = dictionary[@"name"];
        }
        
        tmp = [dictionary objectForKey:@"server"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.server = dictionary[@"server"];
        }
        
        tmp = [dictionary objectForKey:@"encryption"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.encryption = dictionary[@"encryption"];
        }
        
        tmp = [dictionary objectForKey:@"port"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.port = dictionary[@"port"];
        }
        
        tmp = [dictionary objectForKey:@"passwd"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.password = dictionary[@"passwd"];
        }
        
        tmp = [dictionary objectForKey:@"_lang"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.langMailAccount = dictionary[@"_lang"];
        }
        
        tmp = [dictionary objectForKey:@"_default"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.isDefaultMailAccount = [NSNumber numberWithInt:1];
        }else{
            self.isDefaultMailAccount = [NSNumber numberWithInt:0];
        }
    }
    return self;
}

- (instancetype)initWithDictionaryProfile:(NSDictionary*)dictionary {
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

- (instancetype)initWithDictionaryNoti:(NSDictionary*)dictionary {
    if (self = [super init]) {
        id tmp = [dictionary objectForKey:@"title"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.title = dictionary[@"title"];
        }
        
        tmp = [dictionary objectForKey:@"message"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.message = dictionary[@"message"];
        }
        
        tmp = [dictionary objectForKey:@"_lang"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.langNoti = dictionary[@"_lang"];
        }
        
        tmp = [dictionary objectForKey:@"_default"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.isDefaultNoti = [NSNumber numberWithInt:1];
        }else{
            self.isDefaultNoti = [NSNumber numberWithInt:0];
        }
    }
    return self;
}

- (instancetype)initWithDictionaryProximityFar:(NSDictionary*)dictionary {
    if (self = [super init]) {
        id tmp = [dictionary objectForKey:@"url"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.proximityWebFarUrl = dictionary[@"url"];
        }
        
        tmp = [dictionary objectForKey:@"_lang"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.langProximity = dictionary[@"_lang"];
        }
        
        tmp = [dictionary objectForKey:@"_default"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.isDefaultProximity = [NSNumber numberWithInt:1];
        }else{
            self.isDefaultProximity = [NSNumber numberWithInt:0];
        }
        
        tmp = [dictionary objectForKey:@"userId"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.proximityWebFarUserId = dictionary[@"userId"];
        }
        
        tmp = [dictionary objectForKey:@"passwd"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.proximityWebFarPassword = dictionary[@"passwd"];
        }
        
        tmp = [dictionary objectForKey:@"elementIdOfUserId"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.proximityWebFarElementIdOfUserId = dictionary[@"elementIdOfUserId"];
        }
        
        tmp = [dictionary objectForKey:@"elementIdOfPasswd"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.proximityWebFarElementIdOfPassword = dictionary[@"elementIdOfPasswd"];
        }
        
    }
    return self;
}

- (instancetype)initWithDictionaryProximityNear:(NSDictionary*)dictionary {
    if (self = [super init]) {
        id tmp = [dictionary objectForKey:@"url"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.proximityWebNearUrl = dictionary[@"url"];
        }
        
        tmp = [dictionary objectForKey:@"_lang"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.langProximity = dictionary[@"_lang"];
        }
        
        tmp = [dictionary objectForKey:@"_default"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.isDefaultProximity = [NSNumber numberWithInt:1];
        }else{
            self.isDefaultProximity = [NSNumber numberWithInt:0];
        }
        
        tmp = [dictionary objectForKey:@"userId"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.proximityWebNearUserId = dictionary[@"userId"];
        }
        
        tmp = [dictionary objectForKey:@"passwd"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.proximityWebNearPassword = dictionary[@"passwd"];
        }
        
        tmp = [dictionary objectForKey:@"elementIdOfUserId"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.proximityWebNearElementIdOfUserId = dictionary[@"elementIdOfUserId"];
        }
        
        tmp = [dictionary objectForKey:@"elementIdOfPasswd"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.proximityWebNearElementIdOfPassword = dictionary[@"elementIdOfPasswd"];
        }
        
    }
    return self;
}

- (instancetype)initWithDictionaryProximityImmediate:(NSDictionary*)dictionary {
    if (self = [super init]) {
        id tmp = [dictionary objectForKey:@"url"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.proximityWebImmediateUrl = dictionary[@"url"];
        }
        
        tmp = [dictionary objectForKey:@"_lang"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.langProximity = dictionary[@"_lang"];
        }
        
        tmp = [dictionary objectForKey:@"_default"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.isDefaultProximity = [NSNumber numberWithInt:1];
        }else{
            self.isDefaultProximity = [NSNumber numberWithInt:0];
        }
        
        tmp = [dictionary objectForKey:@"userId"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.proximityWebImmediateUserId = dictionary[@"userId"];
        }
        
        tmp = [dictionary objectForKey:@"passwd"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.proximityWebImmediatePassword = dictionary[@"passwd"];
        }
        
        tmp = [dictionary objectForKey:@"elementIdOfUserId"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.proximityWebImmediateElementIdOfUserId = dictionary[@"elementIdOfUserId"];
        }
        
        tmp = [dictionary objectForKey:@"elementIdOfPasswd"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.proximityWebImmediateElementIdOfPassword = dictionary[@"elementIdOfPasswd"];
        }
        
    }
    return self;
}


- (id)initWithUniqueId:(NSNumber *)isDefaultParam lang:(NSString *)langParam password:(NSString *)passwordParam port:(NSString *)portParam server:(NSString *)serverParam encryption:(NSString *)encryptionParam
{
    if ((self = [super init])) {
        self.isDefaultMailAccount = isDefaultParam;
        self.langMailAccount = langParam;
        self.password = passwordParam;
        self.port = portParam;
        self.server = serverParam;
        self.encryption = encryptionParam;
    }
    return self;
}

- (id)initWithName:(LBMailAccountModel *)mailAccountModelParam profileBeaconModel:(LBProfileBeaconModel *)profileBeaconModelParam  beaconModel:(LBBeaconModel *)beaconModelParam notiModel:(LBNotiModel *)notiModelParam proximityWebFarModel:(LBProximityWebModel *)proximityWebFarModelParam proximityWebNearModel:(LBProximityWebModel *)proximityWebNearModelParam proximityWebImmediateModel:(LBProximityWebModel *)proximityWebImmediateModelParam{
    if ((self = [super init])) {
        self.mailAccountModel = mailAccountModelParam;
        self.profileBeaconModel = profileBeaconModelParam;
        self.beaconModel = beaconModelParam;
        self.notiModel = notiModelParam;
        self.proximityWebFarModel = proximityWebFarModelParam;
        self.proximityWebNearModel = proximityWebNearModelParam;
        self.proximityWebImmediateModel = proximityWebImmediateModelParam;
    }
    return self;
}

@end
