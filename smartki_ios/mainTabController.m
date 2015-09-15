//
//  mainTabController.m
//  smartki_ios
//
//  Created by 常炎隆 on 15/9/15.
//  Copyright © 2015年 常炎隆. All rights reserved.
//

#import "mainTabController.h"

@interface mainTabController ()

@end

@implementation mainTabController
@synthesize getloginCon_Data = _getloginCon_Data;

- (void)viewDidLoad {
    [super viewDidLoad];
    // 获取的数据 mvc传值
    NSLog(@"main:%@",self.getloginCon_Data.loginData);
}

-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"main测试");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
