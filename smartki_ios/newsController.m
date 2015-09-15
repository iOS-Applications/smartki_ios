//
//  newsController.m
//  smartki_ios
//
//  Created by 常炎隆 on 15/9/15.
//  Copyright © 2015年 常炎隆. All rights reserved.
//

#import "newsController.h"

#define user        @"user"
#define password    @"password"
#define token       @"token"
#define isLogin     @"isLogin"

@interface newsController ()
@property (weak, nonatomic) IBOutlet UITableView *newsTableView;

@end

@implementation newsController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"newsController测试");
    NSUserDefaults  *defaults       = [NSUserDefaults standardUserDefaults];
    NSString        *my_user        = [defaults valueForKey:user];
    NSString        *my_token       = [defaults valueForKey:token];
    NSString        *my_password    = [defaults valueForKey:password];
    BOOL            my_isLogin      = [defaults boolForKey:isLogin];
    
}

-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"newsController appear测试");
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
