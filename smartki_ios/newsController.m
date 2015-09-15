//
//  newsController.m
//  smartki_ios
//
//  Created by 常炎隆 on 15/9/15.
//  Copyright © 2015年 常炎隆. All rights reserved.
//

#import "newsController.h"
#import "newsModel.h"

#define user        @"user"
#define password    @"password"
#define token       @"token"
#define isLogin     @"isLogin"

@interface newsController ()<UITableViewDataSource,UITableViewDelegate>{
    
}
@property (weak, nonatomic) IBOutlet UITableView *newsTableView;

@end

@implementation newsController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"newsController测试");
    
    __weak typeof(self) weakSelf = self;
    
    NSUserDefaults  *defaults       = [NSUserDefaults standardUserDefaults];
    NSString        *my_user        = [defaults valueForKey:user];
    NSString        *my_token       = [defaults valueForKey:token];
    NSString        *my_password    = [defaults valueForKey:password];
    BOOL            my_isLogin      = [defaults boolForKey:isLogin];
    
    self.newsTableView.dataSource = weakSelf;
    self.newsTableView.delegate = weakSelf;
    
}

-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"newsController appear测试");
    
    __weak typeof(self) weakSelf = self;
    self.newsTableView.dataSource = weakSelf;
    self.newsTableView.delegate = weakSelf;
}

-(void)viewDidDisappear:(BOOL)animated{
    self.newsTableView.dataSource = nil;
    self.newsTableView.delegate = nil;
}

#pragma mark 上拉和下拉刷新
-(void)scrollViewDidScroll:(nonnull UIScrollView *)scrollView{
    // 取内容的高度：
    
    //    如果内容高度大于UITableView高度，就取TableView高度
    
    //    如果内容高度小于UITableView高度，就取内容的实际高度
    
    float height = scrollView.contentSize.height > self.newsTableView.frame.size.height ?self.newsTableView.frame.size.height : scrollView.contentSize.height;
    
    
    
    if ((height - scrollView.contentSize.height + scrollView.contentOffset.y) / height > 0.2) {
        // 调用上拉刷新方法
        NSLog(@"refresh");
    }
    
    
    
    if (- scrollView.contentOffset.y / self.newsTableView.frame.size.height > 0.2) {
        // 调用下拉刷新方法
        NSLog(@"xia refresh");
    }
}

-(NSInteger)numberOfSectionsInTableView:(nonnull UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return nil;
}

-(nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return nil;
}

-(void)tableView:(nonnull UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{

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
