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

- (void)viewDidLoad {
    [super viewDidLoad];
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
    CGFloat cellHeight = 44;
    if (indexPath.section == 1) { // 地址
        if ([self.orderDetails.express_id integerValue] == 1) { // 送货
            cellHeight = 180.0f;
        } else { // 自提
            cellHeight = 230.0f;
        }
    } else if (indexPath.section == 2) {
        cellHeight = 125.0f;
    } else if (indexPath.section == 3) {
        
        if (![self.orderDetails.InvoiceTitle isEmpty]) { // 如果有发票信息
            cellHeight = 132.0f;
        }
        
    } else if (indexPath.section == 4) {
        cellHeight = 264.0f;
    }
    return cellHeight;
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
            
            cell.shopAddressLabel.text = [NSString stringWithString:self.orderDetails.addr defaultValue:defaultString];
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
        
        // 自提
        XFOrderDetailsAddressCell *cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XFOrderDetailsAddressCell class]) owner:nil options:nil] lastObject];
        
        cell.shopAddressLabel.text = [NSString stringWithString:self.orderDetails.addr defaultValue:defaultString];
        
        cell.shopPointLabel.text = [NSString stringWithString:self.orderDetails.fendian defaultValue:defaultString];
        cell.shopPhoneNumberLabel.text = [NSString stringWithString:self.orderDetails.tel defaultValue:defaultString];
        cell.customerNameLabel.text = [NSString stringWithString:self.orderDetails.username defaultValue:defaultString];
        cell.customerPhoneNumberLabel.text = [NSString stringWithString:self.orderDetails.telphone defaultValue:defaultString];
        cell.appointmentTimeLabel.text = [NSString stringWithString:self.orderDetails.picktime defaultValue:defaultString];
        cell.remarkLabel.text = [NSString stringWithString:self.orderDetails.message defaultValue:defaultString];
        cell.viewExpressBlock = ^{
            XFExpressDetailsViewController *viewExpressVC = [[XFExpressDetailsViewController alloc] initWithOriginalNo:self.originalNo];
            [self.navigationController pushViewController:viewExpressVC animated:YES];
        };
        return cell;
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

        cell.postageLabel.text = [NSString stringWithString:[NSString stringWithFormat:@"￥%.2f", [self.orderDetails.express_fee floatValue]] defaultValue:@"￥0.00"];
        cell.totalPriceLabel.text = [NSString stringWithString:[NSString stringWithFormat:@"￥%.2f", [self.orderDetails.order_amount floatValue]] defaultValue:@"￥0.00"];
        cell.couponLabel.text = [NSString stringWithString:[NSString stringWithFormat:@"￥%.2f", [self.orderDetails.order_AwardAmount floatValue]] defaultValue:@"￥0.00"];
        
        cell.pointLabel.text = [NSString stringWithString:[NSString stringWithFormat:@"- ￥%.2f", [self.orderDetails.point floatValue] / 100] defaultValue:@"￥0.00"];
        
        cell.priceLabel.text = [NSString stringWithString:[NSString stringWithFormat:@"￥%.2f", [self.orderDetails.payable_amount floatValue]] defaultValue:@"￥0.00"];
        
        // 判断支付方式
        NSString *paymentString = @"";
        int paymentId = [self.orderDetails.payment_id intValue];
        if (paymentId == 2) {
            paymentString = @"余额支付";
        }
        else if (paymentId == 3) {
            paymentString = @"支付宝支付";
        }
        else if (paymentId == 4) {
            paymentString = @"微信支付";
        }
        else if (paymentId == 6) {
            paymentString = @"HD支付宝支付";
        }
        else if (paymentId == 5) {
            paymentString = @"HD微信支付";
        }
        
        cell.paymentTypeLabel.text = paymentString;
        
        return cell;
    }
    return [UITableViewCell new];
}

#pragma mark - Override

- (void)requestData {
    [super requestData];
    [XFProgressHUD showLoading];
    [XFRequestOrderCenter orderDetailsWithOrderId:self.originalId success:^(XFOrderDetailsModel *orderDetailsModel) {
        [XFProgressHUD dismiss];
        orderDetailsModel.express_id = @"1";
        if (!orderDetailsModel) return;
        self.orderDetails = orderDetailsModel;
        [self.tableView reloadData];
    } failure:^(NSError *error, NSInteger statusCode) {
        [self showError:error];
    }];
    
}

- (void)initialize {
    [super initialize];
    self.title = @"订单详情";
}




@end
