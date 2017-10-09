//
//  LBGeofenceModel.h
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LBNotiModel.h"

typedef enum : NSInteger {
    GeofenceOnEntry = 0,
    GeofenceOnExit
} GeofenceType;

@interface LBGeofenceModel : NSObject

@property (nonatomic, assign) int uniqueId;
@property (strong, nonatomic) NSString *geofenceId;
@property (strong, nonatomic) NSNumber *distance;
@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;
@property (strong, nonatomic) NSNumber *radius;
@property (strong, nonatomic) NSString *isEnterGeo;
@property (strong, nonatomic) NSString *xmlFileId;
@property (strong, nonatomic) LBNotiModel *notif;
@property (strong, nonatomic) NSArray *listNoti;
@property (strong, nonatomic) NSDate *createDate;
@property (strong, nonatomic) NSDate *updateDate;

@property (nonatomic, assign) GeofenceType eventType;

-(instancetype)initWithDictionary:(NSDictionary*)dictionary;

- (id)initWithUniqueId:(int)uniqueIdParam geofenceId:(NSString *)geofenceIdParam latitude:(NSString *)latitudeParam longitude:(NSString *)longitudeParam radius:(NSNumber *)radiusParam xmlFileId :(NSString *)xmlFileIdParam;
@end
