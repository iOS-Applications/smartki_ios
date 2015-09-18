//
//  HTTP_METHOD.m
//  smartki_ios
//

//  Created by 常炎隆 on 15/9/15.
//  Copyright © 2015年 常炎隆. All rights reserved.
//

#import "HTTP_METHOD.h"

@implementation HTTP_METHOD
#pragma mark --AFNetworking
+(void)HTTP_GET_METHOD_WithURL_DIC:(NSString *)url andRequestData:(NSDictionary *)data callbackMethod:(void(^)(NSDictionary *back))block{
    
    [HTTP_METHOD HTTP_GET_METHOD_IN:url andRequestData:data callbackMethod:^(id data) {
        block(data);
    }];
}

+(void)HTTP_GET_METHOD_WithURL_ARR:(NSString *)url andRequestData:(NSDictionary *)data callbackMethod:(void(^)(NSArray *back))block{
    
    [HTTP_METHOD HTTP_GET_METHOD_IN:url andRequestData:data callbackMethod:^(id data) {
        block(data);
    }];
}

+(void)HTTP_GET_METHOD_IN:(NSString *)url andRequestData:(NSDictionary *)data callbackMethod:(void(^)(id data))block{
    // 初始化
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    // 设置回复内容
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    __block NSDictionary *returnDic = [NSDictionary new];
    [manager GET:url parameters:data success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // 成功执行
        // 发送的头部信息
        NSLog(@"%@",operation.request.allHTTPHeaderFields);
        // 服务器返回的头部信息
        NSLog(@"%@",operation.response);
        
        //        NSLog(@"responseObject: %@\n",responseObject);
        
        returnDic = responseObject;
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"回调");
            block(returnDic);
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        returnDic = @{@"NETBREAK":@"NETBREAK"};
        dispatch_async(dispatch_get_main_queue(), ^{
            block(returnDic);
        });
        NSLog(@"responseObject: %@",error);
    }];
}

#pragma mark 利用当前时间生成一个文件名称
+(NSString *)getFileDateName{
    NSDateFormatter *nsdf2 = [[NSDateFormatter alloc] init];
    [nsdf2 setDateStyle:NSDateFormatterShortStyle];
    [nsdf2 setDateFormat:@"YYYYMMDDHHmm"];
    NSString *date = [nsdf2 stringFromDate:[NSDate date]];
    NSString *fileDateName = [NSString stringWithFormat:@"%@.smartki",date];
    
    return fileDateName;
}

@end
