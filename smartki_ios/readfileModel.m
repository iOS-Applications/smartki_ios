//
//  readfileModel.m
//  smartki_ios
//
//  Created by 常炎隆 on 15/9/16.
//  Copyright © 2015年 常炎隆. All rights reserved.
//

#import "readfileModel.h"
#import "HTTP_METHOD.h"

@implementation readfileModel
@synthesize readfileData = _readfileData;

-(void)AFGetReadfileJsonWithURL:(NSString *)url andRequestData:(NSDictionary *)data{
    __weak typeof(self) weakSelf = self;
    
    [HTTP_METHOD HTTP_GET_METHOD_WithURL_DIC:url andRequestData:data callbackMethod:^(NSDictionary *back) {
        [weakSelf.readfileDelegate requestReadfileResult:back];
    }];
}

@end
