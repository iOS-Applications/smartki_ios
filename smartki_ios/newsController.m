//
//  newsController.m
//  smartki_ios
//
//  Created by 常炎隆 on 15/9/15.
//  Copyright © 2015年 常炎隆. All rights reserved.
//

#import "newsController.h"
#import "newsModel.h"
#import "GCD.h"
#import "MBProgressHUD+MJ.h"

#define user            @"user"
#define password        @"password"
#define token           @"token"
#define isLogin         @"isLogin"
#define request_url     @"https://233.smartki.sinaapp.com/smartki_api_view.php"

@interface newsController ()<UITableViewDataSource,UITableViewDelegate,newsModelProtocol>{
    
}
@property (weak, nonatomic) IBOutlet UITableView *newsTableView;
@property newsModel     *newsmode;
@property NSArray       *newsDataArr; // 网络请求回来的json的array记录数据存入这里，之后赋值tableview
@property NSString  *myUser;
@property NSString  *myToken;
@property BOOL      isRefreshing;

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
    BOOL             my_isLogin     = [defaults boolForKey:isLogin];
    
    self.newsmode = [newsModel new];
    self.newsDataArr = [NSArray new];
    
    self.newsTableView.delegate = weakSelf;
    self.newsmode.newsDelegate = weakSelf;
    self.myUser = my_user;
    self.myToken = my_token;
    self.isRefreshing = NO;
//    self.tabBarItem.image = [UIImage imageNamed:@"icon.png"];
    self.tabBarItem.title = @"全站最新";
    
    [self getNewsDataRequestWithUser:weakSelf.myUser andToken:weakSelf.myToken];
}

// 网络请求
-(void)getNewsDataRequestWithUser:(NSString *)userText andToken:(NSString *)tokenText{
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showMessage:@"数据加载中"];
    
    if (self.isRefreshing == NO) {
        self.isRefreshing = YES;
        [GCDQueue executeInGlobalQueue:^{
            [weakSelf.newsmode AFGetNewsJsonWithURL:request_url andRequestData:@{
                                                                                 @"action":@"newsData",
                                                                                 @"user":userText,
                                                                                 @"token":tokenText
                                                                                 }
             ];
        }];
    }
}

#pragma mark newsModelProtocol回调函数
-(void)requestNewsResult:(NSDictionary *)result{

    NSArray *result_Arr = [result objectForKey:@"resp"];
    NSLog(@"newsData result:%@",result_Arr);
    
    __weak typeof(self) weakSelf = self;
    // 处理UI主线程
    [GCDQueue executeInMainQueue:^{
        [MBProgressHUD hideHUD];
        
        // 如果token不对或者网络失败
        if ([[result objectForKey:@"NETBREAK"] isEqualToString:@"NETBREAK"]) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"网络故障"];
            weakSelf.isRefreshing = NO;
            return;
        }
        
        if ([[result objectForKey:@"pass"] isEqualToString:@"false"]) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"加载失败"];
            weakSelf.isRefreshing = NO;
            [weakSelf.navigationController popViewControllerAnimated:YES];
            return;
        }
        
        weakSelf.newsDataArr = [[NSArray alloc]initWithArray:result_Arr copyItems:YES];
        weakSelf.newsTableView.dataSource = weakSelf;
        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccess:@"加载完毕"];
        [weakSelf.newsTableView reloadData]; // 刷新表格
        NSLog(@"self.news :%@,count:%lu",[weakSelf.newsDataArr[0] objectForKey:@"pan_name"],(unsigned long)weakSelf.newsDataArr.count);
        weakSelf.isRefreshing = NO;
    }];
}

#pragma mark 上拉和下拉刷新
-(void)scrollViewDidScroll:(nonnull UIScrollView *)scrollView{
    // 取内容的高度：
    
    //    如果内容高度大于UITableView高度，就取TableView高度
    
    //    如果内容高度小于UITableView高度，就取内容的实际高度
    
    float height = scrollView.contentSize.height > self.newsTableView.frame.size.height ?self.newsTableView.frame.size.height : scrollView.contentSize.height;
    __weak typeof(self) weakSelf = self;
    
    if ((height - scrollView.contentSize.height + scrollView.contentOffset.y) / height > 0.2 && self.isRefreshing == NO) {
        // 调用上拉刷新方法
        NSLog(@"refresh");
    }
    
    if (- scrollView.contentOffset.y / self.newsTableView.frame.size.height > 0.2 && self.isRefreshing == NO) {
        // 调用下拉刷新方法
        NSLog(@"xia refresh");
        [self getNewsDataRequestWithUser:weakSelf.myUser andToken:weakSelf.myToken];
    }
}

-(NSInteger)numberOfSectionsInTableView:(nonnull UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.newsDataArr.count;
}

-(nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    static NSString *ID = @"C1"; // 创建静态缓存池
    
    // 1.从缓存池中取出可循环利用的cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];

    // 2.如果缓存池中没有可循环利用的cell
    if (cell == nil)
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    
    // 设置cell的行数 字体等等
    cell.textLabel.numberOfLines = 4;
    [cell.textLabel setFont:[UIFont boldSystemFontOfSize:18]];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.textAlignment = 1;
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@.%@",[self.newsDataArr[indexPath.row] objectForKey:@"pan_name"],[self.newsDataArr[indexPath.row] objectForKey:@"pan_type"]];
    
    return cell;// web/dodelete.jsp?goodsId=*
}

-(void)tableView:(nonnull UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
}

-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"newsController appear测试");
    
    //    __weak typeof(self) weakSelf = self;
    //    self.newsTableView.dataSource = weakSelf;
    //    self.newsTableView.delegate = weakSelf;
    //    self.newsmode.newsDelegate = weakSelf;
}

-(void)viewDidDisappear:(BOOL)animated{
    //    self.newsTableView.dataSource = nil;
    //    self.newsTableView.delegate = nil;
    //    self.newsmode.newsDelegate = nil;
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
