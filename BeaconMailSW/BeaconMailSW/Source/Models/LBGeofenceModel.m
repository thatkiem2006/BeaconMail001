//
//  LBGeofenceModel.m
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

#import "LBGeofenceModel.h"

@implementation LBGeofenceModel

- (instancetype)initWithDictionary:(NSDictionary*)dictionary {
    if (self = [super init]) {
        
        id tmp = dictionary[@"location"][@"latitude"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.latitude = dictionary[@"location"][@"latitude"];
        }
        
        tmp = dictionary[@"location"][@"longitude"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.longitude = dictionary[@"location"][@"longitude"];
        }
        
        tmp = dictionary[@"location"][@"radius"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.radius = dictionary[@"location"][@"radius"];
        }
        
        self.xmlFileId =@"";

        self.listNoti = dictionary[@"notifGroup"][@"notif"];
        NSLog(@"%@",self.listNoti);
    }
    return self;
}

- (id)initWithUniqueId:(int)uniqueIdParam geofenceId:(NSString *)geofenceIdParam latitude:(NSString *)latitudeParam longitude:(NSString *)longitudeParam radius:(NSNumber *)radiusParam xmlFileId :(NSString *)xmlFileIdParam{
    if ((self = [super init])) {
        self.uniqueId = uniqueIdParam;
        self.geofenceId = geofenceIdParam;
        self.latitude = latitudeParam;
        self.longitude = longitudeParam;
        self.radius = radiusParam;
        self.xmlFileId = xmlFileIdParam;
    }
    return self;
}

@end
