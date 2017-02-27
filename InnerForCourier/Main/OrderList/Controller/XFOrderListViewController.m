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
#import "XFExpressDetailsViewController.h"
#import "XFOrderListTVCell.h"
#import "XFOrderListSectionHeaderView.h"
#import "XFOrderListSectionFooterView.h"
#import "XFRequestOrderCenter.h"
#import "XFOrder.h"
#import "XFGoods.h"
#import <MJRefresh.h>
#import "XFNoDataView.h"

#define UNDELIVERY @"007"
#define ONDELIVERY @"008"
#define DELIVERY_COMPLETE @"009"

#define PAGE_LIMIT 20

@interface XFOrderListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) UIRefreshControl *refreshControl;
@property (nonatomic) NSMutableArray *dataArray;
@property (copy, nonatomic) NSString *orderStatus;
@property (nonatomic) MJRefreshAutoNormalFooter *refreshFooter;
@property (assign, nonatomic) NSInteger page;
@property (assign, nonatomic) BOOL noMore;
@property (nonatomic) XFNoDataView *noDataView;
@property (copy, nonatomic) NSString *orderSort;

@end

@implementation XFOrderListViewController

static NSString * const OrderListTVCellID = @"OrderListTVCellID";
static NSString * const OrderListSectionHeaderID = @"OrderListSectionHeaderID";
static NSString * const OrderListSectionFooterID = @"OrderListSectionFooterID";

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [XFProgressHUD showLoading];
    [self refreshData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    self.dataArray = nil;
    [self.tableView reloadData];
}

#pragma mark - Override

- (void)initialize {
    [super initialize];
    self.orderStatus = UNDELIVERY;
    self.page = 1;
    self.noMore = NO;
}

- (void)setupViews {
    [super setupViews];
    
    self.tableView.refreshControl = self.refreshControl;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, -10, 0, 0);
    self.tableView.mj_footer = self.refreshFooter;
}

- (void)registerViews {
    [super registerViews];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XFOrderListTVCell class]) bundle:nil] forCellReuseIdentifier:OrderListTVCellID];
    
    [self.tableView registerClass:[XFOrderListSectionHeaderView class]forHeaderFooterViewReuseIdentifier:OrderListSectionHeaderID];
    
    [self.tableView registerClass:[XFOrderListSectionFooterView class]forHeaderFooterViewReuseIdentifier:OrderListSectionFooterID];
}

#pragma mark - Custom

- (void)refreshData {
    self.page = 1;
    self.noMore = NO;
    
    [self.refreshFooter resetNoMoreData];
    [self requestDataOnPage:self.page refresh:YES];
    
}

- (void)loadMoreData {
    if (self.noMore == YES) { // 没有更多
        if ([self.refreshFooter isRefreshing]) {
            [self.refreshFooter endRefreshingWithNoMoreData];
        }
    } else {
        [self requestDataOnPage:(self.page + 1) refresh:NO];
    }
    
}

- (void)requestDidCompleted {
    if ([self.refreshControl isRefreshing]) {
        [self.refreshControl endRefreshing];
    }
    if ([self.refreshFooter isRefreshing]) {
        [self.refreshFooter endRefreshing];
    }
}

- (void)requestDataOnPage:(NSInteger)page refresh:(BOOL)refresh {
    
    [XFRequestOrderCenter orderListWithPageNum:page pageSize:PAGE_LIMIT shopid:[XFKVCPersistence get:KEY_USER_OWNERID] orderStatus:self.orderStatus orderSort:self.orderSort success:^(NSArray *dataArray, NSInteger statusCode) {
        [XFProgressHUD dismiss];
        [self requestDidCompleted];
        
        if (statusCode != 200) {
            [XFProgressHUD showMessage:@"返回异常"];
            return;
        }
        if (dataArray == nil || dataArray.count == 0) {
            self.noMore = YES;
            [self.refreshFooter endRefreshingWithNoMoreData];
            [self.dataArray removeAllObjects];
            [self.tableView reloadData];
            return;
        }
        
        if (refresh) { // 刷新
            self.dataArray = [dataArray mutableCopy];
        } else {
            self.page++;
            [self.dataArray addObjectsFromArray:dataArray];
        }
        if (dataArray.count < PAGE_LIMIT) {
            self.noMore = YES;
        }
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error, NSInteger statusCode) {
        [self showError:error];
        [self requestDidCompleted];
        [self.dataArray removeAllObjects];
        [self.tableView reloadData];
    }];
}

