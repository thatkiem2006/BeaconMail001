//
//  LBMailAccountModel.m
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

#import "LBMailAccountModel.h"

@implementation LBMailAccountModel

- (instancetype)initWithDictionary:(NSDictionary*)dictionary {
    if (self = [super init]) {
        id tmp = [dictionary objectForKey:@"id"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.accountId = dictionary[@"id"];
        }
        
        tmp = [dictionary objectForKey:@"server"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.server = dictionary[@"server"];
        }
        
        tmp = [dictionary objectForKey:@"encryption"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.encryption = dictionary[@"encryption"];
        }
        
        tmp = [dictionary objectForKey:@"port"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.port = dictionary[@"port"];
        }
        
        tmp = [dictionary objectForKey:@"idPrefix"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.idPrefix = dictionary[@"idPrefix"];
        }else{
            self.idPrefix = @"";
        }
        
        tmp = [dictionary objectForKey:@"idSuffix"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.idSuffix = dictionary[@"idSuffix"];
        }else{
            self.idSuffix = @"";
        }
        
        tmp = [dictionary objectForKey:@"_lang"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.lang = dictionary[@"_lang"];
        }
        
        tmp = [dictionary objectForKey:@"passwd"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.password = dictionary[@"passwd"];
        }
        
        tmp = [dictionary objectForKey:@"_default"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.isDefault = [NSNumber numberWithInt:1];
        }else{
            self.isDefault = [NSNumber numberWithInt:0];
        }
        self.mailAccountId = [NSString stringWithFormat:@"%@@%@",self.accountId,self.server];
    }
    return self;
}

-(instancetype)initWithDictionaryBeacon:(NSDictionary*)dictionary{
    if (self = [super init]) {
        
        id tmp = [dictionary objectForKey:@"name"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.name = dictionary[@"name"];
        }
        
        tmp = [dictionary objectForKey:@"server"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.server = dictionary[@"server"];
        }
        
        tmp = [dictionary objectForKey:@"encryption"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.encryption = dictionary[@"encryption"];
        }
        
        tmp = [dictionary objectForKey:@"port"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.port = dictionary[@"port"];
        }
        
        tmp = [dictionary objectForKey:@"passwd"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.password = dictionary[@"passwd"];
        }
        
        tmp = [dictionary objectForKey:@"idPrefix"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.idPrefix = dictionary[@"idPrefix"];
        }else{
            self.idPrefix = @"";
        }
        
        tmp = [dictionary objectForKey:@"idSuffix"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.idSuffix = dictionary[@"idSuffix"];
        }else{
            self.idSuffix = @"";
        }
        
        tmp = [dictionary objectForKey:@"_lang"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.lang = dictionary[@"_lang"];
        }
        
        tmp = [dictionary objectForKey:@"_default"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.isDefault = [NSNumber numberWithInt:1];
        }else{
            self.isDefault = [NSNumber numberWithInt:0];
        }
    }
    return self;
}

-(instancetype)initWithDictionaryDetech:(NSDictionary*)dictionary{
    if (self = [super init]) {
        
        id tmp = [dictionary objectForKey:@"name"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.name = dictionary[@"name"];
        }
        
        tmp = [dictionary objectForKey:@"server"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.server = dictionary[@"server"];
        }
        
        tmp = [dictionary objectForKey:@"encryption"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.encryption = dictionary[@"encryption"];
        }
        
        tmp = [dictionary objectForKey:@"port"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.port = dictionary[@"port"];
        }
        
        tmp = [dictionary objectForKey:@"passwd"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.password = dictionary[@"passwd"];
        }
        
        tmp = [dictionary objectForKey:@"idPrefix"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.idPrefix = dictionary[@"idPrefix"];
        }else{
            self.idPrefix = @"";
        }
        
        tmp = [dictionary objectForKey:@"idSuffix"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.idSuffix = dictionary[@"idSuffix"];
        }else{
            self.idSuffix = @"";
        }
        
        tmp = [dictionary objectForKey:@"_lang"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.lang = dictionary[@"_lang"];
        }
        
        tmp = [dictionary objectForKey:@"_default"];
        if ([tmp isKindOfClass:[NSString class]]) {
            self.isDefault = [NSNumber numberWithInt:1];
        }else{
            self.isDefault = [NSNumber numberWithInt:0];
        }
    }
    return self;
}


