//
//  loginModel.m
//  smartki_ios
//
//  Created by 常炎隆 on 15/9/14.
//  Copyright © 2015年 常炎隆. All rights reserved.
//

#import "loginModel.h"
#import "HTTP_METHOD.h"

@implementation loginModel
@synthesize loginData = _loginData;

#pragma mark --AFNetworking
-(void)AFGetJsonWithURL:(NSString *)url andRequestData:(NSDictionary *)data{
    __weak typeof(self) weakSelf = self;
    [HTTP_METHOD HTTP_GET_METHOD_WithURL_DIC:url andRequestData:data callbackMethod:^(NSDictionary *back) {
        [weakSelf.loginDelegate requestResult:back];
    }];
}


@end
