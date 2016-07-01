//
//  ViewController.m
//  Multithreading
//
//  Created by zhengbing on 7/1/16.
//  Copyright © 2016 zhengbing. All rights reserved.
//

#import "ViewController.h"

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
    switch (indexPath.row) {
        case 0:
        {
            [self method1];
        }
            break;
        case 1:
        {
            [self method2];
        }
            break;
        case 2:
        {
            [self method3];
        }
            break;
        case 3:
        {
            [self method4];
        }
            break;
        case 4:
        {
            [self method5];
        }
            break;
        case 5:
        {
            [self method6];
        }
            break;
            
        default:
            break;
    }
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
        _tableViewDataSource = @[@"1 - dispatch_queue_t1",
                                 @"2 - dispatch_queue_t2",
                                 @"3 - dispatch_queue_t3",
                                 @"4 - NSBlockOperation start使用方法",
                                 @"5 - NSOperationQueue1",
                                 @"6 - NSOperationQueue2"];
    }
    return _tableViewDataSource;
}

#pragma mark test method

- (void)method1{
    /**  优先级
     *  #define DISPATCH_QUEUE_PRIORITY_HIGH 2      优先
     *  #define DISPATCH_QUEUE_PRIORITY_DEFAULT 0   正常
     *  #define DISPATCH_QUEUE_PRIORITY_LOW (-2)    低
     *  #define DISPATCH_QUEUE_PRIORITY_BACKGROUND INT16_MIN 后台
     */
    //创建异步队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //往队列里添加线程操作
    dispatch_async(queue, ^{
        NSLog(@"---下载图片1--%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"---下载图片2--%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"---下载图片3--%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"---下载图片4--%@",[NSThread currentThread]);
    });
}

- (void)method2{
    /**
     *  创建串行队列
     *  @param "Myqueue.test" 标识符
     *  @param NULL           一般为NULL
     */
    dispatch_queue_t queue = dispatch_queue_create("Myqueue.test", NULL);
    //开启异步线程
    dispatch_async(queue, ^{
        NSLog(@"---下载图片1--%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"---下载图片2--%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"---下载图片3--%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"---下载图片4--%@",[NSThread currentThread]);
    });
}

- (void)method3{
    //设置异步队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //设置组队列
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, queue, ^{
        NSLog(@"---下载图片1--%@",[NSThread currentThread]);
    });
    dispatch_group_async(group, queue, ^{
        NSLog(@"---下载图片2--%@",[NSThread currentThread]);
    });
    dispatch_group_async(group, queue, ^{
        NSLog(@"---下载图片3--%@",[NSThread currentThread]);
    });
    dispatch_group_async(group, queue, ^{
        NSLog(@"---下载图片4--%@",[NSThread currentThread]);
    });
    //组队列操作执行完成后调用
    dispatch_group_notify(group, queue, ^{
        NSLog(@"下载完成");
    });
}

- (void)method4{
    //NSBlockOperation start使用方法
    dispatch_async(dispatch_queue_create("123", NULL), ^{
        NSBlockOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^{
            NSLog(@"---下载图片1--%@",[NSThread currentThread]);
        }];
        //增加额外线程 addExecutionBlock 额外线程是在operation1主线程执行后 再异步执行
        [operation1 addExecutionBlock:^{
            NSLog(@"---下载图片2--%@",[NSThread currentThread]);
        }];
        [operation1 addExecutionBlock:^{
            NSLog(@"---下载图片3--%@",[NSThread currentThread]);
        }];
        [operation1 addExecutionBlock:^{
            NSLog(@"---下载图片4--%@",[NSThread currentThread]);
        }];
        //用start 直接使用当前线程
        [operation1 start];
    });
}

- (void)method5{
    //创建异步队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    //创建主线程队列
    //    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    //若为主线程 则相当于串行队列
    [queue addOperationWithBlock:^{
        NSLog(@"---下载图片1--%@",[NSThread currentThread]);
    }];
    [queue addOperationWithBlock:^{
        NSLog(@"---下载图片2--%@",[NSThread currentThread]);
    }];
    //创建操作
    NSBlockOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"---下载图片1--%@",[NSThread currentThread]);
    }];
    NSBlockOperation *operation2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"---下载图片2--%@",[NSThread currentThread]);
    }];
    NSBlockOperation *operation3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"---下载图片3--%@",[NSThread currentThread]);
    }];
    NSBlockOperation *operation4 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"---下载图片4--%@",[NSThread currentThread]);
    }];
    //将操作添加进队列
    [queue addOperation:operation1];
    [queue addOperation:operation2];
    [queue addOperation:operation3];
    [queue addOperation:operation4];
}

- (void)method6{
    //创建异步队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    //创建操作
    NSBlockOperation *operationA = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"-----A------");
    }];
    NSBlockOperation *operationB = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"-----B------");
    }];
    NSBlockOperation *operationC = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"-----C------");
    }];
    //设置依赖关系 不能相互依赖
    [operationB addDependency:operationA];
    [operationC addDependency:operationA];
    //将操作写进队列
    [queue addOperation:operationA];
    [queue addOperation:operationB];
    [queue addOperation:operationC];
}


@end
