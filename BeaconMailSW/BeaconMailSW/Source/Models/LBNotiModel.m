//
//  LBNotiModel.m
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

#import "LBNotiModel.h"

@implementation LBNotiModel

-(id)copyWithZone:(NSZone *)zone {
    LBNotiModel *model = [[[self class] allocWithZone:zone] init];
    
    model.uniqueId = self.uniqueId;
    model.geofenceDetectId = self.geofenceDetectId;
    model.beaconDetectId = self.beaconDetectId;
    model.title = self.title;
    model.message = self.message;
    model.isDefault = self.isDefault;
    model.lang = self.lang;
    
    return model;
}

- (instancetype)initWithDictionary:(NSDictionary*)dictionary {
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
            self.lang = dictionary[@"_lang"];
        }
        
        tmp = [dictionary objectForKey:@"_default"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.isDefault = [NSNumber numberWithInt:1];
        }else{
            self.isDefault = [NSNumber numberWithInt:0];
        }
    }
    return self;
}


-(id)initWithName:(NSString *)uuidParam title:(NSString *)titleParam message:(NSString *)messageParam;
{
    self = [super init];
    if (self) {
        self.uuid = uuidParam;
        self.title = titleParam;
        self.message = messageParam;
    }
    return self;
}

-(id)initWithName:(NSNumber *)beaconDetectId title:(NSString *)titleParam message:(NSString *)messageParam lang:(NSString *)langParam isDefault : (NSNumber *)isDefault
{
    self = [super init];
    if (self) {
        self.beaconDetectId = beaconDetectId;
        self.title = titleParam;
        self.message = messageParam;
        self.lang = langParam;
        self.isDefault = isDefault;
    }
    return self;
}

- (id)initWithUniqueId:(int)uniqueIdParam beaconDetectId:(NSNumber *)beaconDetectIdParam title:(NSString *)titleParam message:(NSString *)messageParam lang:(NSString *)langParam isDefault:(NSNumber *)isDefaultParam{
    if ((self = [super init])) {
        self.uniqueId = uniqueIdParam;
        self.beaconDetectId = beaconDetectIdParam;
        self.title = titleParam;
        self.message = messageParam;
        self.lang = langParam;
        self.isDefault = isDefaultParam;
    }
    return self;
}
@end
