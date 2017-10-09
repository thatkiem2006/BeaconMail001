//
//  LBNotiModel.h
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBNotiModel : NSObject

@property (nonatomic, assign) int uniqueId;

@property (strong, nonatomic) NSNumber *beaconDetectId;
@property (strong, nonatomic) NSString *geofenceDetectId;

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSNumber *isDefault;
@property (strong, nonatomic) NSString *lang;

@property (strong, nonatomic) NSString *uuid;

-(id)copyWithZone:(NSZone *)zone;

-(instancetype)initWithDictionary:(NSDictionary*)dictionary;

-(id)initWithName:(NSString *)uuidParam title:(NSString *)titleParam message:(NSString *)messageParam;

-(id)initWithName:(NSNumber *)beaconDetectId title:(NSString *)titleParam message:(NSString *)messageParam lang:(NSString *)langParam isDefault : (NSNumber *)isDefault;

- (id)initWithUniqueId:(int)uniqueIdParam beaconDetectId:(NSNumber *)beaconDetectIdParam title:(NSString *)titleParam message:(NSString *)messageParam lang:(NSString *)langParam isDefault:(NSNumber *)isDefaultParam;
@end
