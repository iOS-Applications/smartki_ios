//
//  UITOOLS_METHOD.m
//  smartki_ios
//
//  Created by 常炎隆 on 15/9/17.
//  Copyright © 2015年 常炎隆. All rights reserved.
//

#import "UITOOLS_METHOD.h"

@implementation UITOOLS_METHOD

+(UIAlertController *)GET_NEW_AlertCon:(NSString *)alertText YES_METHOD:(void (^)())YES_METHOD CANCEL_METHOD:(void (^)())CANCEL_METHOD{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"dsadsa" preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:alertText style:UIAlertActionStyleDestructive handler:^(UIAlertAction * __nonnull action) {
        YES_METHOD();
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * __nonnull action) {
        CANCEL_METHOD();
    }]];
    
    return alert;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
