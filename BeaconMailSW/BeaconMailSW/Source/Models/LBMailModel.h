//
//  LBMailModel.h
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LBMailAccountModel.h"
#import "LBBeaconModel.h"
#import "LBGeofenceModel.h"

@interface LBMailModel : NSObject

@property (nonatomic, assign) int uniqueId;
@property (copy, nonatomic) NSString *mailId;
@property (copy, nonatomic) NSString *subject;
@property (copy, nonatomic) NSString *messageDescription;
@property (copy, nonatomic) NSDate *receivedDate;
@property (copy, nonatomic) NSString *message;
@property (assign, nonatomic) int isRead;
@property (assign, nonatomic) int isFavorite;
@property (assign, nonatomic) int isHidden;
@property (copy, nonatomic) NSDate *createDate;

@property (strong, nonatomic) LBMailAccountModel *mailAccountModel;

@property (copy, nonatomic) LBBeaconModel *beaconModel;

@property (copy, nonatomic) LBGeofenceModel *geofenceModel;

- (id)initWithUniqueId:(int)uniqueIdParam mailId:(NSString *)mailIdParam subject:(NSString *)subjectParam messageDescription:(NSString *)messageDescriptionParam message:(NSString *)messageParam isRead:(int)isReadParam isFavorite:(int)isFavoriteParam isHidden:(int)isHiddenParam createDate:(NSDate *)createDateParam  receivedDate:(NSDate *)receivedDateParam  mailAccountModel: (LBMailAccountModel *)mailAccountModelParam;

@end
