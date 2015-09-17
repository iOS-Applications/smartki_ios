//
//  readfileModel.h
//  smartki_ios
//
//  Created by 常炎隆 on 15/9/16.
//  Copyright © 2015年 常炎隆. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol readfileModelProtocol
- (void)requestReadfileResult:(NSDictionary *)result;
@end

@interface readfileModel : NSObject
@property(strong,nonatomic)id<readfileModelProtocol>readfileDelegate;
@property(nonatomic,retain) NSDictionary *readfileData;

-(void)AFGetReadfileJsonWithURL:(NSString *)url andRequestData:(NSDictionary *)data;

@end
