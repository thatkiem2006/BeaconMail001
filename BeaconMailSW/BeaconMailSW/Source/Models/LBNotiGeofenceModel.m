//
//  LBNotiGeofenceModel.m
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

#import "LBNotiGeofenceModel.h"

@implementation LBNotiGeofenceModel

- (instancetype)initWithDictionary:(NSDictionary*)dictionary {
    if (self = [super init]) {
       
        id tmp = [dictionary objectForKey:@"_default"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.isDefault = [NSNumber numberWithInt:1];
        }else{
            self.isDefault = [NSNumber numberWithInt:0];
        }
        
        tmp = [dictionary objectForKey:@"title"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.title = dictionary[@"title"];
        }
        
        tmp = [dictionary objectForKey:@"_lang"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.lang = dictionary[@"_lang"];
        }
 
        tmp = [dictionary objectForKey:@"message"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.message = dictionary[@"message"];
        }
    }
    return self;
}

- (id)initWithUniqueId:(int)uniqueIdParam geofenceId:(NSString *)geofenceIdParam title:(NSString *)titleParam message:(NSString *)messageParam lang:(NSString *)langParam isDefault:(NSNumber *)isDefaultParam{
    if ((self = [super init])) {
        self.uniqueId = uniqueIdParam;
        self.geofenceId = geofenceIdParam;
        self.title = titleParam;
        self.message = messageParam;
        self.lang = langParam;
        self.isDefault = isDefaultParam;
    }
    return self;
}

@end
