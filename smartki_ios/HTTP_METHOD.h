//
//  HTTP_METHOD.h
//  smartki_ios
//
//  Created by 常炎隆 on 15/9/15.
//  Copyright © 2015年 常炎隆. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface HTTP_METHOD : NSObject

// 默认dictionary
+(void)HTTP_GET_METHOD_WithURL_DIC:(NSString *)url andRequestData:(NSDictionary *)data callbackMethod:(void(^)(NSDictionary *back))block;

+(void)HTTP_GET_METHOD_WithURL_ARR:(NSString *)url andRequestData:(NSDictionary *)data callbackMethod:(void(^)(NSArray *back))block;

+(NSString *)getFileDateName;
@end
