//
//  readimgController.m
//  smartki_ios
//
//  Created by 常炎隆 on 15/9/16.
//  Copyright © 2015年 常炎隆. All rights reserved.
//

#import "readimgController.h"
#import "MBProgressHUD+MJ.h"
#import "GCD.h"
#import "AFDownloadRequestOperation.h"
#import "HTTP_METHOD.h"

@interface readimgController ()
@property (weak, nonatomic) IBOutlet UIImageView *readImgView;
@property (weak, nonatomic) IBOutlet UILabel *downloadLabel;
@property NSString  *imgURL;

@end

@implementation readimgController
@synthesize readimg_data = _readimg_data;

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) weakSelf = self;
    
    self.imgURL = [weakSelf.readimg_data.readfileData objectForKey:@"url"];
    
    NSURL *imgUrl = [NSURL URLWithString:self.imgURL];
    NSData *imgData = [NSData dataWithContentsOfURL:imgUrl];
    self.readImgView.image = [[UIImage alloc]initWithData:imgData];
    
    [MBProgressHUD hideHUD];
}

- (IBAction)downBtnClick:(id)sender {
    __weak typeof(self) weakSelf = self;
    NSString *fileIdentifier = [HTTP_METHOD getFileDateName];
    [self downloadMethod:weakSelf.imgURL fileIdentifier:fileIdentifier path:[NSString stringWithFormat:@"/Library/Caches/%@",fileIdentifier]];
}

#pragma mark --和readfileController里面一样的下载方法  这个我懒得写delegate 回调和封装了!时间就这么点，哥不想写
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
        
        // 查看下载进度
        [GCDQueue executeInMainQueue:^{
            [operation setProgressiveDownloadProgressBlock:^(AFDownloadRequestOperation *operation, NSInteger bytesRead, long long totalBytesRead, long long totalBytesExpected, long long totalBytesReadForFile, long long totalBytesExpectedToReadForFile) {
                
                CGFloat percent = (float)totalBytesReadForFile / (float)totalBytesExpectedToReadForFile;
                NSLog(@"百分比:%.3f%% %ld  %lld  %lld  %lld", percent * 100, (long)bytesRead, totalBytesRead, totalBytesReadForFile, totalBytesExpectedToReadForFile);
                
                weakSelf.downloadLabel.text = [NSString stringWithFormat:@"已经下载:%.3f%%",percent*100];
            }];
            
            // 结束block
            [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSLog(@"下载成功 %@", responseObject);
                weakSelf.downloadLabel.text = @"下载成功";
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                NSLog(@"下载失败 %@", error);
                weakSelf.downloadLabel.text = @"下载失败";
                
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
