//
//  LBProfileBeaconModel.h
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBProfileBeaconModel : NSObject

@property (copy, nonatomic) NSString *iconUrl;
@property (copy, nonatomic) NSString *bannerUrl;
@property (copy, nonatomic) NSString *saveMailBox;
@property (copy, nonatomic) NSString *allowProximity;
@property (copy, nonatomic) NSString *securityKey;

-(id)copyWithZone:(NSZone *)zone ;

- (instancetype)initWithDictionary:(NSDictionary*)dictionary;

-(id)initWithName:(NSString *)iconUrlParam bannerUrl:(NSString *)bannerUrlParam saveMailBox:(NSString *)saveMailBoxParam allowProximity:(NSString *)allowProximityParam securityKey:(NSString *)securityKeyParam;

@end
