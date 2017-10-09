//
//  LBMailAccountModel.h
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBMailAccountModel : NSObject<NSCopying>

@property (nonatomic) int uniqueId;
@property (copy, nonatomic) NSString *mailAccountId;
@property (copy, nonatomic) NSString *accountId;
@property (copy, nonatomic) NSString *idPrefix;
@property (copy, nonatomic) NSString *idSuffix;
@property (copy, nonatomic) NSNumber *isDefault;
@property (copy, nonatomic) NSString *lang;
@property (copy, nonatomic) NSString *password;
@property (copy, nonatomic) NSString *port;
@property (copy, nonatomic) NSString *server;
@property (copy, nonatomic) NSString *encryption;
@property (copy, nonatomic) NSDate *updateDate;
@property (copy, nonatomic) NSNumber *topMailId;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSNumber *accountType;

-(id)copyWithZone:(NSZone *)zone ;

-(instancetype)initWithDictionary:(NSDictionary*)dictionary;

-(instancetype)initWithDictionaryBeacon:(NSDictionary*)dictionary;

-(instancetype)initWithDictionaryDetech:(NSDictionary*)dictionary;

- (id)initWithUniqueId:(int)uniqueIdParam accountId:(NSString *)accountIdParam idPrefix:(NSString *)idPrefixParam idSuffix:(NSString *)idSuffixParam isDefault:(NSNumber *)isDefaultParam lang:(NSString *)langParam password:(NSString *)passwordParam port:(NSString *)portParam server:(NSString *)serverParam encryption:(NSString *)encryptionParam updateDate:(NSDate *)updateDateParam;

- (id)initWithUniqueId:(int)uniqueIdParam accountId:(NSString *)accountIdParam topMailId:(NSNumber *)topMailIdParam idPrefix:(NSString *)idPrefixParam idSuffix:(NSString *)idSuffixParam isDefault:(NSNumber *)isDefaultParam lang:(NSString *)langParam password:(NSString *)passwordParam port:(NSString *)portParam server:(NSString *)serverParam encryption:(NSString *)encryptionParam updateDate:(NSDate *)updateDateParam;


- (id)initWithName:(NSString *)accountIdParam password:(NSString *)passwordParam port:(NSString *)portParam server:(NSString *)serverParam encryption:(NSString *)encryptionParam name:(NSString *)nameParam idPrefix:(NSString *)idPrefixParam idSuffix:(NSString *)idSuffixParam;

- (id)initWithUniqueId:(int)uniqueIdParam accountId:(NSString *)accountIdParam topMailId:(NSNumber *)topMailIdParam idPrefix:(NSString *)idPrefixParam idSuffix:(NSString *)idSuffixParam isDefault:(NSNumber *)isDefaultParam lang:(NSString *)langParam password:(NSString *)passwordParam port:(NSString *)portParam server:(NSString *)serverParam encryption:(NSString *)encryptionParam updateDate:(NSDate *)updateDateParam name:(NSString *)nameParam;

- (id)initWithName:(NSString *)accountIdParam password:(NSString *)passwordParam port:(NSString *)portParam server:(NSString *)serverParam encryption:(NSString *)encryptionParam name:(NSString *)nameParam idPrefix:(NSString *)idPrefixParam idSuffix:(NSString *)idSuffixParam lang:(NSString *)langParam isDefault:(NSNumber *)isDefaultParam;

- (id)initWithUniqueId:(int)uniqueIdParam accountId:(NSString *)accountIdParam topMailId:(NSNumber *)topMailIdParam idPrefix:(NSString *)idPrefixParam idSuffix:(NSString *)idSuffixParam isDefault:(NSNumber *)isDefaultParam lang:(NSString *)langParam password:(NSString *)passwordParam port:(NSString *)portParam server:(NSString *)serverParam encryption:(NSString *)encryptionParam updateDate:(NSDate *)updateDateParam name:(NSString *)nameParam accountType:(NSNumber *)accountTypeParam;

- (id)initWithName:(NSString *)accountIdParam password:(NSString *)passwordParam port:(NSString *)portParam server:(NSString *)serverParam encryption:(NSString *)encryptionParam name:(NSString *)nameParam idPrefix:(NSString *)idPrefixParam idSuffix:(NSString *)idSuffixParam lang:(NSString *)langParam isDefault:(NSNumber *)isDefaultParam accountType:(NSNumber *)accountTypeParam;
@end
