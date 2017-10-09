//
//  TripleDES.m
//  Test
//
//  Created by Tran Hai Linh on 7/14/15.
//  Copyright (c) 2015 Adnet. All rights reserved.
//

#import "TripleDES.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <Security/Security.h>


@implementation TripleDES

#pragma mark
+ (NSString*) encodeString:(NSString*) inputString withKey:(NSString*) keyString ivKey:(NSString*)ivKeyString
{
    
    // check length
    if (inputString.length > 16) {
        return @"";
    }
    
    // convert input string
    int length = (int) inputString.length/2;
    NSMutableData *data = [[NSMutableData alloc] init];
    for (int index = 0; index < length; index ++) {
        NSString* subString = [inputString substringWithRange:NSMakeRange(index *2, 2)];
        Byte number =  [TripleDES byteParseWithHex:subString];
        const char charBytes[] = {number};
        NSData * data1 = [NSData dataWithBytes:charBytes length:1];
        [data appendData:data1];
        
    }
    
    // encript without paddding
    NSData *encriptdata = [self tripleDesEncrypt:YES data:data key:keyString ivKey:ivKeyString padding:NO error:nil];
    NSString *encodeString = [TripleDES convertDataToHexString:encriptdata];
    
    // return
    return encodeString;
}

+ (NSString*) decodeString:(NSString*) encodeString withKey:(NSString*) keyString ivKey:(NSString*)ivKeyString
{
    NSData *encriptdata = [self convertHexStringToData:encodeString];
    
    NSData *decodeData = [self tripleDesEncrypt:NO data:encriptdata key:keyString ivKey:ivKeyString padding:NO error:nil];
    //
    NSUInteger len = [decodeData length];
    Byte *byteData = (Byte*)malloc(len);
    memcpy(byteData, [decodeData bytes], len);
    NSString* decodeString = @"";
    for (int index = 0; index < len; index ++) {
        NSString* subString = [NSString stringWithFormat:@"%02x", (unsigned int) byteData[index]];
        decodeString = [NSString stringWithFormat:@"%@%@", decodeString,subString];
    }
    
    // return
    return decodeString;
}

#pragma mark
+ (NSString *) convertDataToHexString:(NSData*) data {
    /* Returns hexadecimal string of NSData. Empty string if data is empty.   */
    
    const unsigned char *dataBuffer = (const unsigned char *)[data bytes];
    
    if (!dataBuffer)
        return [NSString string];
    
    NSUInteger          dataLength  = [data length];
    NSMutableString     *hexString  = [NSMutableString stringWithCapacity:(dataLength * 2)];
    
    for (int i = 0; i < dataLength; ++i)
        [hexString appendString:[NSString stringWithFormat:@"%02lx", (unsigned long)dataBuffer[i]]];
    
    return [NSString stringWithString:hexString];
}

+ (NSData *) convertHexStringToData:(NSString*) inputString {
    
    
    NSMutableData *data= [[NSMutableData alloc] init];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for (i=0; i < [inputString length]/2; i++) {
        byte_chars[0] = [inputString characterAtIndex:i*2];
        byte_chars[1] = [inputString characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [data appendBytes:&whole_byte length:1];
    }
    
    return data;
}


+ (unsigned) byteParseWithHex:(NSString*) inputString
{
    
    //    NSString* inputString = [NSString stringWithFormat:@"%@",number];
    unsigned result = 0;
    NSScanner *scanner = [NSScanner scannerWithString:inputString];
    
    [scanner setScanLocation:0]; // bypass '#' character
    [scanner scanHexInt:&result];
    
    return result;
    
}

#pragma mark
+(NSData*)tripleDesEncrypt:(BOOL)encrypt
                      data:(NSData *)inputData
                       key:(NSString* ) keyString
                        ivKey:(NSString* ) keyIvString
                   padding:(BOOL) isPadding
                     error:(NSError **)error
{
    
    // convert key to data
    NSData* keyData = [keyString dataUsingEncoding:NSASCIIStringEncoding];
    NSData* ivKeyData = [keyIvString dataUsingEncoding:NSASCIIStringEncoding];
    
    // data moved
    size_t dataMoved;
    size_t encryptionBufferLen = inputData.length + kCCBlockSize3DES;
    void* encryptedBuffer = malloc(encryptionBufferLen);
    memset(encryptedBuffer, 0, encryptionBufferLen);
    
    // check option
    CCOptions options = 0;
    if (isPadding == YES) {
        options = kCCOptionPKCS7Padding;
    }
    
    CCCryptorStatus result;
    result = CCCrypt(encrypt ? kCCEncrypt : kCCDecrypt, // operation
                     kCCAlgorithm3DES, // Algorithm
                     options, // options
                     [keyData bytes], // key
                     keyData.length, // keylength
                     [ivKeyData bytes],// iv
                     inputData.bytes, // dataIn
                     inputData.length, // dataInLength,
                     encryptedBuffer, // dataOut
                     encryptionBufferLen, // dataOutAvailable
                     &dataMoved); // dataOutMoved
    
    NSData* outputData = [NSData dataWithBytes:encryptedBuffer length:dataMoved];
    free(encryptedBuffer);
    
    return outputData;
}


@end
