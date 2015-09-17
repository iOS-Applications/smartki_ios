//
//  readfileController.m
//  smartki_ios
//
//  Created by 常炎隆 on 15/9/16.
//  Copyright © 2015年 常炎隆. All rights reserved.
//

#import "readfileController.h"
#import "AFDownloadRequestOperation.h"
#import "GCD.h"
#import "MBProgressHUD+MJ.h"
#import "HTTP_METHOD.h"

@interface readfileController ()
@property (weak, nonatomic) IBOutlet UITextView *fileTextView;
@property (weak, nonatomic) IBOutlet UILabel *downPersentLabel;
@property NSString  *file_text;
@property NSString  *download_percent;

@end

@implementation readfileController
@synthesize readfile_data = _readfile_data;

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) weakSelf = self;    
    self.file_text = [weakSelf.readfile_data.readfileData objectForKey:@"filestr"];
    self.fileTextView.text = weakSelf.file_text;
}


#pragma mark 点击下载按钮
- (IBAction)downloadBtnClick {
//    __weak typeof(self) weakSelf = self;
    NSString *url = [self.readfile_data.readfileData objectForKey:@"url"];
    
    NSString *fileIdentifier = [HTTP_METHOD getFileDateName];
    [self downloadMethod:url fileIdentifier:fileIdentifier path:[NSString stringWithFormat:@"/Library/Caches/%@",fileIdentifier]];
}

#pragma mark 实现下载的方法
-(void)downloadMethod:(NSString *)downURL fileIdentifier:(NSString *)fileIdentifier path:(NSString *)path{
    __weak typeof(self) weakSelf = self;
    
    [GCDQueue executeInGlobalQueue:^{
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:downURL]];
        
        AFDownloadRequestOperation *operation = [[AFDownloadRequestOperation alloc] initWithRequest:request
                                                                                     fileIdentifier:fileIdentifier
                                                                                         targetPath:[NSHomeDirectory() stringByAppendingPathComponent:path]
                                                                                       shouldResume:YES];
        operation.shouldOverwrite = YES;
        
        // 开始下载
        [operation start];
        
//        // 4s后暂停
//        [GCDQueue executeInMainQueue:^{
//            NSLog(@"暂停");
//            [operation pause];
//        } afterDelaySecs:4.f];
//        
//        // 7s后继续恢复
//        [GCDQueue executeInMainQueue:^{
//            NSLog(@"开始");
//            [operation resume];
//        } afterDelaySecs:7.f];
        
        // 查看下载进度
        [GCDQueue executeInMainQueue:^{
            [operation setProgressiveDownloadProgressBlock:^(AFDownloadRequestOperation *operation, NSInteger bytesRead, long long totalBytesRead, long long totalBytesExpected, long long totalBytesReadForFile, long long totalBytesExpectedToReadForFile) {
                
                CGFloat percent = (float)totalBytesReadForFile / (float)totalBytesExpectedToReadForFile;
                NSLog(@"百分比:%.3f%% %ld  %lld  %lld  %lld", percent * 100, (long)bytesRead, totalBytesRead, totalBytesReadForFile, totalBytesExpectedToReadForFile);
                
                weakSelf.downPersentLabel.text = [NSString stringWithFormat:@"已经下载:%.3f%%",percent*100];
            }];
            
            // 结束block
            [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSLog(@"下载成功 %@", responseObject);
                weakSelf.downPersentLabel.text = @"下载成功";
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                NSLog(@"下载失败 %@", error);
                weakSelf.downPersentLabel.text = @"下载失败";
                
            }];
        }];
    }];
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
