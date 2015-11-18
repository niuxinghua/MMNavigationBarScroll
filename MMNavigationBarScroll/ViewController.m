//
//  ViewController.m
//  NavigationBarHideDemo
//
//  Created by zlmg on 11/11/15.
//  Copyright © 2015 zlmg. All rights reserved.
//

#import "ViewController.h"
//#import "TLYShyNavBarManager.h"
#import "UIViewController+NavigationBarScroll.h"

static NSString * const KCellReuseId = @"uitableViewCellReuseId";

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"tes title";
    [self.view addSubview:self.tableView];
    
    self.mm_ScrollView = self.tableView;
    
    //    self.shyNavBarManager.stickyExtensionView = YES;
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self showNavigationAndStateBar];
}

-(void)dealloc
{
    [self removeScrollViewObserver];
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 11;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20)];
    headerView.backgroundColor = [UIColor redColor];
    return headerView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KCellReuseId];
    cell.textLabel.text = [NSString stringWithFormat:@"section:%ld,row:%ld",indexPath.section,indexPath.row];
    return cell;
}

#pragma  mark - getter
-(UITableView *)tableView
{
    if (nil == _tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:KCellReuseId];
        
    }
    return _tableView;
}


@end
