//
//  XFOrderDetailsViewController.m
//  InnerForCourier
//
//  Created by DamonLiao on 2017/2/4.
//  Copyright © 2017年 DamonLiao. All rights reserved.
//

#import "XFOrderDetailsViewController.h"
#import "XFRequestOrderCenter.h"
#import "XFOrderDetailsOrderNumberTVCell.h"
#import "XFOrderDetailsAddressCell.h"
#import "XFOrderListTVCell.h"
#import "XFOrderDetailsNoInvoiceCell.h"
#import "XFOrderDetailsInvoiceCell.h"
#import "XFOrderDetailsBasicInfoCell.h"
#import "XFOrderDetailsModel.h"
#import "NSString+Conversion.h"
#import "XFOrderDetailsDeliverAddressTVCell.h"
#import "NSString+Extension.h"
#import "XFExpressDetailsViewController.h"

@interface XFOrderDetailsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) XFOrderDetailsModel *orderDetails;

@end

@implementation XFOrderDetailsViewController

static NSString * const OrderListTVCellID = @"OrderListTVCellID";
static CGFloat const EstimatedCellHeight = 200.0f;

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Override

- (void)initialize {
    [super initialize];
    self.title = @"订单详情";
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = EstimatedCellHeight;
}

- (void)requestData {
    [super requestData];
    [XFProgressHUD showLoading];
    [XFRequestOrderCenter orderDetailsWithOrderId:self.originalId success:^(XFOrderDetailsModel *orderDetailsModel) {
        [XFProgressHUD dismiss];
        if (!orderDetailsModel) return;
        self.orderDetails = orderDetailsModel;
        [self.tableView reloadData];
    } failure:^(NSError *error, NSInteger statusCode) {
        [self showError:error];
    }];
}

- (void)registerViews {
    [super registerViews];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XFOrderListTVCell class]) bundle:nil] forCellReuseIdentifier:OrderListTVCellID];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 8.0f;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger sections = 0;
    if (self.orderDetails) {
        sections = 5;
    }
    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = 1;
    if (section == 2) {
        rows = self.orderDetails.list.count;
    }
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSString *defaultString = @"无";
    
    if (section == 0) {
        XFOrderDetailsOrderNumberTVCell *cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XFOrderDetailsOrderNumberTVCell class]) owner:nil options:nil] lastObject];
        cell.orderNumberLabel.text = self.orderDetails.order_no;
        return cell;
    } else if (section == 1) {
        
        if ([self.orderDetails.express_id integerValue] == 1) { // 送货
            XFOrderDetailsDeliverAddressTVCell *cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XFOrderDetailsDeliverAddressTVCell class]) owner:nil options:nil] lastObject];
            
            cell.shopAddressLabel.text = [NSString stringWithString:self.orderDetails.address defaultValue:defaultString];
            cell.customerNameLabel.text = [NSString stringWithString:self.orderDetails.username defaultValue:defaultString];
            cell.customerPhoneNumberLabel.text = [NSString stringWithString:self.orderDetails.telphone defaultValue:defaultString];
            cell.appointmentTimeLabel.text = [NSString stringWithString:self.orderDetails.DeliveryTime defaultValue:defaultString];
            cell.remarkLabel.text = [NSString stringWithString:self.orderDetails.message defaultValue:defaultString];
            cell.viewExpressBlock = ^{
                XFExpressDetailsViewController *viewExpressVC = [[XFExpressDetailsViewController alloc] initWithOriginalNo:self.originalNo];
                [self.navigationController pushViewController:viewExpressVC animated:YES];
                
            };
            return cell;
            
        }
        
    } else if (section == 2) {
        NSArray *goodsArray = self.orderDetails.list;
        
        XFOrderListTVCell *cell = [tableView dequeueReusableCellWithIdentifier:OrderListTVCellID forIndexPath:indexPath];
        cell.orderDetailsGoodsModel = goodsArray[indexPath.row];
        return cell;
    } else if (section == 3) {
        if (![self.orderDetails.InvoiceTitle isEmpty]) { // 如果有发票信息
            XFOrderDetailsInvoiceCell *cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XFOrderDetailsInvoiceCell class]) owner:nil options:nil] lastObject];
            
            cell.invoiceTypeLabel.text = @"纸质发票";
            cell.invoiceTitleLabel.text = self.orderDetails.InvoiceTitle;
            cell.invoiceContentLabel.text = self.orderDetails.InvoiceContent;
            return cell;
        }
        
        // 无发票信息
        XFOrderDetailsNoInvoiceCell *cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XFOrderDetailsNoInvoiceCell class]) owner:nil options:nil] lastObject];
        return cell;
        
    } else if (section == 4) {
        XFOrderDetailsBasicInfoCell *cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XFOrderDetailsBasicInfoCell class]) owner:nil options:nil] lastObject];

        cell.postageLabel.text = [self stringWithValue:[self.orderDetails.express_fee floatValue]];
        
        cell.totalPriceLabel.text = [self stringWithValue:[self.orderDetails.order_amount floatValue]];
        
        cell.couponLabel.text = [self stringWithValue:[self.orderDetails.order_AwardAmount floatValue]];
        
        cell.pointLabel.text = [NSString stringWithString:[NSString stringWithFormat:@"- ￥%.2f", [self.orderDetails.point floatValue] / 100] defaultValue:@"￥0.00"];
        
        cell.priceLabel.text = [self stringWithValue:[self.orderDetails.payable_amount floatValue]];
        
        cell.paymentTypeLabel.text = [self paymentString];
        
        return cell;
    }
    return [UITableViewCell new];
}

- (NSString *)stringWithValue:(float)value {
    return [NSString stringWithString:[NSString stringWithFormat:@"￥%.2f", value] defaultValue:@"￥0.00"];
}

- (NSString *)paymentString {
    return [[self paymentTypeDict] objectForKey:self.orderDetails.payment_id];
}

- (NSDictionary *)paymentTypeDict {
    return @{
             @"2": @"余额支付",
             @"3": @"支付宝支付",
             @"4": @"微信支付",
             @"5": @"HD微信支付",
             @"6": @"HD支付宝支付"
             };
}





@end
