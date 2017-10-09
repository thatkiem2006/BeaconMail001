//
//  LBProfileModel.m
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

#import "LBProfileModel.h"

@implementation LBProfileModel

- (instancetype)initWithDictionary:(NSDictionary*)dictionary {
    if (self = [super init]) {
        
        id tmp = [dictionary objectForKey:@"name"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.name = dictionary[@"name"];
        }
        
        tmp = [dictionary objectForKey:@"daysToLive"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.daysToLive = dictionary[@"daysToLive"];
        }
        
        tmp = [dictionary objectForKey:@"readReceiptUrl"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.readReceiptUrl = dictionary[@"readReceiptUrl"];
        }
        
        tmp = [dictionary objectForKey:@"xmlUrlForGf"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.xmlUrlForGf = dictionary[@"xmlUrlForGf"];
        }
    }
    return self;
}

- (id)initWithUniqueId:(int)uniqueIdParam name:(NSString *)nameParam dayToLive:(NSNumber *)dayToLiveParam readReceiptUrl:(NSString *)readReceiptUrlParam xmlUrlForGf:(NSString *)xmlUrlForGfParam{
    if ((self = [super init])) {
        self.uniqueId = uniqueIdParam;
        self.name = nameParam;
        self.daysToLive = dayToLiveParam;
        self.readReceiptUrl = readReceiptUrlParam;
        self.xmlUrlForGf = xmlUrlForGfParam;
    }
    return self;
}

@end