- (id)initWithUniqueId:(int)uniqueIdParam accountId:(NSString *)accountIdParam idPrefix:(NSString *)idPrefixParam idSuffix:(NSString *)idSuffixParam isDefault:(NSNumber *)isDefaultParam lang:(NSString *)langParam password:(NSString *)passwordParam port:(NSString *)portParam server:(NSString *)serverParam encryption:(NSString *)encryptionParam updateDate:(NSDate *)updateDateParam
{
    if ((self = [super init])) {
        self.uniqueId = uniqueIdParam;
        self.accountId = accountIdParam;
        self.idPrefix = idPrefixParam;
        self.idSuffix = idSuffixParam;
        self.isDefault = isDefaultParam;
        self.lang = langParam;
        self.password = passwordParam;
        self.port = portParam;
        self.server = serverParam;
        self.encryption = encryptionParam;
        self.updateDate = updateDateParam;
        self.mailAccountId = [NSString stringWithFormat:@"%@@%@",accountIdParam,serverParam];
    }
    return self;
}

- (id)initWithUniqueId:(int)uniqueIdParam accountId:(NSString *)accountIdParam topMailId:(NSNumber *)topMailIdParam idPrefix:(NSString *)idPrefixParam idSuffix:(NSString *)idSuffixParam isDefault:(NSNumber *)isDefaultParam lang:(NSString *)langParam password:(NSString *)passwordParam port:(NSString *)portParam server:(NSString *)serverParam encryption:(NSString *)encryptionParam updateDate:(NSDate *)updateDateParam
{
    if ((self = [super init])) {
        self.uniqueId = uniqueIdParam;
        self.accountId = accountIdParam;
        self.idPrefix = idPrefixParam;
        self.idSuffix = idSuffixParam;
        self.isDefault = isDefaultParam;
        self.lang = langParam;
        self.password = passwordParam;
        self.port = portParam;
        self.server = serverParam;
        self.encryption = encryptionParam;
        self.updateDate = updateDateParam;
        self.topMailId = topMailIdParam;
        self.mailAccountId = [NSString stringWithFormat:@"%@@%@",accountIdParam,serverParam];
    }
    return self;
}

- (id)initWithUniqueId:(int)uniqueIdParam accountId:(NSString *)accountIdParam topMailId:(NSNumber *)topMailIdParam idPrefix:(NSString *)idPrefixParam idSuffix:(NSString *)idSuffixParam isDefault:(NSNumber *)isDefaultParam lang:(NSString *)langParam password:(NSString *)passwordParam port:(NSString *)portParam server:(NSString *)serverParam encryption:(NSString *)encryptionParam updateDate:(NSDate *)updateDateParam name:(NSString *)nameParam
{
    if ((self = [super init])) {
        self.uniqueId = uniqueIdParam;
        self.accountId = accountIdParam;
        self.idPrefix = idPrefixParam;
        self.idSuffix = idSuffixParam;
        self.isDefault = isDefaultParam;
        self.lang = langParam;
        self.password = passwordParam;
        self.port = portParam;
        self.server = serverParam;
        self.encryption = encryptionParam;
        self.updateDate = updateDateParam;
        self.topMailId = topMailIdParam;
        self.name = nameParam;
        self.mailAccountId = [NSString stringWithFormat:@"%@@%@",accountIdParam,serverParam];
    }
    return self;
}


