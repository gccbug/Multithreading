//
//  ViewController.m
//  Multithreading
//
//  Created by zhengbing on 7/1/16.
//  Copyright © 2016 zhengbing. All rights reserved.
//

#import "ViewController.h"
#import "SubViewController.h"

#define CELLID @"ViewController"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSArray *tableViewDataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"多线程教学测试 - Demo"];
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SubViewController *sub = [[SubViewController alloc] init];
    sub.tag = indexPath.row;
    [self.navigationController pushViewController:sub animated:YES];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableViewDataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLID forIndexPath:indexPath];
    cell.textLabel.text = self.tableViewDataSource[indexPath.row];
    cell.backgroundColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1];
    return cell;
}


#pragma mark getter

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CELLID];
    }
    return _tableView;
}

-(NSArray *)tableViewDataSource{
    if (!_tableViewDataSource) {
        _tableViewDataSource = @[@"1",@"2",@"3",@"4"];
    }
    return _tableViewDataSource;
}

@end
