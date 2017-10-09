//
//  TripleDES.h
//  Test
//
//  Created by Tran Hai Linh on 7/14/15.
//  Copyright (c) 2015 Adnet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TripleDES : NSObject

+ (NSString*) encodeString:(NSString*) inputString withKey:(NSString*) keyString ivKey:(NSString*)ivKeyString;
+ (NSString*) decodeString:(NSString*) inputString withKey:(NSString*) keyString ivKey:(NSString*)ivKeyString;

@end
