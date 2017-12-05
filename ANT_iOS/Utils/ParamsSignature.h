//
//  ParamsSignature.h
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/11/27.
//  Copyright © 2017年 qianmo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParamsSignature : NSObject
- (NSDictionary *)signatureParams:(NSDictionary *)params;
- (NSString *)paramsSignatureString:(NSDictionary *)params;
+ (NSString *)sha1Encode:(NSString *)string;
@end
