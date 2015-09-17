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

@interface readfileController ()
@property (weak, nonatomic) IBOutlet UITextView *fileTextView;
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
