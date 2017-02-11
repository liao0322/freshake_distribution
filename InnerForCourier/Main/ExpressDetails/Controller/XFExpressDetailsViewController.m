//
//  XFExpressDetailsViewController.m
//  InnerForCourier
//
//  Created by DamonLiao on 2017/2/4.
//  Copyright © 2017年 DamonLiao. All rights reserved.
//

#import "XFExpressDetailsViewController.h"
#import "XFExpressDetailsFirstLineTVCell.h"
#import "XFExpressDetailsTimeLineTVCell.h"
#import "XFRequestOrderCenter.h"
#import "XFExpress.h"

#define MARGIN_LEFT 70.0f

@interface XFExpressDetailsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSMutableArray *dataArray;

@property (copy, nonatomic) NSString *orderStatus;
@property (copy, nonatomic) NSString *originalNo;

@end

@implementation XFExpressDetailsViewController

static NSString * const viewExpressTimeLineTVCellID = @"viewExpressTimeLineTVCellID";
static CGFloat const EstimatedCellHeight = 100.0f;

- (instancetype)initWithOrderStatus:(NSString *)orderStatus originalNo:(NSString *)originalNo {
    self = [super init];
    if (!self) return nil;
    _orderStatus = orderStatus;
    _originalNo = originalNo;
    return self;
}

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - Override

- (void)requestData {
    [super requestData];

    [XFProgressHUD showLoading];
    [XFRequestOrderCenter orderExpressWithOriginalNo:self.originalNo sourceCode:@"1" syscode:@"002" success:^(NSArray *dataArray, NSInteger statusCode) {
        [XFProgressHUD dismiss];
        if (!dataArray) {
            return;
        }
        self.dataArray = [dataArray mutableCopy];
        [self.tableView reloadData];
    } failure:^(NSError *error, NSInteger statusCode) {
        [self showError:error];
    }];
}

- (void)initialize {
    [super initialize];
    self.title = @"查看物流";
    self.tableView.separatorInset = UIEdgeInsetsMake(0, MARGIN_LEFT, 0, 0);
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = EstimatedCellHeight;
}

- (void)registerViews {
    [super registerViews];
    [self.tableView registerClass:[XFExpressDetailsTimeLineTVCell class] forCellReuseIdentifier:viewExpressTimeLineTVCellID];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger sections = 0;
    if (self.dataArray.count) {
        sections = 2;
    }
    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = 1;
    if (section == 1) {
        rows = self.dataArray.count;
    }
    return rows;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        XFExpressDetailsFirstLineTVCell *cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XFExpressDetailsFirstLineTVCell class]) owner:nil options:nil] lastObject];
        if ([self.orderStatus isEqualToString:@"007"]) {
            cell.expressStatusLabel.text = @"未发货";
        } else if ([self.orderStatus isEqualToString:@"008"]) {
            cell.expressStatusLabel.text = @"已发货";
        } else if ([self.orderStatus isEqualToString:@"009"]) {
            cell.expressStatusLabel.text = @"配送完成";
        }
        return cell;
    } else {
        XFExpressDetailsTimeLineTVCell *cell = [tableView dequeueReusableCellWithIdentifier:viewExpressTimeLineTVCellID forIndexPath:indexPath];
        XFExpress *express = self.dataArray[indexPath.row];
        if (indexPath.row == 0) {
            express.first = YES;
        } else  {
            express.first = NO;
        }
        cell.model = express;
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 15.0f;
}

#pragma mark - LazyLoad

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
