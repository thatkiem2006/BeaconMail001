//
//  LBBeaconModel.m
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

#import "LBBeaconModel.h"

@implementation LBBeaconModel

-(id)copyWithZone:(NSZone *)zone {
    LBBeaconModel *model = [[[self class] allocWithZone:zone] init];
    model.uniqueId = self.uniqueId;
    model.uuid = self.uuid;
    model.xmlUrl = self.xmlUrl;
    return model;
}

- (instancetype)initWithDictionary:(NSDictionary*)dictionary {
    if (self = [super init]) {
        id tmp = [dictionary objectForKey:@"uuid"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.uuid = dictionary[@"uuid"];
        }
        
        tmp = [dictionary objectForKey:@"xmlUrl"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.xmlUrl = dictionary[@"xmlUrl"];
        }
        
    }
    return self;
}

- (id)initWithUniqueId:(int)uniqueIdParam uuid:(NSString *)uuidParam  xmlUrl:(NSString *)xmlUrlParam{
    if ((self = [super init])) {
        self.uniqueId = uniqueIdParam;
        self.uuid = uuidParam;
        self.xmlUrl = xmlUrlParam;
    }
    return self;
}

- (id)initWithName:(NSString *)uuidParam  xmlUrl:(NSString *)xmlUrlParam{
    if ((self = [super init])) {
        self.uuid = uuidParam;
        self.xmlUrl = xmlUrlParam;
    }
    return self;
}

@end
