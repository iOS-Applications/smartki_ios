//
//  myfileModel.h
//  smartki_ios
//
//  Created by 常炎隆 on 15/9/15.
//  Copyright © 2015年 常炎隆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface myfileModel : NSObject{
@public int         id;
@public int         pan_id;
@public NSString    *pan_size;
@public NSString    *pan_time;
@public NSString    *pan_name;
@public NSString    *pan_type;
@public NSString    *pan_url;
@public NSString    *this_user;
@public myfileModel *next;
}

@end
