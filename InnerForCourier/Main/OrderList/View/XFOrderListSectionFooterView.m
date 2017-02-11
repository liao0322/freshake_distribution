//
//  XFOrderListSectionFooterView.m
//  InnerForCourier
//
//  Created by DamonLiao on 2017/2/4.
//  Copyright © 2017年 DamonLiao. All rights reserved.
//

#import "XFOrderListSectionFooterView.h"
#import "XFOrder.h"

@interface XFOrderListSectionFooterView ()

@property (nonatomic) UIView *bgView;

@property (nonatomic) UILabel *totalCountTitleLabel;
@property (nonatomic) UILabel *totalCountLabel;

@property (nonatomic) UILabel *totalPriceTitleLabel;
@property (nonatomic) UILabel *totalPriceLabel;

@property (copy, nonatomic) NSMutableArray *titles;
@property (copy, nonatomic) NSMutableArray *buttons;

@property (nonatomic) UIView *separatorLineOne;

@end

@implementation XFOrderListSectionFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self addSubviews];
        [self makeConstraints];

    }
    return self;
}

- (void)addSubviews {
    [self.contentView addSubview:self.bgView];
    
    [self.bgView addSubview:self.totalCountTitleLabel];
    [self.bgView addSubview:self.totalCountLabel];
    [self.bgView addSubview:self.totalPriceTitleLabel];
    [self.bgView addSubview:self.totalPriceLabel];
    [self.bgView addSubview:self.separatorLineOne];
    
    [self addButtons];
}

- (void)makeConstraints {
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self);
        make.height.equalTo(self).offset(-10);
        make.left.equalTo(@0);
        make.top.equalTo(@0);
    }];
    
    [self.totalCountTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.equalTo(@8);
    }];
    [self.totalCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.totalCountTitleLabel.mas_right);
        make.top.equalTo(self.totalCountTitleLabel);
    }];
    
    [self.totalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.top.equalTo(self.totalCountTitleLabel);
    }];

    [self.totalPriceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.totalPriceLabel.mas_left);
        make.top.equalTo(self.totalCountTitleLabel);
    }];
    [self.separatorLineOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.left.equalTo(self);
        make.height.equalTo(@0.5);
        make.top.equalTo(self.totalCountTitleLabel.mas_bottom).offset(8);
    }];
    
    CGFloat buttonWidth = 69;
    CGFloat buttonHeight = 28;
    [self.buttons enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = obj;
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(buttonWidth));
            make.height.equalTo(@(buttonHeight));
            make.top.equalTo(self.separatorLineOne.mas_bottom).offset(8);
        }];
        
        if (idx == 0) {
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self).offset(-15);
            }];
        } else {
            UIButton *previouButton = self.buttons[idx - 1];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(previouButton).offset(-(buttonWidth + 6));
            }];
        }
    }];
}

- (void)addButtons {

    [self.titles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *title = obj;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = idx;
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorTextDomina] forState:UIControlStateNormal];
        
        // 边框和圆角
        button.layer.borderColor = [UIColor colorDomina].CGColor;
        button.layer.borderWidth = 0.5;
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        
        [button addTarget:self action:@selector(itemTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.buttons addObject:button];
        [self.contentView addSubview:button];
    }];
}


- (void)updateConstraints {
    [super updateConstraints];
}

- (void)setModel:(XFOrder *)model {
    _model = model;
    
    self.totalCountLabel.text = [NSString stringWithFormat:@"%zd 件商品",_model.goods.count];
    
    NSString *priceString = [NSString stringWithFormat:@"￥%.2f",[_model.orderAmt floatValue]];
    self.totalPriceLabel.text = priceString;

}

#pragma mark - Custom

- (void)itemTouchUpInside:(UIButton *)sender {
    NSString *title = sender.currentTitle;
    if ([title isEqualToString:@"订单详情"]) {
        if (self.viewOrderDetailsBlock) {
            self.viewOrderDetailsBlock();
        }
    } else if ([title isEqualToString:@"查看物流"]) {
        if (self.viewExpressBlock) {
            self.viewExpressBlock();
        }
    }
    NSLog(@"%@", sender.currentTitle);
}

#pragma mark - LazyLoad

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (UILabel *)totalCountTitleLabel {
    if (!_totalCountTitleLabel) {
        _totalCountTitleLabel = [UILabel new];
        _totalCountTitleLabel.text = @"总计：";
        _totalCountTitleLabel.font = [UIFont systemFontOfSize:14];
        _totalCountTitleLabel.textColor = [UIColor colorTextDomina];
    }
    return _totalCountTitleLabel;
}

- (UILabel *)totalPriceTitleLabel {
    if (!_totalPriceTitleLabel) {
        _totalPriceTitleLabel = [UILabel new];
        _totalPriceTitleLabel.text = @"总价：";
        _totalPriceTitleLabel.font = [UIFont systemFontOfSize:14];
        _totalPriceTitleLabel.textColor = [UIColor colorTextDomina];
    }
    return _totalPriceTitleLabel;
}

- (UILabel *)totalCountLabel {
    if (!_totalCountLabel) {
        _totalCountLabel = [UILabel new];
        _totalCountLabel.text = @"1件商品";
        _totalCountLabel.font = [UIFont systemFontOfSize:14];
        _totalCountLabel.textColor = [UIColor colorTextDomina];
    }
    return _totalCountLabel;
}

- (UILabel *)totalPriceLabel {
    if (!_totalPriceLabel) {
        _totalPriceLabel = [UILabel new];
        _totalPriceLabel.text = @"￥15.50";
        _totalPriceLabel.font = [UIFont boldSystemFontOfSize:14];
        
        _totalPriceLabel.textColor = [UIColor orangeColor];
    }
    return _totalPriceLabel;
}

- (UIView *)separatorLineOne {
    if (!_separatorLineOne) {
        _separatorLineOne = [UIView new];
        _separatorLineOne.backgroundColor = [UIColor colorSeparatorLine];
    }
    return _separatorLineOne;
}

- (NSMutableArray *)titles {
    if (!_titles) {
        _titles = [NSMutableArray arrayWithArray:@[@"订单详情", @"查看物流"]];
    }
    return _titles;
}

- (NSMutableArray *)buttons {
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

@end
