//
//  ParamsSignature.m
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/11/27.
//  Copyright © 2017年 qianmo. All rights reserved.
//

#import "ParamsSignature.h"
#include <CommonCrypto/CommonDigest.h>

@implementation ParamsSignature

- (NSDictionary *)signatureParams:(NSDictionary *)params {
    
    if (![params isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    NSString *str1 = [self paramsSignatureString:params];
    //16位随机数
    char data[16];
    for (int x=0;x<16;data[x++] = (char)('0' + (arc4random_uniform(9))));
    NSString *noncestr = [[NSString alloc] initWithBytes:data length:16 encoding:NSUTF8StringEncoding];
    //当前时间
    NSInteger timestamp = [[NSDate date] timeIntervalSince1970]*1000;
    
    NSString *str2 = [NSString stringWithFormat:@"%@&noncestr=%@&timestamp=%ld",str1,noncestr,timestamp];
    NSString *str3 = [ParamsSignature sha1Encode:str2];
    NSString *signature = str3;
    NSMutableDictionary *newParams = [params mutableCopy];
    newParams[@"noncestr"] = noncestr;
    newParams[@"timestamp"] = [NSString stringWithFormat:@"%ld",timestamp];
    newParams[@"signature"] = signature;
    return newParams;
}

- (NSString *)paramsSignatureString:(NSDictionary *)params {
    
    if (![params isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    NSArray *keyArray = [params allKeys];
    NSArray *sortKeyArray = [keyArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    NSString *str1 = @"";
    for (int i=0; i<sortKeyArray.count; i++) {
        NSString *value = params[sortKeyArray[i]];
        
        if ([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSNull class]]) {
            continue;
        }
        if (i>0 && str1.length) {
            str1 = [str1 stringByAppendingString:@"&"];
        }
        if ([value isKindOfClass:[NSDictionary class]]) {
            value = [self paramsSignatureString:(NSDictionary *)value];
            str1 = [str1 stringByAppendingString:value];
        } else {
            str1 = [str1 stringByAppendingString:[NSString stringWithFormat:@"%@=%@",sortKeyArray[i],value]];
        }
    }
    return str1;
}

+ (NSString *)sha1Encode:(NSString *)string {
    //    const char *cstr = [string cStringUsingEncoding:NSUTF8StringEncoding];
    //    NSData *data = [NSData dataWithBytes:cstr length:string.length];
    
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    //使用对应的CC_SHA1,CC_SHA256,CC_SHA384,CC_SHA512的长度分别是20,32,48,64
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    //使用对应的CC_SHA256,CC_SHA384,CC_SHA512
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

@end
