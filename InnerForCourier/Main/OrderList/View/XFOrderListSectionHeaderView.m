//
//  XFOrderListSectionHeaderView.m
//  InnerForCourier
//
//  Created by DamonLiao on 2017/2/4.
//  Copyright © 2017年 DamonLiao. All rights reserved.
//

#import "XFOrderListSectionHeaderView.h"

@interface XFOrderListSectionHeaderView ()

@property (nonatomic) UIView            *bgView;
@property (nonatomic) UIImageView       *iconImageView;
@property (nonatomic) UILabel           *orderNumberLabel;
@property (nonatomic) UIButton          *operationButton;
@property (nonatomic) UIView            *separatorLine;

@end

@implementation XFOrderListSectionHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (!self) return nil;
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    self.backgroundView = view;
    
    [self addSubviews];
    
    return self;
}

- (void)addSubviews {
    [self.contentView addSubview:self.separatorLine];
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.orderNumberLabel];
    [self.contentView addSubview:self.operationButton];
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)updateConstraints {
    [self.separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self);
        make.height.equalTo(0.5);
        make.left.top.equalTo(0);
        
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.centerY.equalTo(self);
    }];

    [self.orderNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconImageView);
        make.left.equalTo(self.iconImageView.right).offset(10);
    }];
    [self.operationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconImageView);
        make.right.equalTo(self).offset(-15);
    }];
    [super updateConstraints];
}


- (void)setOrderNumber:(NSString *)orderNumber {
    _orderNumber = orderNumber;
    [self.orderNumberLabel setText:_orderNumber];
}

- (void)setOrderStatus:(NSString *)orderStatus {
    _orderStatus = orderStatus;
    self.operationButton.hidden = NO;
    NSString *statusString = @"";
    if ([orderStatus isEqualToString:@"007"]) { // 已出库
        statusString = @"开始配送";
    } else if ([orderStatus isEqualToString:@"008"]) { // 配送中
        statusString = @"配送完成";
    }
    [self.operationButton setTitle:statusString forState:UIControlStateNormal];
    
}

#pragma mark - Custom

- (void)itemTouchUpInside:(UIButton *)sender {
    NSString *title = sender.currentTitle;
    if ([title isEqualToString:@"开始配送"]) {
        if (self.startDeliverBlock) {
            self.startDeliverBlock();
        }
    } else if ([title isEqualToString:@"配送完成"]) {
        if (self.deliveryComplete) {
            self.deliveryComplete();
        }
    }
}

#pragma mark - LazyLoad

- (UIView *)separatorLine {
    if (!_separatorLine) {
        _separatorLine = [UIView new];
        _separatorLine.backgroundColor = [UIColor colorSeparatorLine];
    }
    return _separatorLine;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
        [_iconImageView setImage:[UIImage imageNamed:@"FSMyOrder订单"]];
    }
    return _iconImageView;
}

- (UILabel *)orderNumberLabel {
    if (!_orderNumberLabel) {
        _orderNumberLabel = [UILabel new];
        _orderNumberLabel.font = [UIFont systemFontOfSize:14];
        _orderNumberLabel.textColor = [UIColor colorTextDomina];
    }
    return _orderNumberLabel;
}

- (UIButton *)operationButton {
    if (!_operationButton) {
        _operationButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _operationButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_operationButton setTitleColor:[UIColor colorDomina] forState:UIControlStateNormal];
        [_operationButton addTarget:self action:@selector(itemTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        _operationButton.hidden = YES;
    }
    return _operationButton;
}

@end