- (IBAction)segmentControlValueChanged:(UISegmentedControl *)sender {
    NSInteger selectedIndex = sender.selectedSegmentIndex;
    if (selectedIndex == 0) {
        self.orderStatus = UNDELIVERY;
    } else if (selectedIndex == 1) {
        self.orderStatus = ONDELIVERY;
    } else if (selectedIndex == 2) {
        self.orderStatus = DELIVERY_COMPLETE;
    }
    [XFProgressHUD showLoading];
    [self refreshData];

}

- (IBAction)logout:(id)sender {
    [XFKVCPersistence clear];
    [[AppDelegate appDelegate] toLogin];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    self.refreshFooter.hidden = self.dataArray.count == 0;
    self.tableView.backgroundView = self.dataArray.count == 0 ? self.noDataView : nil;
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    XFOrder *order = self.dataArray[section];
    return order.goods.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XFOrder *order = self.dataArray[indexPath.section];
    XFGoods *goods = order.goods[indexPath.row];
    
    XFOrderListTVCell *cell = [tableView dequeueReusableCellWithIdentifier:OrderListTVCellID forIndexPath:indexPath];
    cell.model = goods;
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 125.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 88.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    XFOrder *order = self.dataArray[section];
    XFOrderListSectionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:OrderListSectionHeaderID];
    headerView.orderNumber = order.originalNo;
    headerView.orderStatus = order.orderStatus;
    headerView.startDeliverBlock = ^{
        [XFRequestOrderCenter orderOperationWithSyscode:@"002" originalNo:order.originalNo sourceCode:@"1" usercode:[XFKVCPersistence get:KEY_ACCOUNT] bizcode:@"DELV" success:^() {
            [self.dataArray removeObject:order];
            [self.tableView reloadData];
        } failure:^(NSError *error, NSInteger statusCode) {
            [self showError:error];
        }];
    };
    headerView.deliveryComplete = ^{
        [XFRequestOrderCenter orderOperationWithSyscode:@"002" originalNo:order.originalNo sourceCode:@"1" usercode:[XFKVCPersistence get:KEY_ACCOUNT] bizcode:@"FINH" success:^() {
            NSLog(@"");
            [self.dataArray removeObject:order];
            [self.tableView reloadData];
        } failure:^(NSError *error, NSInteger statusCode) {
            [self showError:error];
        }];
    };
    
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    XFOrder *order = self.dataArray[section];
    XFOrderListSectionFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:OrderListSectionFooterID];
    footerView.model = order;
    
    footerView.viewOrderDetailsBlock = ^{
        
        XFOrderDetailsViewController *orderDetailsVC = [XFOrderDetailsViewController new];
        orderDetailsVC.originalNo = order.originalNo;
        orderDetailsVC.originalId = order.originalId;
        orderDetailsVC.orderStatus = self.orderStatus;
        [self.navigationController pushViewController:orderDetailsVC animated:YES];

    };
    
    footerView.viewExpressBlock = ^{
        XFExpressDetailsViewController *viewExpressVC = [[XFExpressDetailsViewController alloc] initWithOriginalNo:order.originalNo];
        [self.navigationController pushViewController:viewExpressVC animated:YES];
    };
    
    return footerView;
}

#pragma mark - LazyLoad

- (UIRefreshControl *)refreshControl {
    if (!_refreshControl) {
        _refreshControl = [UIRefreshControl new];
        [_refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    }
    return _refreshControl;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (MJRefreshAutoNormalFooter *)refreshFooter {
    if (!_refreshFooter) {
        _refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        _refreshFooter.refreshingTitleHidden = YES;
        [_refreshFooter setTitle:@"点击或上拉加载更多订单" forState:MJRefreshStateIdle];
        [_refreshFooter setTitle:@"没有更多订单" forState:MJRefreshStateNoMoreData];
    }
    return _refreshFooter;
}

- (XFNoDataView *)noDataView {
    if (!_noDataView) {
        _noDataView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XFNoDataView class]) owner:nil options:nil] lastObject];
    }
    return _noDataView;
}

- (NSString *)orderSort {
    return [self.orderStatus isEqualToString:DELIVERY_COMPLETE] ? @"desc" : @"asc";
}

@end
