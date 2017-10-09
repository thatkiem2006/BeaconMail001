//
//  Geotification.h
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

#import <Foundation/Foundation.h>

@import MapKit;
@import CoreLocation;
#import "LBGeofenceModel.h"

typedef enum : NSInteger {
    OnEntry = 0,
    OnExit
} EventType;

@interface Geotification : NSObject <NSCoding, MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, assign) CLLocationDistance radius;
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *note;
@property (nonatomic, assign) EventType eventType;
@property (nonatomic, strong) LBGeofenceModel *geofenceModel;


- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate radius:(CLLocationDistance)radius identifier:(NSString *)identifier note:(NSString *)note eventType:(EventType)eventType geofenceModel : (LBGeofenceModel *)geofenceModel;

@end
