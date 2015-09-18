//
//  loginController.m
//  smartki_ios
//
//  Created by 常炎隆 on 15/9/14.
//  Copyright © 2015年 常炎隆. All rights reserved.
//

#import "loginController.h"
#import "loginModel.h"
#import "GCD.h"
#import "MBProgressHUD+MJ.h"
#import "CocoaSecurity.h"
#import "mainTabController.h"

#define user        @"user"
#define password    @"password"
#define token       @"token"
#define isLogin     @"isLogin"

@interface loginController ()<UITextFieldDelegate,loginModelProtocol>{

}
@property (weak, nonatomic) IBOutlet UITextField    *userTextfield;
@property (weak, nonatomic) IBOutlet UITextField    *passTextfield;
@property (weak, nonatomic) IBOutlet UISwitch       *remSwitch;
@property (weak, nonatomic) IBOutlet UIView *showView;
@property (weak, nonatomic) IBOutlet UIImageView *showImgView;

@property BOOL          isMoveBack; // 如果为YES，那么当前键盘挡住了输入框，就升起view，到时候退出编辑的时候就利用这个标记来降下view，之后设置isMoveBack为NO
@property loginModel        *loginmodel;
@property mainTabController *mainTabCon;

@end

@implementation loginController

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) weakSelf = self;
    self.passTextfield.secureTextEntry = YES;
    self.loginmodel = [[loginModel alloc]init];
    self.isMoveBack = NO;
    self.userTextfield.delegate = weakSelf;
    self.passTextfield.delegate = weakSelf;
    self.loginmodel.loginDelegate = weakSelf;
    
//    self.showView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"show.png"]];
    self.view.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    self.showImgView.image = [UIImage imageNamed:@"show.png"];
    
    //读取上次配置/***** 密码 *****/
    NSUserDefaults  *defaults       = [NSUserDefaults standardUserDefaults];
    NSString        *my_user        = [defaults valueForKey:user];
    NSString        *my_token       = [defaults valueForKey:token];
    NSString        *my_password    = [defaults valueForKey:password];
    BOOL             my_isLogin     = [defaults boolForKey:isLogin];
    
    if (my_isLogin == YES) {
        NSLog(@"my_isLogin == YES");
        
        NSDictionary *login_user_data = @{
                                          @"user" : my_user,
                                          @"password" : my_password,
                                          @"token": my_token
                                          };
        
        if (weakSelf.mainTabCon == nil) {
            weakSelf.mainTabCon = [weakSelf.storyboard instantiateViewControllerWithIdentifier:@"second"];
            [weakSelf.loginmodel setLoginData:login_user_data];
            [weakSelf.mainTabCon setGetloginCon_Data:weakSelf.loginmodel];
            [weakSelf.navigationController pushViewController:weakSelf.mainTabCon animated:YES];
        }
    }
    NSLog(@"switch %i",self.remSwitch.on);
}

-(void)viewDidAppear:(BOOL)animated{
    __weak typeof(self) weakSelf = self;
    self.isMoveBack = NO;
    self.userTextfield.delegate = weakSelf;
    self.passTextfield.delegate = weakSelf;
    self.loginmodel.loginDelegate = weakSelf;
    
    NSLog(@"appear");
}

-(void)viewDidDisappear:(BOOL)animated{
    self.userTextfield.delegate = nil;
    self.passTextfield.delegate = nil;
    self.loginmodel.loginDelegate = nil;
    
    NSLog(@"disappear");
}

