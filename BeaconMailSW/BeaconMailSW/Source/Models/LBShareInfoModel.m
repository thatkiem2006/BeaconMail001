//
//  LBShareInfoModel.m
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

#import "LBShareInfoModel.h"

@implementation LBShareInfoModel

-(id)init {
    if ( self = [super init] ) {
        self.title = @"";
        self.content = @"";
      
    }
    return self;
}

-(id)initWithName:(NSString *)title content:(NSString *)content
{
    self = [super init];
    if (self) {
        self.title = title;
        self.content = content;

    }
    return self;
}

@end
