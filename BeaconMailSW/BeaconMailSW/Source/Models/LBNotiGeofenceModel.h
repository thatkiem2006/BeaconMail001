//
//  LBNotiGeofenceModel.h
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBNotiGeofenceModel : NSObject

@property (nonatomic, assign) int uniqueId;
@property (strong, nonatomic) NSString *geofenceId;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSNumber *isDefault;
@property (strong, nonatomic) NSString *lang;

- (instancetype)initWithDictionary:(NSDictionary*)dictionary;

- (id)initWithUniqueId:(int)uniqueIdParam geofenceId:(NSString *)geofenceIdParam title:(NSString *)titleParam message:(NSString *)messageParam lang:(NSString *)langParam isDefault:(NSNumber *)isDefaultParam;

@end
