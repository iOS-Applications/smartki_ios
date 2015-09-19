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
#import "readfileModel.h"
#import "readfileController.h"
#import "readimgController.h"
#import "HTTP_METHOD.h"

#define user            @"user"
#define password        @"password"
#define token           @"token"
#define isLogin         @"isLogin"
#define request_url     @"https://233.smartki.sinaapp.com/smartki_api_view.php"

@interface myfileController ()<UITableViewDataSource,UITableViewDelegate>{
    
}
@property (weak, nonatomic) IBOutlet UITableView *myfileTableView;
@property myfileModel           *head;
@property readfileModel         *readfilemodel;

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
    
    self.head = [myfileModel new];
    
    self.myfileTableView.delegate = weakSelf;

    self.start = 0;
    self.num = 15;
    self.isRefreshing = NO;
    self.max_file = -1;
//    self.tabBarItem.image = [UIImage imageNamed:@"icon.png"];
//    self.tabBarItem.title = @"我的文件";

    
    [self getMyfileDataRequestWithUser:self.my_user andToken:self.my_token start:self.start num:self.num];
}

// 网络请求
-(void)getMyfileDataRequestWithUser:(NSString *)userText andToken:(NSString *)tokenText start:(NSInteger)start num:(NSInteger)num{
    __weak typeof(self) weakSelf = self;
    
    if (self.isRefreshing == NO) {
        self.isRefreshing = YES;
        [MBProgressHUD showMessage:@"数据加载中"];
        [GCDQueue executeInGlobalQueue:^{
            [weakSelf AFGetMyfileJsonWithURL:request_url andRequestData:@{
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

-(void)AFGetMyfileJsonWithURL:(NSString *)url andRequestData:(NSDictionary *)data{
    __weak typeof(self) weakSelf = self;
    
    [HTTP_METHOD HTTP_GET_METHOD_WithURL_DIC:url andRequestData:data callbackMethod:^(NSDictionary *back) {
        [weakSelf requestMyfileResult:back];
    }];
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
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                weakSelf.isRefreshing = NO;
            });
            return;
        }
        
        if ([[result objectForKey:@"pass"] isEqualToString:@"false"]) {
            [MBProgressHUD showError:@"您的密码已过期，请重新输入"];
            [self cancelAutoLoginState];
            [weakSelf.navigationController popViewControllerAnimated:YES];
            return;
        }
        
        myfileModel *tempModel = weakSelf.head;
        
        if (weakSelf.max_file <= 1) {
            weakSelf.max_file =[[result objectForKey:@"count"] integerValue];
            
            // 存数据至链表模型
            [weakSelf addDataWithArray:result_Arr andModel:tempModel];
        }else{
            while (tempModel->next) {
                tempModel = tempModel->next;
            }
            
            [weakSelf addDataWithArray:result_Arr andModel:tempModel];
        }
        
        weakSelf.myfileTableView.dataSource = weakSelf;
        
        [MBProgressHUD showSuccess:@"加载完毕"];
        [weakSelf.myfileTableView reloadData];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            weakSelf.isRefreshing = NO;
        });
    }];
}

#pragma mark 填充数据
-(void)addDataWithArray:(NSArray *)array andModel:(myfileModel *)model{
    for (int i = 0; i < array.count; i++) {
        
        model->next = [myfileModel new];
        model->next->id = [[array[i] objectForKey:@"id"] intValue];
        model->next->pan_id = [[array[i] objectForKey:@"pan_id"] intValue];
        model->next->pan_size = [array[i] objectForKey:@"pan_size"];
        model->next->pan_time = [array[i] objectForKey:@"pan_time"];
        model->next->pan_name = [array[i] objectForKey:@"pan_name"];
        model->next->pan_type = [array[i] objectForKey:@"pan_type"];
        model->next->pan_url = [array[i] objectForKey:@"pan_url"];
        model->next->this_user = [array[i] objectForKey:@"user"];
        
        model = model->next;
    }
}

#pragma mark 得到当前显示的数据总量
-(int)getDataCount{
    myfileModel *p = self.head->next;
    int count = 0;
    while (p) {
        count += 1;
        p = p->next;
    }
    
    return count;
}

