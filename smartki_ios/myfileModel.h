//
//  myfileModel.h
//  smartki_ios
//
//  Created by 常炎隆 on 15/9/15.
//  Copyright © 2015年 常炎隆. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol myfileModelProtocol
- (void)requestMyfileResult:(NSDictionary *)result;
@end

@interface myfileModel : NSObject
@property(strong,nonatomic)id<myfileModelProtocol>myfileDelegate;
@property(nonatomic,retain) NSDictionary *myfileData;

-(void)AFGetMyfileJsonWithURL:(NSString *)url andRequestData:(NSDictionary *)data;

@end
