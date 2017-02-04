//
//  XFOrderListViewController.m
//  InnerForCourier
//
//  Created by DamonLiao on 2017/2/4.
//  Copyright © 2017年 DamonLiao. All rights reserved.
//

#import "XFOrderListViewController.h"
#import "XFLoginViewController.h"
#import "AppDelegate.h"
#import "XFOrderDetailsViewController.h"
#import "XFOrderListTVCell.h"
#import "XFOrderListSectionHeaderView.h"
#import "XFOrderListSectionFooterView.h"

@interface XFOrderListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) UIRefreshControl *refreshControl;

@end

@implementation XFOrderListViewController

static NSString * const OrderListTVCellID = @"OrderListTVCellID";
static NSString * const OrderListSectionHeaderID = @"OrderListSectionHeaderID";
static NSString * const OrderListSectionFooterID = @"OrderListSectionFooterID";

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.refreshControl.refreshing) {
        return;
    }
    
    if (self.tableView.contentOffset.y == -64) {
        [UIView animateWithDuration:0.25
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^(void){
                             self.tableView.contentOffset = CGPointMake(0, -self.refreshControl.frame.size.height - 64);
                         } completion:^(BOOL finished){
                             [self.refreshControl beginRefreshing];
                             [self.refreshControl sendActionsForControlEvents:UIControlEventValueChanged];
                         }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Override

- (void)initialize {
    [super initialize];

}

- (void)setupViews {
    [super setupViews];
    
    self.tableView.refreshControl = self.refreshControl;
}

- (void)registerViews {
    [super registerViews];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XFOrderListTVCell class]) bundle:nil] forCellReuseIdentifier:OrderListTVCellID];
    
    [self.tableView registerClass:[XFOrderListSectionHeaderView class]forHeaderFooterViewReuseIdentifier:OrderListSectionHeaderID];
    
    [self.tableView registerClass:[XFOrderListSectionFooterView class]forHeaderFooterViewReuseIdentifier:OrderListSectionFooterID];
}

#pragma mark - Custom

- (void)refreshData {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self.refreshControl isRefreshing]) {
            [self.refreshControl endRefreshing];
        }
    });
}

- (IBAction)segmentControlValueChanged:(UISegmentedControl *)sender {
    NSLog(@"%ld", sender.selectedSegmentIndex);
}

- (IBAction)logout:(id)sender {
    [[AppDelegate appDelegate] toLogin];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [UITableViewCell new];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XFOrderDetailsViewController *orderDetailsVC = [XFOrderDetailsViewController new];
    [self.navigationController pushViewController:orderDetailsVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    XFOrderListSectionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:OrderListSectionHeaderID];
    headerView.textLabel.text = @"aaa";
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    headerView.backgroundView = view;
    
    return headerView;
}

#pragma mark - LazyLoad

- (UIRefreshControl *)refreshControl {
    if (!_refreshControl) {
        _refreshControl = [UIRefreshControl new];
        [_refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    }
    return _refreshControl;
}


@end
