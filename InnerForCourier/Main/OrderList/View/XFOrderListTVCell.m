//
//  XFOrderListTVCell.m
//  InnerForCourier
//
//  Created by DamonLiao on 2017/2/4.
//  Copyright © 2017年 DamonLiao. All rights reserved.
//

#import "XFOrderListTVCell.h"
#import "XFGoods.h"
#import "XFOrderDetailsGoodsModel.h"

@interface XFOrderListTVCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end

@implementation XFOrderListTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setModel:(XFGoods *)model {
    _model = model;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:_model.goodImg] placeholderImage:[UIImage imageWithColor:[UIColor colorViewBG]]];
    self.titleLabel.text = _model.goodsName;
    
    self.unitLabel.text = _model.goodsUnit;
    
    self.countLabel.text = [NSString stringWithFormat:@" x %@", _model.goodsQty];
    
    NSString *priceString = [NSString stringWithFormat:@"￥%.2f",[_model.salePrice floatValue]];
    self.priceLabel.text = priceString;

    [self setNeedsUpdateConstraints];
    
}

- (void)setOrderDetailsGoodsModel:(XFOrderDetailsGoodsModel *)orderDetailsGoodsModel {
    _orderDetailsGoodsModel = orderDetailsGoodsModel;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:_orderDetailsGoodsModel.thumbnailsUrll] placeholderImage:[UIImage imageWithColor:[UIColor colorViewBG]]];
    
    self.titleLabel.text = _orderDetailsGoodsModel.goods_title;
    
    self.unitLabel.text = _orderDetailsGoodsModel.unit;
    
    self.countLabel.text = [NSString stringWithFormat:@" x %@", _orderDetailsGoodsModel.quantity];
    
    NSString *priceString = [NSString stringWithFormat:@"￥%.2f",[_orderDetailsGoodsModel.goods_price floatValue]];
    self.priceLabel.text = priceString;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
