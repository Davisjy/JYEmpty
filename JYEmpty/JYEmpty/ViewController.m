//
//  ViewController.m
//  JYEmpty
//
//  Created by Davis on 16/9/27.
//  Copyright © 2016年 Davis. All rights reserved.
//

#import "ViewController.h"
#import "JYEmpty.h"

static NSString * const identifier = @"identifier";

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong, nonnull) UITableView *tableView;

@property(nonatomic, strong, nullable) NSMutableArray <NSString *> *dataArray;

/** 清空数据按钮 */
@property (nonatomic, strong) UIButton *clearDataBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    
    [self.clearDataBtn setTitle:@"清空数据" forState:UIControlStateNormal];
    [self.clearDataBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.view addSubview:self.clearDataBtn];
    self.clearDataBtn.frame = CGRectMake(100, 500, 100, 30);
    [self.clearDataBtn addTarget:self action:@selector(clearDataAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self setUpTableView];
    
    self.dataArray = [NSMutableArray arrayWithObjects:@"fds", @"fdjskl", @"fjds", @"fjdkl", nil];
}

- (void)clearDataAction {
    [self.dataArray removeAllObjects];
    // 刷新表格
    [self.tableView reloadData];
}

- (void)setUpTableView
{
    JYEmptyView *noNetworkView = [JYEmptyView showTitle:@"哇哦" details:@"对不起,没有网络\n请检查网络网络是否打开" iconImag:@"placeholder_kickstarter"];
    noNetworkView.backgroundColor = [UIColor whiteColor];
    noNetworkView.refreshBtnClickBlock = ^() {
        NSLog(@"jjjj");
    };
    
    JYEmptyView *emptyView = [JYEmptyView showTitle:@"哇哦" details:@"对不起,没有数据\n没有数据了" iconImag:@"placeholder_kickstarter"];
    emptyView.refreshBtnClickBlock = ^() {
        NSLog(@"哈哈哈哈");
    };
    self.tableView.noNetworkView = noNetworkView;
    self.tableView.emptyView = emptyView;
}

#pragma mark - tableview datasourse delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = (UITableViewCell *)[tableView  dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}

#pragma mark - lazy
- (UITableView *)tableView {
    if (!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (NSMutableArray *)dataArray {
    if(!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (UIButton *)clearDataBtn {
    if (!_clearDataBtn) {
        _clearDataBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _clearDataBtn;
}

@end