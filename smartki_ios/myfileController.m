//
//  myfileController.m
//  smartki_ios
//
//  Created by 常炎隆 on 15/9/15.
//  Copyright © 2015年 常炎隆. All rights reserved.
//

#import "myfileController.h"
#import "myfileModel.h"
#import "MBProgressHUD+MJ.h"
#import "GCD.h"

#define user            @"user"
#define password        @"password"
#define token           @"token"
#define isLogin         @"isLogin"
#define request_url     @"https://233.smartki.sinaapp.com/smartki_api_view.php"

@interface myfileController ()<UITableViewDataSource,UITableViewDelegate,myfileModelProtocol>{
    
}
@property (weak, nonatomic) IBOutlet UITableView *myfileTableView;
@property myfileModel           *myfilemodel;
@property NSMutableArray        *myfileDataArr; // 网络请求回来的json的array记录数据存入这里，之后赋值tableview

@property NSInteger     start;  // 获取数据起点
@property NSInteger     num;    // 获取数据的条数
@property NSInteger     max_file; // 所有文件数量
@property NSString      *my_user;
@property NSString      *my_token;
@property BOOL          isRefreshing; // 判断是否在刷新的状态码

@end

@implementation myfileController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"myfileController测试");
    
    __weak typeof(self) weakSelf = self;
    
    NSUserDefaults  *defaults = [NSUserDefaults standardUserDefaults];
    self.my_user        = [defaults valueForKey:user];
    self.my_token       = [defaults valueForKey:token];
    
    self.myfilemodel = [myfileModel new];
    self.myfileDataArr = [NSMutableArray new];
    
    self.myfileTableView.delegate = weakSelf;
    self.myfilemodel.myfileDelegate = weakSelf;
    self.start = 0;
    self.num = 15;
    self.isRefreshing = NO;
    self.max_file = -1;
    
    [self getMyfileDataRequestWithUser:self.my_user andToken:self.my_token start:self.start num:self.num];
}

// 网络请求
-(void)getMyfileDataRequestWithUser:(NSString *)userText andToken:(NSString *)tokenText start:(NSInteger)start num:(NSInteger)num{
    __weak typeof(self) weakSelf = self;
    
    if (self.isRefreshing == NO) {
        self.isRefreshing = YES;
        [MBProgressHUD showMessage:@"数据加载中"];
        [GCDQueue executeInGlobalQueue:^{
            [weakSelf.myfilemodel AFGetMyfileJsonWithURL:request_url andRequestData:@{
                                                                                      @"action":@"getMyfile",
                                                                                      @"user":userText,
                                                                                      @"token":tokenText,
                                                                                      @"start":[NSString stringWithFormat:@"%ld",(long)start],
                                                                                      @"num":[NSString stringWithFormat:@"%ld",(long)num]
                                                                                      }
             ];
        }];
    }
}

-(void)requestMyfileResult:(NSDictionary *)result{
    NSLog(@"myfileController页面的result:%@",result);
    NSArray *result_Arr = [result objectForKey:@"resp"];
    
    __weak typeof(self) weakSelf = self;
    [GCDQueue executeInMainQueue:^{
        [MBProgressHUD hideHUD];
        
        // 如果token不对或者网络失败
        if ([[result objectForKey:@"NETBREAK"] isEqualToString:@"NETBREAK"]) {
            [MBProgressHUD showError:@"网络故障"];
            return;
        }
        
        if ([[result objectForKey:@"pass"] isEqualToString:@"false"]) {
            [MBProgressHUD showError:@"加载失败"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
            return;
        }
        if (weakSelf.myfileDataArr.count <= 1) {
            weakSelf.max_file =[[result objectForKey:@"count"] integerValue];
            weakSelf.myfileDataArr = [[NSMutableArray alloc]initWithArray:result_Arr copyItems:YES];
        }else{
            [weakSelf.myfileDataArr addObjectsFromArray:result_Arr];
        }
        
        weakSelf.myfileTableView.dataSource = weakSelf;
        
        [MBProgressHUD showSuccess:@"加载完毕"];
        [weakSelf.myfileTableView reloadData];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            weakSelf.isRefreshing = NO;
        });
    }];
}

#pragma mark 上拉和下拉刷新
-(void)scrollViewDidScroll:(nonnull UIScrollView *)scrollView{
    // 取内容的高度：
    
    //    如果内容高度大于UITableView高度，就取TableView高度
    
    //    如果内容高度小于UITableView高度，就取内容的实际高度
    
    float height = scrollView.contentSize.height > self.myfileTableView.frame.size.height ?self.myfileTableView.frame.size.height : scrollView.contentSize.height;
    
    if ((height - scrollView.contentSize.height + scrollView.contentOffset.y) / height > 0.2 && self.isRefreshing == NO) {
        // 调用上拉刷新方法
        
        if (self.max_file != -1) {
            
            if (self.num == self.max_file) {
                NSLog(@"1,%ld,%ld",self.num,self.max_file);
                [MBProgressHUD showSuccess:@"已经没有更多的内容了"];
                return;
            }else if ((self.num+15) >= self.max_file){
                self.start = self.num + 1;
                self.num = self.max_file;
            }else{
                self.start = self.num + 1;
                self.num = self.num + 15;
            }
        }
        NSLog(@"refresh");
        
        [self getMyfileDataRequestWithUser:self.my_user andToken:self.my_token start:self.start num:self.num];
        NSLog(@"request data:%ld,%ld,%@,%@",self.start,self.num,self.my_user,self.my_token);
    }
    
    if (- scrollView.contentOffset.y / self.myfileTableView.frame.size.height > 0.2 && self.isRefreshing == NO) {
        // 调用下拉刷新方法
        NSLog(@"xia refresh");
        [self getMyfileDataRequestWithUser:self.my_user andToken:self.my_token start:self.start num:self.num];
    }
}

-(NSInteger)numberOfSectionsInTableView:(nonnull UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.myfileDataArr.count;
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
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@.%@",[self.myfileDataArr[indexPath.row] objectForKey:@"pan_name"],[self.myfileDataArr[indexPath.row] objectForKey:@"pan_type"]];
    
    return cell;
}

-(void)tableView:(nonnull UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
}

-(void)viewDidAppear:(BOOL)animated{
    
}

-(void)viewDidDisappear:(BOOL)animated{
    
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
