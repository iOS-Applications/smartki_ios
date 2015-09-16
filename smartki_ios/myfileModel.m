//
//  myfileModel.m
//  smartki_ios
//
//  Created by 常炎隆 on 15/9/15.
//  Copyright © 2015年 常炎隆. All rights reserved.
//

#import "myfileModel.h"
#import "HTTP_METHOD.h"

@implementation myfileModel
@synthesize myfileData = _myfileData;

-(void)AFGetMyfileJsonWithURL:(NSString *)url andRequestData:(NSDictionary *)data{
    __weak typeof(self) weakSelf = self;
    
    [HTTP_METHOD HTTP_GET_METHOD_WithURL_DIC:url andRequestData:data callbackMethod:^(NSDictionary *back) {
        [weakSelf.myfileDelegate requestMyfileResult:back];
    }];
}
@end
