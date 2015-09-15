//
//  loginModel.h
//  smartki_ios
//
//  Created by 常炎隆 on 15/9/14.
//  Copyright © 2015年 常炎隆. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol loginModelProtocol
// 0.回调的状态
- (void)requestResult:(NSDictionary *)result;
@end

@interface loginModel : NSObject

@property(strong,nonatomic)id<loginModelProtocol>loginDelegate;
@property (nonatomic,retain) NSDictionary *loginData;

-(void)AFGetJsonWithURL:(NSString *)url andRequestData:(NSDictionary *)data;
@end
