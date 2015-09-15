//
//  mainTabController.m
//  smartki_ios
//
//  Created by 常炎隆 on 15/9/15.
//  Copyright © 2015年 常炎隆. All rights reserved.
//

#import "mainTabController.h"
#import "HTTP_METHOD.h"
#import "MBProgressHUD+MJ.h"

#define request_url  @"https://233.smartki.sinaapp.com/smartki_api_view.php"

@interface mainTabController (){
    
}
@property mainTabController *mainTab;
@end

@implementation mainTabController
@synthesize getloginCon_Data = _getloginCon_Data;

- (void)viewDidLoad {
    [super viewDidLoad];
    // 获取的数据 mvc传值
    NSLog(@"main:%@",self.getloginCon_Data.loginData);
    __weak typeof(self) weakSelf = self;
    
    NSThread *myThread = [[NSThread alloc] initWithTarget:self selector:@selector(AFGetVarify) object:nil];
    [myThread start];
}

-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"main测试");
}

-(void)AFGetVarify{
    __weak typeof(self) weakSelf = self;
    
    [HTTP_METHOD HTTP_GET_METHOD_WithURL_DIC:request_url andRequestData:@{
                                                                          @"user":[weakSelf.getloginCon_Data.loginData objectForKey:@"user"],
                                                                          @"token":[weakSelf.getloginCon_Data.loginData objectForKey:@"token"]
                                                                          } callbackMethod:^(NSDictionary *back) {
                                                                              [weakSelf getVarifyResult:back];
    }];
}

-(void)getVarifyResult:(NSDictionary *)res{
    if ([[res objectForKey:@"pass"] isEqualToString:@"false"]) {
        [MBProgressHUD showError:@"请重新输入密码"];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
