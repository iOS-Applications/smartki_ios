//
//  userController.m
//  smartki_ios
//
//  Created by 常炎隆 on 15/9/19.
//  Copyright © 2015年 常炎隆. All rights reserved.
//

#import "userController.h"
#import "userModel.h"

@interface userController ()

@end

@implementation userController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    userModel *head = [userModel new];
    
    userModel *usermodel = [userModel new];
    usermodel->user = 1;
    usermodel->login = 11;
    
    userModel *usermodel_second = [userModel new];
    usermodel_second->user = 2;
    usermodel_second->login = 22;
    
    head->next = usermodel;
    usermodel->next = usermodel_second;
    usermodel_second->next = nil;
    
    userModel *p = head->next;
    while (p) {
        NSLog(@"%d\n",p->user);
        p = p->next;
    }
    
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
