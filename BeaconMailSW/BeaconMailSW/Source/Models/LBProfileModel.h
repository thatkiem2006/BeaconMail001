//
//  LBProfileModel.h
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBProfileModel : NSObject

@property (nonatomic, assign) int uniqueId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *daysToLive;
@property (strong, nonatomic) NSString *readReceiptUrl;
@property (strong, nonatomic) NSString *xmlUrlForGf;

- (instancetype)initWithDictionary:(NSDictionary*)dictionary;

- (id)initWithUniqueId:(int)uniqueIdParam name:(NSString *)nameParam dayToLive:(NSNumber *)dayToLiveParam readReceiptUrl:(NSString *)readReceiptUrlParam xmlUrlForGf:(NSString *)xmlUrlForGfParam;
@end