#pragma mark AFNetworking网络请求loginModel的回调函数
-(void)requestResult:(NSDictionary *)result{
    NSLog(@"result:%@",result);
    
    __weak typeof(self) weakSelf = self;
    NSString *result_pass = [result objectForKey:@"pass"]; // pass是用户密码登陆是否正确json的第一判断要素
    NSString *result_NETBREAK = [result objectForKey:@"NETBREAK"]; // 如果网络请求发送失败则有NETBREAK的值
    
    // 处理UI主线程
    [GCDQueue executeInMainQueue:^{
        [MBProgressHUD hideHUD];
        
        if ([result_NETBREAK isEqualToString:@"NETBREAK"]) {
            [MBProgressHUD showError:@"请求失败"];
            
        }else if ([result_pass isEqualToString:@"true"]){
            // 取出用户的数据
            NSDictionary *result_data = [result objectForKey:@"0"];
            // 把数据存入沙盒内
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[result_data objectForKey:@"token"] forKey:token];
            [defaults setObject:[result_data objectForKey:@"user"] forKey:user];
            [defaults setObject:[result_data objectForKey:@"password"] forKey:password];
            
            if (weakSelf.remSwitch.on == 1) {
                NSLog(@"不保存密码");
                [defaults setBool:YES forKey:isLogin];
            }else{
                [defaults setBool:NO forKey:isLogin];
            }
            
            //设置同步
            [defaults synchronize];
            
            // 如果登陆验证成功就跳转到下一个界面
            [MBProgressHUD showSuccess:@"登陆成功"];
            
            if (weakSelf.mainTabCon == nil) {
                weakSelf.mainTabCon = [weakSelf.storyboard instantiateViewControllerWithIdentifier:@"second"];
            }
            
            [weakSelf.loginmodel setLoginData:result_data];
            [weakSelf.mainTabCon setGetloginCon_Data:weakSelf.loginmodel];
            
            [weakSelf.navigationController pushViewController:weakSelf.mainTabCon animated:YES];
            
        }else{
            [MBProgressHUD showError:@"登陆失败"];
        }
    }];
}

#pragma mark 点击登陆按钮
- (IBAction)loginClick {
    __weak typeof(self) weakSelf = self;
    __block CocoaSecurityResult *passwordMD5 = [CocoaSecurity md5:weakSelf.passTextfield.text];
    NSLog(@"password before MD5:%@",weakSelf.passTextfield.text);

    [MBProgressHUD showMessage:@"登录中"];
    // 处理网络等数据线程
    [GCDQueue executeInGlobalQueue:^{
        // IOS9默认https传输才成功
        NSString *url = @"https://233.smartki.sinaapp.com/smartki_api_view.php";
        
        NSDictionary *requestData = @{
                                      @"action":@"login",
                                      @"user":weakSelf.userTextfield.text,
                                      @"password":passwordMD5.hexLower
                                      };
        
        NSLog(@"requestData:%@",requestData);
        
        [self.loginmodel AFGetJsonWithURL:url andRequestData:requestData];
    }];
}

#pragma mark 点击键盘外部
-(void)touchesEnded:(nonnull NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event{
    __weak typeof(self) weakSelf = self;
    
    if(![self.userTextfield isExclusiveTouch])
        [self.userTextfield resignFirstResponder];
    if (![self.passTextfield isExclusiveTouch])
        [self.passTextfield resignFirstResponder];
    
    // 如果textfield被键盘挡住之后view上升的话，这时候复原
    if (self.isMoveBack == YES) {
        CGRect ViewTemp = self.view.frame;
        ViewTemp.origin.y = 0;
        [UIView animateWithDuration:0.2 animations:^{
            weakSelf.view.frame = ViewTemp;
        }];
    }
}

#pragma mark 当开始编辑textField
-(void)textFieldDidBeginEditing:(nonnull UITextField *)textField{
    __weak typeof(self) weakSelf = self;
    
    CGRect ViewTemp = self.view.frame;
    ViewTemp.origin.y = 0;
    
    // 以下为检测textfield是否被虚拟键盘遮住
    CGFloat distance = 0;
    self.isMoveBack = NO;
    CGFloat keyBoardAndTextDis;
    
    if (textField == self.userTextfield)
        keyBoardAndTextDis = self.view.frame.size.height-self.userTextfield.frame.origin.y-self.userTextfield.frame.size.height-35;
    else if (textField == self.passTextfield)
        keyBoardAndTextDis = self.view.frame.size.height-self.passTextfield.frame.origin.y-self.passTextfield.frame.size.height;
    
    if (keyBoardAndTextDis < 216) {
        self.isMoveBack = YES;
        distance = 216 - keyBoardAndTextDis;
        
        ViewTemp.origin.y -= distance;
        [UIView animateWithDuration:0.2 animations:^{
            weakSelf.view.frame = ViewTemp;
        }];
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
