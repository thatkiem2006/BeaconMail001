//
//  LBProximityWebModel.h
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBProximityWebModel : NSObject

@property (strong, nonatomic) NSNumber *beaconDetectId;

@property (assign, nonatomic) int proximity;
@property (copy, nonatomic) NSString *url;
@property (copy, nonatomic) NSString *userId;
@property (copy, nonatomic) NSString *password;
@property (copy, nonatomic) NSString *elementIdOfUserId;
@property (copy, nonatomic) NSString *elementIdOfPassword;
@property (copy, nonatomic) NSString *lang;
@property (copy, nonatomic) NSNumber *isDefault;

- (id)initWithName:(int)proximityParam url:(NSString *)urlParam userId:(NSString *)userIdParam password:(NSString *)passwordParam elementIdOfUserId:(NSString *)elementIdOfUserIdParam elementIdOfPassword:(NSString *)elementIdOfPasswordParam;

- (id)initWithName:(NSNumber *)beaconDetectIdParam proximity:(int)proximityParam url:(NSString *)urlParam userId:(NSString *)userIdParam password:(NSString *)passwordParam elementIdOfUserId:(NSString *)elementIdOfUserIdParam elementIdOfPassword:(NSString *)elementIdOfPasswordParam;

-(id)copyWithZone:(NSZone *)zone;

@end
