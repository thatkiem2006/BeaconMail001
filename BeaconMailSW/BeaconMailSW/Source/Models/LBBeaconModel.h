//
//  LBBeaconModel.h
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBBeaconModel : NSObject

@property (nonatomic, assign) int uniqueId;
@property (strong, nonatomic) NSString *uuid;
@property (strong, nonatomic) NSString *xmlUrl;

@property (strong, nonatomic) NSString *major;
@property (strong, nonatomic) NSString *minor;
@property (strong, nonatomic) NSString *protect;
@property (strong, nonatomic) NSString *rssi;
@property (strong, nonatomic) NSDate *createDate;
@property (strong, nonatomic) NSDate *updateDate;

-(id)copyWithZone:(NSZone *)zone;

- (instancetype)initWithDictionary:(NSDictionary*)dictionary;

- (id)initWithUniqueId:(int)uniqueIdParam uuid:(NSString *)uuidParam  xmlUrl:(NSString *)xmlUrlParam;

- (id)initWithName:(NSString *)uuidParam  xmlUrl:(NSString *)xmlUrlParam;

@end
