//
//  newsModel.h
//  smartki_ios
//
//  Created by 常炎隆 on 15/9/15.
//  Copyright © 2015年 常炎隆. All rights reserved.
//

#import <Foundation/Foundation.h>

// 这是一个链表的数据模型
@interface newsModel : NSObject{
@public int         id;
@public int         pan_id;
@public NSString    *pan_size;
@public NSString    *pan_time;
@public NSString    *pan_name;
@public NSString    *pan_type;
@public NSString    *pan_url;
@public NSString    *this_user;
@public newsModel   *next;
}

/* 例:
 id = 13;
 "pan_id" = 80;
 "pan_name" = phpAJAXlogin;
 "pan_size" = 31798;
 "pan_time" = 150318151423;
 "pan_type" = zip;
 "pan_url" = "http://smartki-class.stor.sinaapp.com/150318151423.zip";
 user = numberwolf;
 */

@end
