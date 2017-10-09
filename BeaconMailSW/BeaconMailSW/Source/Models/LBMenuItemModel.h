//
//  LBMenuItemModel.h
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBMenuItemModel : NSObject

@property (nonatomic, assign) int uniqueId;
@property (nonatomic, assign) int mailAccountId;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *iconUrl;
@property (nonatomic, assign) int badgeUnreadNumber;
@property (nonatomic, assign) BOOL editItem;
@property (copy, nonatomic) NSDate *updateDate;
@property (assign, nonatomic) int inRegion;

-(id)initWithName:(NSString *)titleParam iconUrl:(NSString *)iconUrlParam badgeUnreadNumber:(int)badgeUnreadNumberParam;

-(id)initWithName:(NSString *)titleParam iconUrl:(NSString *)iconUrlParam badgeUnreadNumber:(int)badgeUnreadNumberParam isEdit:(BOOL)isEditParam;

-(id)initWithName:(NSString *)titleParam iconUrl:(NSString *)iconUrlParam badgeUnreadNumber:(int)badgeUnreadNumberParam isEdit:(BOOL)isEditParam mailAccountId:(int)mailAccountIdParam;

-(id)initWithName:(NSString *)titleParam iconUrl:(NSString *)iconUrlParam badgeUnreadNumber:(int)badgeUnreadNumberParam isEdit:(BOOL)isEditParam mailAccountId:(int)mailAccountIdParam updateDate:(NSDate *) updateDateParam;

-(id)initWithName:(NSString *)titleParam iconUrl:(NSString *)iconUrlParam badgeUnreadNumber:(int)badgeUnreadNumberParam isEdit:(BOOL)isEditParam mailAccountId:(int)mailAccountIdParam updateDate:(NSDate *) updateDateParam inRegion:(int)inRegionParam;

- (id)initWithUniqueId:(int)uniqueIdParam title:(NSString *)titleParam iconUrl:(NSString *)iconUrlParam badgeUnreadNumber:(int)badgeUnreadNumberParam isEdit:(BOOL)isEditParam mailAccountId:(int)mailAccountIdParam updateDate:(NSDate *) updateDateParam inRegion:(int)inRegionParam;

- (id)initWithUniqueId:(int)uniqueIdParam title:(NSString *)titleParam iconUrl:(NSString *)iconUrlParam badgeUnreadNumber:(int)badgeUnreadNumberParam isEdit:(BOOL)isEditParam;
@end
