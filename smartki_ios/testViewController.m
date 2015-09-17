//
//  testViewController.m
//  smartki_ios
//
//  Created by 常炎隆 on 15/9/16.
//  Copyright © 2015年 常炎隆. All rights reserved.
//

#import "testViewController.h"
#import "MBProgressHUD+MJ.h"

@interface testViewController ()<UIWebViewDelegate>{
    
}
@property (weak, nonatomic) IBOutlet UIWebView *webview;

@end

@implementation testViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *url = @"http://smartki-class.stor.sinaapp.com/150318151509.txt";
    NSURL *theUrl = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:theUrl];
    self.webview.delegate = self;
    [self.webview loadRequest:request];
    // Do any additional setup after loading the view.
}

-(void)webViewDidStartLoad:(nonnull UIWebView *)webView{
    [MBProgressHUD showMessage:@"正在加载"];
}

-(void)webViewDidFinishLoad:(nonnull UIWebView *)webView{
    [MBProgressHUD hideHUD];
    [MBProgressHUD showSuccess:@"加载完毕"];
}

-(void)webView:(nonnull UIWebView *)webView didFailLoadWithError:(nullable NSError *)error{
    [MBProgressHUD hideHUD];
    [MBProgressHUD showError:@"加载失败"];
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
