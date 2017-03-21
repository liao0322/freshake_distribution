//
//  XFMeViewController.m
//  InnerForCourier
//
//  Created by DamonLiao on 2017/3/20.
//  Copyright © 2017年 DamonLiao. All rights reserved.
//

#import "XFMeViewController.h"
#import "XFDataStatisticsViewController.h"
#import "AppDelegate.h"

@interface XFMeViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation XFMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [UITableViewCell new];
    cell.textLabel.text = @"订单数据统计";
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XFDataStatisticsViewController *dataStatisticVC = [XFDataStatisticsViewController new];
    dataStatisticVC.title = @"订单数据统计";
    [self.navigationController pushViewController:dataStatisticVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (IBAction)logout:(id)sender {
    [XFKVCPersistence clear];
    [[AppDelegate appDelegate] toLogin];
}

@end