- (id)initWithName:(NSString *)accountIdParam password:(NSString *)passwordParam port:(NSString *)portParam server:(NSString *)serverParam encryption:(NSString *)encryptionParam name:(NSString *)nameParam idPrefix:(NSString *)idPrefixParam idSuffix:(NSString *)idSuffixParam{
    self = [super init];
    if (self) {
        self.accountId = accountIdParam;
        self.name = nameParam;
        self.password = passwordParam;
        self.port = portParam;
        self.server = serverParam;
        self.encryption = encryptionParam;
        self.idPrefix = idPrefixParam;
        self.idSuffix = idSuffixParam;
    }
    return self;
}

- (id)initWithName:(NSString *)accountIdParam password:(NSString *)passwordParam port:(NSString *)portParam server:(NSString *)serverParam encryption:(NSString *)encryptionParam name:(NSString *)nameParam idPrefix:(NSString *)idPrefixParam idSuffix:(NSString *)idSuffixParam lang:(NSString *)langParam isDefault:(NSNumber *)isDefaultParam{
    self = [super init];
    if (self) {
        self.accountId = accountIdParam;
        self.name = nameParam;
        self.password = passwordParam;
        self.port = portParam;
        self.server = serverParam;
        self.encryption = encryptionParam;
        self.idPrefix = idPrefixParam;
        self.idSuffix = idSuffixParam;
        self.lang = langParam;
        self.isDefault = isDefaultParam;
    }
    return self;
}

- (id)initWithName:(NSString *)accountIdParam password:(NSString *)passwordParam port:(NSString *)portParam server:(NSString *)serverParam encryption:(NSString *)encryptionParam name:(NSString *)nameParam idPrefix:(NSString *)idPrefixParam idSuffix:(NSString *)idSuffixParam lang:(NSString *)langParam isDefault:(NSNumber *)isDefaultParam accountType:(NSNumber *)accountTypeParam{
    self = [super init];
    if (self) {
        self.accountId = accountIdParam;
        self.name = nameParam;
        self.password = passwordParam;
        self.port = portParam;
        self.server = serverParam;
        self.encryption = encryptionParam;
        self.idPrefix = idPrefixParam;
        self.idSuffix = idSuffixParam;
        self.lang = langParam;
        self.isDefault = isDefaultParam;
        self.accountType = accountTypeParam;
    }
    return self;
}

-(id)copyWithZone:(NSZone *)zone {
    LBMailAccountModel *model = [[[self class] allocWithZone:zone] init];
    
    model.uniqueId = self.uniqueId;
    model.name = self.name;
    model.server = self.server;
    model.port = self.port;
    model.encryption = self.encryption;
    model.password = self.password;
    model.accountId = self.accountId;
    model.idPrefix = self.idPrefix;
    model.idSuffix = self.idSuffix;
    //model.beans = [self.beans mutableCopy];

    
    return model;
}


- (id)initWithUniqueId:(int)uniqueIdParam accountId:(NSString *)accountIdParam topMailId:(NSNumber *)topMailIdParam idPrefix:(NSString *)idPrefixParam idSuffix:(NSString *)idSuffixParam isDefault:(NSNumber *)isDefaultParam lang:(NSString *)langParam password:(NSString *)passwordParam port:(NSString *)portParam server:(NSString *)serverParam encryption:(NSString *)encryptionParam updateDate:(NSDate *)updateDateParam name:(NSString *)nameParam accountType:(NSNumber *)accountTypeParam
{
    if ((self = [super init])) {
        self.uniqueId = uniqueIdParam;
        self.accountId = accountIdParam;
        self.idPrefix = idPrefixParam;
        self.idSuffix = idSuffixParam;
        self.isDefault = isDefaultParam;
        self.lang = langParam;
        self.password = passwordParam;
        self.port = portParam;
        self.server = serverParam;
        self.encryption = encryptionParam;
        self.updateDate = updateDateParam;
        self.topMailId = topMailIdParam;
        self.name = nameParam;
        self.accountType =accountTypeParam;
      
        //self.mailAccountId = [NSString stringWithFormat:@"%@@%@",accountIdParam,serverParam];
    }
    return self;
}
@end
