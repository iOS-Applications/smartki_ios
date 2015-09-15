//
//  loginModel.m
//  smartki_ios
//
//  Created by 常炎隆 on 15/9/14.
//  Copyright © 2015年 常炎隆. All rights reserved.
//

#import "loginModel.h"
#import "AFNetworking.h"

@implementation loginModel
@synthesize loginData = _loginData;

#pragma mark --AFNetworking
-(void)AFGetJsonWithURL:(NSString *)url andRequestData:(NSDictionary *)data{
    
    // 初始化
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    // 设置回复内容
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    __block NSDictionary *returnDic = [NSDictionary new];
    __weak typeof(self) weakSelf = self;
    [manager GET:url parameters:data success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // 成功执行
        // 发送的头部信息
        NSLog(@"%@",operation.request.allHTTPHeaderFields);
        // 服务器返回的头部信息
        NSLog(@"%@",operation.response);
        
        NSLog(@"responseObject: %@\n",responseObject);
        
        returnDic = responseObject;
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"回调");
            [self.loginDelegate requestResult:returnDic];
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        returnDic = @{@"NETBREAK":@"NETBREAK"};
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.loginDelegate requestResult:returnDic];
        });
        NSLog(@"responseObject: %@",error);
    }];
}


@end