#pragma mark 上拉和下拉刷新
-(void)scrollViewDidScroll:(nonnull UIScrollView *)scrollView{
    // 取内容的高度：
    
    //    如果内容高度大于UITableView高度，就取TableView高度
    
    //    如果内容高度小于UITableView高度，就取内容的实际高度
    
    float height = scrollView.contentSize.height > self.myfileTableView.frame.size.height ?self.myfileTableView.frame.size.height : scrollView.contentSize.height;
    
    NSLog(@"sel.isRefreshing :%i",self.isRefreshing);
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
        
        [self getMyfileDataRequestWithUser:self.my_user andToken:self.my_token start:self.start num:self.num];
        NSLog(@"request data:%ld,%ld,%@,%@",self.start,self.num,self.my_user,self.my_token);
    }
    
    if (- scrollView.contentOffset.y / self.myfileTableView.frame.size.height > 0.2 && self.isRefreshing == NO) {
        // 调用下拉刷新方法
        [self getMyfileDataRequestWithUser:self.my_user andToken:self.my_token start:self.start num:self.num];
    }
}

-(NSInteger)numberOfSectionsInTableView:(nonnull UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self getDataCount];
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
    
    myfileModel *tempModel = [self getThisRowsData:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@.%@",tempModel->pan_name,tempModel->pan_type];
    
    return cell;
}

#pragma mark 点击读取文件内容
-(void)tableView:(nonnull UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showMessage:@"加载中"];
    self.readfilemodel = [readfileModel new];
    
    myfileModel *fileTempModel = [self getThisRowsData:indexPath.row];
    [GCDQueue executeInGlobalQueue:^{
        NSString *fileType = fileTempModel->pan_type;
        
        // 如果是图片类型的话
        if ([fileType isEqualToString:@"png"] || [fileType isEqualToString:@"jpg"] || [fileType isEqualToString:@"gif"] || [fileType isEqualToString:@"psd"] || [fileType isEqualToString:@"jepg"]) {
            
            readimgController *readimgCon = [weakSelf.storyboard instantiateViewControllerWithIdentifier:@"third_2"];
            
            NSDictionary *imgDataDic = @{
                                         @"url":fileTempModel->pan_url
                                         };
            
            [weakSelf toNextController:readimgCon andData:imgDataDic setDataMethod:^(readfileModel *model) {
                [readimgCon setReadimg_data:model];
            }];
            
            return;
        }
        
        // 如果不是图片的话
        NSString *filename = [NSString stringWithFormat:@"%@.%@",fileTempModel->pan_time,fileType];
        
        [weakSelf AFGetReadfileJsonWithURL:request_url andRequestData:@{
                                                                             @"action":@"readFile",
                                                                             @"user":weakSelf.my_user,
                                                                             @"token":weakSelf.my_token,
                                                                             @"filename":filename
                                                                             }
         ];
    }];
}


#pragma mark 得到readfileController需要的查看的数据
-(void)AFGetReadfileJsonWithURL:(NSString *)url andRequestData:(NSDictionary *)data{
    __weak typeof(self) weakSelf = self;
    
    [HTTP_METHOD HTTP_GET_METHOD_WithURL_DIC:url andRequestData:data callbackMethod:^(NSDictionary *back) {
        [weakSelf requestReadfileResult:back];
    }];
}

#pragma mark 得到该行的数据-链表结点
-(myfileModel *)getThisRowsData:(NSInteger)row{
    myfileModel *p = self.head->next;
    
    for (int i = 0; i < row; i++) {
        p = p->next;
    }
    
    return p;
}

#pragma mark readfileDelegate回调 文件内容json
-(void)requestReadfileResult:(NSDictionary *)result{
    NSLog(@"readfile Result:%@",[result objectForKey:@"filestr"]);
    __weak typeof(self) weakSelf = self;
    
    [GCDQueue executeInMainQueue:^{
        [MBProgressHUD hideHUD];
        
        if ([[result objectForKey:@"pass"] isEqualToString:@"fales"]) {
            [MBProgressHUD showError:@"您的操作已经过期，请重新登录"];
            
            [weakSelf cancelAutoLoginState];
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            return;
        }else if ([[result objectForKey:@"NETBREAK"] isEqualToString:@"NETBREAK"]) {
            [MBProgressHUD showError:@"网络故障"];
        }else{
            readfileController *readfileCon = [weakSelf.storyboard instantiateViewControllerWithIdentifier:@"third_1"];
            
            [weakSelf toNextController:readfileCon andData:result setDataMethod:^(readfileModel *model) {
                [readfileCon setReadfile_data:model];
            }];
        }
    }];
}

#pragma mark 设置跳转下一个controller的数据和控制器 还有设置函数
-(void)toNextController:(UIViewController *)Con andData:(NSDictionary *)dataDic setDataMethod:(void(^)(readfileModel *model))block{
    __weak typeof(self) weakSelf = self;
    
    [self.readfilemodel setReadfileData:dataDic];
    block(weakSelf.readfilemodel);
    
    [self.navigationController pushViewController:Con animated:YES];
}

-(void)cancelAutoLoginState{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // 取消掉自动登陆的key
    [defaults setBool:NO forKey:isLogin];
    //设置同步
    [defaults synchronize];
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
