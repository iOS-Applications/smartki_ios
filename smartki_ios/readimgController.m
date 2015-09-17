//
//  readimgController.m
//  smartki_ios
//
//  Created by 常炎隆 on 15/9/16.
//  Copyright © 2015年 常炎隆. All rights reserved.
//

#import "readimgController.h"
#import "MBProgressHUD+MJ.h"

@interface readimgController ()
@property (weak, nonatomic) IBOutlet UIImageView *readImgView;

@end

@implementation readimgController
@synthesize readimg_data = _readimg_data;
- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) weakSelf = self;
    
    NSString *url = [weakSelf.readimg_data.readfileData objectForKey:@"url"];
    
    NSURL *imgUrl = [NSURL URLWithString:url];
    NSData *imgData = [NSData dataWithContentsOfURL:imgUrl];
    self.readImgView.image = [[UIImage alloc]initWithData:imgData];
    [MBProgressHUD hideHUD];
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
