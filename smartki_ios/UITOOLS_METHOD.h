//
//  UITOOLS_METHOD.h
//  smartki_ios
//
//  Created by 常炎隆 on 15/9/17.
//  Copyright © 2015年 常炎隆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITOOLS_METHOD : UIView

#pragma mark 得到一个警告框 有确认和取消
+(UIAlertController *)GET_NEW_AlertCon:(NSString *)alertText YES_METHOD:(void(^)())YES_METHOD CANCEL_METHOD:(void(^)())CANCEL_METHOD;

@end
