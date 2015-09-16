//
//  newsModel.h
//  smartki_ios
//
//  Created by 常炎隆 on 15/9/15.
//  Copyright © 2015年 常炎隆. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol newsModelProtocol
- (void)requestNewsResult:(NSDictionary *)result;
@end

@interface newsModel : NSObject
@property(strong,nonatomic)id<newsModelProtocol>newsDelegate;

//@property(nonatomic,retain) NSDictionary *newsData;
-(void)AFGetNewsJsonWithURL:(NSString *)url andRequestData:(NSDictionary *)data;

@end
